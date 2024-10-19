import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Animation/Bounce.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Services/numberFormat.dart';
import 'package:srvc/Widgets/AnimatedLoadingBar.dart';
import 'package:srvc/Widgets/CPointer.dart';
import 'package:srvc/Widgets/CalendarViwer.dart';
import 'package:srvc/Widgets/TransactionContainer.dart';
import 'package:shimmer/shimmer.dart';

class TransactionCard extends StatefulWidget {
  final void Function(int?, int?)? onAction;
  const TransactionCard({super.key, this.onAction});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  late AuthProvider auth;
  final ApiService apiService = ApiService(serverURL);
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  int totalExpense = 0;
  int totalIncome = 0;
  List<Map<String, dynamic>> plans = [];
  late Future<List<Map<String, dynamic>>> expensesFuture;
  List<Map<String, dynamic>> ExpenseData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);

    expensesFuture = _loadExpense(Month: currentMonth, Year: currentYear);
  }

  Future<List<Map<String, dynamic>>> _loadExpense({required int Month, required int Year}) async {
    final responses = await apiService.post("/SRVC/MainPageController.php", {
      'act': 'getExpense',
      'phone': auth.phone,
      'currentYear': Year,
      'currentMonth': Month,
    });

    final expenseData = responses['data']['expense'];
    final plansResult = List<Map<String, dynamic>>.from(responses['data']['plans']);

    if (expenseData is List) {
      setState(() {
        totalIncome = 0;
        totalExpense = 0;
        ExpenseData = expenseData.map((item) {
          final data = item['data'];
          data.forEach((data) {
            final dataType = data['record_type'];
            final amount = int.parse(data['amount'].toString());
            dataType == "i" ? totalIncome += amount : totalExpense += amount;
          });

          return Map<String, dynamic>.from(item);
        }).toList();
        plans = plansResult;
      });
      return expenseData.map((item) => Map<String, dynamic>.from(item)).toList();
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: expensesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return Column(
          children: [
            _Card(planData: plans),
            _List(transactionData: snapshot.data ?? [], connectionState: snapshot.connectionState),
          ],
        );
      },
    );
  }

  Widget _Card({required List planData}) {
    return BounceAnimation(
      child: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CPointer(
                                onTap: () {
                                  setState(() {
                                    currentMonth = (currentMonth > 1) ? currentMonth - 1 : 12;
                                    currentYear -= (currentMonth == 12) ? 1 : 0;
                                  });
                                  expensesFuture = _loadExpense(Month: currentMonth, Year: currentYear);
                                },
                                child: const Icon(
                                  Icons.chevron_left,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: AutoSizeText(
                              "$currentMonth/$currentYear",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontFamily: 'thaifont',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CPointer(
                                onTap: () {
                                  setState(() {
                                    currentMonth = (currentMonth < 12) ? currentMonth + 1 : 1;
                                    currentYear += (currentMonth == 1) ? 1 : 0;
                                  });
                                  expensesFuture = _loadExpense(Month: currentMonth, Year: currentYear);
                                },
                                child: const Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextAnimationColumn(amount: "฿${formatNumber(totalIncome.toString(), withCommas: true)}", color: HexColor('#6ccb69'), label: 'รายได้', bold: true),
                          TextAnimationColumn(amount: "฿${formatNumber(totalExpense.toString(), withCommas: true)}", color: Colors.red, label: 'ค่าใช้จ่าย', bold: true),
                          TextAnimationColumn(
                              amount: "${totalExpense > totalIncome ? "-" : ''}฿${formatNumber("${totalExpense - totalIncome}", withCommas: true)}", color: Colors.red, label: 'คงเหลือ', bold: true),
                        ],
                      ),
                      if (planData.isNotEmpty) const Divider(height: 20),
                      SingleChildScrollView(
                        child: Column(
                          children: planData.map((plan) {
                            return AnimatedLoadingBar(
                              progress: (plan['current'] / plan['target']),
                              styleColor: HexColor(plan['color']),
                              label: "${plan['title']}",
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 15,
                child: CPointer(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalendarViewer(data: ExpenseData),
                        ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .035,
                    padding: EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/icons/calendar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _List({required List transactionData, required ConnectionState connectionState}) {
    var isLoading = (connectionState == ConnectionState.waiting);
    if (isLoading) transactionData = [];
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          if (isLoading)
            BounceAnimation(
              duration: Duration(seconds: 1),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  // color: Colors.grey[200],
                ),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 0,
                            ),
                          ],
                          color: Colors.white,
                        ),
                        height: 30,
                        width: MediaQuery.of(context).size.width * 1,
                      ),
                    );
                  },
                ),
              ),
            ),
          if (transactionData.isEmpty && !isLoading)
            BounceAnimation(
              duration: const Duration(seconds: 1),
              child: Container(
                width: double.infinity, // full width without MediaQuery
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // no need for const here
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/icons/empty-folder.png',
                      height: MediaQuery.of(context).size.height * 0.17,
                    ),
                    const AutoSizeText(
                      'ไม่พบรายการ รายรัยรายจ่าย',
                      maxLines: 1,
                      minFontSize: 20,
                      maxFontSize: 30,
                      style: TextStyle(
                        fontFamily: 'thaifont',
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ...List.generate(
            transactionData.length,
            (index) => BounceAnimation(
              child: Transactioncontainer(
                context,
                transactionData[index],
                index: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextAnimationColumn extends StatefulWidget {
  final String amount;
  final String label;
  final Color color;
  final bool bold;

  const TextAnimationColumn({
    super.key,
    required this.amount,
    required this.label,
    required this.color,
    this.bold = false,
  });

  @override
  _TextAnimationColumnState createState() => _TextAnimationColumnState();
}

class _TextAnimationColumnState extends State<TextAnimationColumn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void didUpdateWidget(TextAnimationColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _opacity,
          child: AutoSizeText(
            widget.amount,
            minFontSize: 14,
            maxFontSize: 16,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'thaifont',
              color: widget.color,
              fontWeight: widget.bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        AutoSizeText(
          widget.label,
          minFontSize: 12,
          maxFontSize: 12,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'thaifont',
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

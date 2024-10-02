import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Pages/FamilyPage.dart';
import 'package:srvc/Pages/LoginPage.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/_AddExpense.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/IndexProvider.dart';
import 'package:srvc/Services/auth_provider.dart';
import 'package:srvc/Services/dateformat.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  final ApiService apiService = ApiService(serverURL);

  bool mounted = false;
  List<Map<String, dynamic>> plans = [];
  List<Map<String, dynamic>> expenses = [];
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  String? userName;
  String? userPhone;
  @override
  void initState() {
    super.initState();
    _loadUserData();
    // logoutUser();
  }

  void logoutUser() {
    Provider.of<AuthProvider>(context, listen: false).logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _loadUserData() async {
    // final FamState = Provider.of<FamilyModel>(context, listen: false);
    final authProvider = context.read<AuthProvider>();
    userName = authProvider.name;
    userPhone = authProvider.phone;

    final responses = await Future.wait([_loadPlan(), _loadExpense()]);
    final planData = responses[0]['data'] ?? [];
    final expenseData = responses[1]['data'] ?? [];

    setState(() {
      plans = List<Map<String, dynamic>>.from(planData);
      expenses = List<Map<String, dynamic>>.from(expenseData);
    });
  }

  Future<Map<String, dynamic>> _loadPlan() {
    return apiService.post("/SRVC/MainPageController.php", {
      'act': 'getPlan',
      'phone': userPhone,
    });
  }

  Future<Map<String, dynamic>> _loadExpense() {
    return apiService.post("/SRVC/MainPageController.php", {
      'act': 'getExpense',
      'phone': userPhone,
      'currentYear': currentYear,
      'currentMonth': currentMonth,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppPallete.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 17,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 70,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FamilyPage()),
                              ),
                              child: Image.asset('assets/images/icons/family-symbol.png'),
                            ),
                            Positioned(
                              top: 5,
                              right: 10,
                              child: Container(
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.red,
                                ),
                                child: const Center(
                                  child: AutoSizeText(
                                    '0',
                                    maxLines: 1,
                                    minFontSize: 12,
                                    maxFontSize: 14,
                                    style: TextStyle(color: Colors.white, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const AutoSizeText.rich(
                          TextSpan(
                            text: "รู้ก่อน",
                            style: TextStyle(fontFamily: 'thaifont', color: Colors.indigo, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: " ดีกว่า",
                                style: TextStyle(color: Colors.orange, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          minFontSize: 20,
                          maxFontSize: 46,
                          overflow: TextOverflow.ellipsis),
                      GestureDetector(
                        onTap: () => logoutUser(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(FontAwesomeIcons.user),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    AutoSizeText(
                      "สวัสดีคุณ $userName",
                      maxLines: 1,
                      minFontSize: 16,
                      maxFontSize: 18,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: HexColor('#919191'), fontFamily: 'thaifont'),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Provider.of<IndexProvider>(context, listen: false).updateIndex(3);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [HexColor("#747dce"), HexColor("#010a86")],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return AutoSizeText(
                                  "ฟรีคอรสสำหรับการบริหารจัดการหนี้และการลุงทุน คลิกเลย!",
                                  maxLines: constraints.maxHeight <= 45 ? 1 : 2,
                                  minFontSize: 16,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'thaifont',
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            child: Image.asset(
                              'assets/images/icons/lern.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentMonth = (currentMonth > 1) ? currentMonth - 1 : 12;
                                    currentYear -= (currentMonth == 12) ? 1 : 0;
                                  });
                                  _loadUserData();
                                },
                                child: const Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  size: 13,
                                  color: Colors.grey,
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
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentMonth = (currentMonth < 12) ? currentMonth + 1 : 1;
                                    currentYear += (currentMonth == 1) ? 1 : 0;
                                  });
                                  _loadUserData();
                                },
                                child: const Icon(
                                  FontAwesomeIcons.arrowRight,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildColumn("-฿0.00", "ทั้งหมด", Colors.red, bold: true),
                            _buildColumn("฿0.00", "รายได้", const Color.fromARGB(255, 19, 209, 117), bold: true),
                            _buildColumn("฿0.00", "ค่าใช้จ่าย", Colors.red, bold: true),
                          ],
                        ),
                        if (plans.isNotEmpty)
                          const Divider(
                            height: 20,
                          ),
                        SingleChildScrollView(
                          child: Column(
                            children: plans.map((plan) {
                              return StaticLoadingBar(
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
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height * 1,
                  child: Column(
                    children: [
                      if (expenses.isEmpty)
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/icons/empty-folder.png',
                                height: 100,
                              ),
                              const AutoSizeText(
                                "ไม่พบรายการ รายรัยรายจ่าย",
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
                      ...List.generate(
                          expenses.length,
                          (index) => _ExpenseContainer(
                                context,
                                expenses[index],
                                index: index,
                              )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddExpense()),
              );
            },
            backgroundColor: Colors.white,
            child: const Icon(
              FontAwesomeIcons.add,
              color: Colors.indigo,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildColumn(String amount, String label, Color color, {bool bold = false}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      AutoSizeText(
        amount,
        minFontSize: 14,
        maxFontSize: 16,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'thaifont',
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      AutoSizeText(
        label,
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

class _ExpenseContainer extends StatefulWidget {
  final BuildContext context;
  final int index;
  final Map<String, dynamic> data;

  final void Function()? onTap;

  const _ExpenseContainer(this.context, this.data, {this.onTap, required this.index});

  @override
  __ExpenseContainerState createState() => __ExpenseContainerState();
}

class __ExpenseContainerState extends State<_ExpenseContainer> {
  bool state = false;
  List<Widget> expense_list = [];
  final formatter = ThaiDateFormatter();
  @override
  void initState() {
    super.initState();

    setState(() {
      expense_list = widget.data['data'].map<Widget>((item) {
        return ListTile(
          title: Text(item['id'].toString()),
          subtitle: Text(item['id'].toString()),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exp = widget.data;
    return Container(
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
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                state = !state; // Toggle state
              });
              if (widget.onTap != null) widget.onTap!();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: state == false ? const BorderRadius.all(Radius.circular(10)) : const BorderRadius.vertical(top: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(state == false ? 0 : 0.1),
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
                color: state == false ? Colors.orange[300] : HexColor("#ff9800"),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatter.format(exp['date'], type: ""), style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
                    Text("฿${widget.data['total']}", style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
                  ],
                ),
              ),
            ),
          ),
          if (state)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.white,
              ),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: expense_list.asMap().entries.map((entry) {
                  int index = entry.key;
                  return innerRow(index);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget innerRow(index) {
    final item = widget.data['data'][index];

    // print(index);
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.indigo[100],
            ),
            height: 50,
            width: 50,
            child: Center(child: Image.asset('assets/images/types/${item['type_img']}')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        item['type_name'],
                        minFontSize: 14,
                        maxFontSize: 14,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        item['for_who'],
                        minFontSize: 12,
                        maxFontSize: 12,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.grey, fontFamily: 'thaifont'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      item['amount'].toString(),
                      minFontSize: 12,
                      maxFontSize: 12,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.red, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      item['account_type_name'],
                      minFontSize: 12,
                      maxFontSize: 12,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontFamily: 'thaifont'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class StaticLoadingBar extends StatelessWidget {
  final double progress;
  final String label;
  final Color styleColor;

  const StaticLoadingBar({super.key, this.progress = 1, this.label = "Loading...", this.styleColor = Colors.orange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: styleColor,
            fontFamily: 'thaifont',
          ),
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#d7d7d7"),
              ),
              width: MediaQuery.of(context).size.width,
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: styleColor,
              ),
              width: MediaQuery.of(context).size.width * progress,
              height: 10,
            ),
            Center(
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'thaifont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

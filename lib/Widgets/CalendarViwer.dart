import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/Data.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Services/numberFormat.dart';
import 'package:srvc/Widgets/CPointer.dart';

class CalendarViewer extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CalendarViewer({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#eeeeee"),
      appBar: AppBar(
        leading: CPointer(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.chevron_left, size: 30, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text('ปฏิทิน', style: TextStyle(fontFamily: 'thaifont')),
      ),
      body: CalendarWidget(data: data),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const CalendarWidget({super.key, required this.data});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final ApiService apiService = ApiService(serverURL);

  late AuthProvider authProvider;
  late DateTime _focusedDate;
  late Map<String, int> _totalsByDate;

  List<Map<String, dynamic>> expenseData = [];
  List<Map<String, dynamic>> listData = [];
  String showDataType = "etotal";
  String? selectedDay;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _focusedDate = DateTime.now();
    selectedDay = "${_focusedDate.day}-${_focusedDate.month}-${_focusedDate.year}";

    expenseData = widget.data;
    _updateTotals();
    _selectDate(selectedDay!);
  }

  void _updateTotals() {
    _totalsByDate = {for (var record in expenseData) record['date']: record[showDataType]};
  }

  void _navigateMonth(int delta) {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + delta, 1);
      selectedDay = null;
      _updateTotals();
    });
    _loadExpenses(month: _focusedDate.month, year: _focusedDate.year);
  }

  Future<void> _loadExpenses({required int month, required int year}) async {
    setState(() => _isLoading = true);
    final response = await apiService.post("/SRVC/MainPageController.php", {
      'act': 'getExpense',
      'phone': authProvider.phone,
      'currentYear': year,
      'currentMonth': month,
    });
    final data = response['data']['expense'];

    if (data is List) {
      setState(() {
        expenseData = data.map((item) => Map<String, dynamic>.from(item)).toList();
        _updateTotals();
        _isLoading = false;
      });
    }
  }

  void _selectDate(String dateKey) {
    final foundRecord = expenseData.firstWhere(
      (record) => record['date'] == dateKey,
      orElse: () => {},
    );

    setState(() {
      listData = foundRecord.isNotEmpty ? List<Map<String, dynamic>>.from(foundRecord['data'] ?? []) : [];
      selectedDay = dateKey;
    });
  }

  void _changeTab(int index) {
    setState(() {
      showDataType = index == 0 ? "etotal" : "itotal";
    });
    _loadExpenses(month: _focusedDate.month, year: _focusedDate.year);
  }

  List<Widget> _buildCalendarDays() {
    List<Widget> days = [];
    final firstWeekday = DateTime(_focusedDate.year, _focusedDate.month, 1).weekday;
    final totalDaysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;

    for (int i = 1; i < firstWeekday; i++) {
      days.add(Container());
    }

    for (int day = 1; day <= totalDaysInMonth; day++) {
      final dateKey = '${day.toString().padLeft(2, '0')}-${_focusedDate.month.toString().padLeft(2, '0')}-${_focusedDate.year}';
      final total = _totalsByDate[dateKey] ?? 0;
      final isToday = day == DateTime.now().day && _focusedDate.month == DateTime.now().month && _focusedDate.year == DateTime.now().year;
      bool isSelected = selectedDay == dateKey;
      Color? boxColor = total > 0
          ? showDataType == "etotal"
              ? Colors.red.withOpacity(0.1)
              : Colors.green.withOpacity(0.1)
          : null;
      days.add(
        CPointer(
          onTap: () => _selectDate(dateKey),
          child: Container(
            decoration: BoxDecoration(
              color: _isLoading ? null : boxColor,
              border: isSelected ? Border.all(color: Colors.blue, width: 2) : (isToday ? Border.all(color: Colors.blue.withOpacity(0.3), width: 2) : null),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: AutoSizeText(
                          day.toString(),
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 10,
                          wrapWords: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (total > 0)
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: AutoSizeText(
                            formatNumber("$total", withCommas: true),
                            maxLines: 1,
                            minFontSize: 2,
                            maxFontSize: 20,
                            wrapWords: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: showDataType == "etotal" ? Colors.red : Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _navigateMonth(-1),
                  icon: const Icon(Icons.chevron_left, size: 30),
                ),
                Text(
                  '${thaiMonths[_focusedDate.month - 1]} ${_focusedDate.year}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => _navigateMonth(1),
                  icon: const Icon(Icons.chevron_right, size: 30),
                ),
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            children: _buildCalendarDays(),
          ),
          CustomTab(
            initialIndex: 0,
            changeTab: _changeTab,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            color: HexColor("#eeeeee"),
            child: ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final Expen = listData[index];
                final EType = Expen['record_type'];

                // if (EType != showDataType[0]) return null;

                return Visibility(
                  visible: (EType == showDataType[0]),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.115,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 3, color: EType == "e" ? Colors.red : Colors.green)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/images/types/${Expen['type_img']}'),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Expen['type_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(Expen['for_who'], style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${EType == 'e' ? '-' : '+'}฿${formatNumber("${Expen['amount']}", withCommas: true)}",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: EType == 'e' ? Colors.red : Colors.green)),
                              Text(Expen['account_type_name'], style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}

class CustomTab extends StatefulWidget {
  final int initialIndex;
  final ValueChanged<int> changeTab;

  const CustomTab({super.key, required this.initialIndex, required this.changeTab});

  @override
  _CustomTabState createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: "รายจ่าย"),
        Tab(text: "รายรับ"),
      ],
    );
  }
}

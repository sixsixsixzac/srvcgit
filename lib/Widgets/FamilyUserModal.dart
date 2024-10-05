import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Models/topExpense.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Services/APIService.dart';

import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Services/dateformat.dart';
import 'package:srvc/Services/numberFormat.dart';

class UserModal extends StatefulWidget {
  final VoidCallback onClose;
  final GroupMembersModel? userData;
  const UserModal({super.key, required this.onClose, this.userData});

  @override
  State<UserModal> createState() => _UserModalState();
}

class _UserModalState extends State<UserModal> {
  final ApiService apiService = ApiService(serverURL);
  final formatter = ThaiDateFormatter();

  List<Topexpense> expenseData = [];

  bool _isLoading = true;

  String? CurrentDate;
  String CurrentType = "day";
  String ModalLabel = '';

  int CurrentYear = DateTime.now().year;
  int CurrentIndex = 1;
  double ExpenseGrandTotal = 0.00;
  int PerMonth = 10000;

  @override
  void initState() {
    super.initState();
    _updateVariable('month', 1);
    _getTopExpense();
  }

  Future<List<Topexpense>> _getTopExpense() async {
    setState(() => _isLoading = true);
    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'getTopExpense',
      'userID': widget.userData!.id.toString(),
      'date': CurrentDate,
      'type': CurrentType,
    });
    Map<String, dynamic> data = response;
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      expenseData = (data['data'] as List).map((item) => Topexpense.fromJson(item)).toList();
      if (expenseData.isNotEmpty) ExpenseGrandTotal = expenseData[0].grand_total;
      if (expenseData.isEmpty) ExpenseGrandTotal = 0;
      _isLoading = false;
    });

    return expenseData;
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';

    return formattedDate;
  }

  void _updateVariable(type, index) {
    setState(() {
      ExpenseGrandTotal = 0.00;
      CurrentType = type;
      CurrentIndex = index;
      CurrentDate = getCurrentDate();
      ModalLabel = formatter.format(CurrentDate!, type: CurrentType);
    });
  }

  Color getColorForPercentage(double percentage) {
    if (percentage <= 25) {
      return HexColor('#58c472');
    } else if (percentage <= 50) {
      return HexColor('#7FFF7F');
    } else if (percentage <= 75) {
      return HexColor('#FF7F7F');
    } else {
      return HexColor('#FF0000');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            color: AppPallete.backgroundColor,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      NavTab(
                        label: "รายวัน",
                        index: 0,
                        currentIndex: CurrentIndex,
                        onTab: (index) async {
                          setState(() => _updateVariable('day', index));
                          await _getTopExpense();
                        },
                      ),
                      NavTab(
                        label: "รายเดือน",
                        index: 1,
                        currentIndex: CurrentIndex,
                        onTab: (index) async {
                          setState(() => _updateVariable('month', index));
                          await _getTopExpense();
                        },
                      ),
                      NavTab(
                        label: "รายปี",
                        index: 2,
                        currentIndex: CurrentIndex,
                        onTab: (index) async {
                          setState(() => _updateVariable('year', index));
                          await _getTopExpense();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    CurrentDate = formatter.back(CurrentDate!, CurrentType);
                                    ModalLabel = formatter.format(CurrentDate!, type: CurrentType);
                                    _getTopExpense();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HexColor('#4caf50'),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      )),
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  child: const Icon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  ModalLabel,
                                  maxLines: 1,
                                  minFontSize: 18,
                                  maxFontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold, color: Colors.grey[600]),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    CurrentDate = formatter.forward(CurrentDate!, CurrentType);
                                    ModalLabel = formatter.format(CurrentDate!, type: CurrentType);
                                    _getTopExpense();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: HexColor('#4caf50'),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      )),
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  child: const Icon(
                                    FontAwesomeIcons.arrowRight,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : (expenseData.isEmpty)
                                    ? Container(
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
                                              "ไม่พบรายการ",
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
                                      )
                                    : ListView.builder(
                                        itemCount: expenseData.length,
                                        itemBuilder: (context, index) {
                                          final expen = expenseData[index];

                                          return Container(
                                            margin: const EdgeInsets.only(bottom: 2),
                                            height: 60,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(8.00),
                                                            ),
                                                            color: Colors.indigo,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 1,
                                                                color: Colors.grey,
                                                                offset: Offset(0, 0),
                                                              ),
                                                            ]),
                                                        margin: const EdgeInsets.all(5),
                                                        width: double.infinity,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Center(
                                                                child: Container(
                                                                  decoration: const BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(8.00),
                                                                    ),
                                                                  ),
                                                                  height: 40,
                                                                  width: 40,
                                                                  child: Center(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(3.0),
                                                                      child: Image.asset('assets/images/types/${expen.type_name == "อื่นๆ" ? 'other.png' : expen.type_img}'),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 8,
                                                              child: Container(
                                                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    AutoSizeText(
                                                                      expen.type_name,
                                                                      maxLines: 1,
                                                                      minFontSize: 16,
                                                                      maxFontSize: 20,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: const TextStyle(color: Colors.white, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                                                                    ),
                                                                    AutoSizeText(
                                                                      '฿${formatNumber(expen.total_expense, withCommas: true)}',
                                                                      maxLines: 1,
                                                                      minFontSize: 16,
                                                                      maxFontSize: 20,
                                                                      overflow: TextOverflow.ellipsis,
                                                                      style: TextStyle(color: HexColor('#FABC3F'), fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        left: 0,
                                                        right: 0,
                                                        child: Align(
                                                          alignment: Alignment.topCenter,
                                                          child: AutoSizeText(
                                                            maxLines: 1,
                                                            minFontSize: 6,
                                                            maxFontSize: 20,
                                                            overflow: TextOverflow.ellipsis,
                                                            '${formatNumber(expen.percentage, removeDecimal: false)}%',
                                                            style: TextStyle(
                                                              fontFamily: 'thaifont',
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.grey[200]?.withOpacity(0.4),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Divider(
                                thickness: 3,
                                indent: 15,
                                endIndent: 15,
                                color: Colors.orange,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: AppPallete.backgroundColor,
                                    border: Border.all(width: 3, color: Colors.orange),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    )),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: const AutoSizeText(
                                  'สรุปผล',
                                  maxLines: 1,
                                  minFontSize: 18,
                                  style: TextStyle(fontFamily: 'thaifont', color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            color: AppPallete.backgroundColor,
                            child: SingleChildScrollView(
                              child: _ExpenseInfo(
                                CurrentType: CurrentType,
                                CurrentDate: CurrentDate!,
                                GrandTotal: ExpenseGrandTotal,
                                PerMonth: 10000,
                                formatter: formatter,
                                isLoading: _isLoading,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: widget.onClose,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(bottom: 5, top: 5),
                    height: 35,
                    width: 100,
                    child: Center(
                        child: Text(
                      "ปิด",
                      style: TextStyle(
                        fontFamily: 'thaifont',
                        fontWeight: FontWeight.bold,
                        color: AppPallete.white,
                        fontSize: 18,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpenseInfo extends StatefulWidget {
  final String CurrentType;
  final double GrandTotal;
  final int PerMonth;
  final String CurrentDate;
  final ThaiDateFormatter formatter;
  final bool isLoading;

  const _ExpenseInfo({required this.isLoading, required this.GrandTotal, required this.PerMonth, required this.CurrentDate, required this.formatter, required this.CurrentType});

  @override
  State<_ExpenseInfo> createState() => __ExpenseInfoState();
}

class __ExpenseInfoState extends State<_ExpenseInfo> {
  @override
  Widget build(BuildContext context) {
    if (widget.CurrentType == "day") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRow(
            label: 'ใช้ไปทั้งหมด',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.red[600]),
            value: '฿${formatNumber(widget.GrandTotal.toString(), removeDecimal: true, withCommas: true)}',
            valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.red[600]),
          ),
          _buildRow(
            label: 'ใช้ได้ต่อวัน',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
            value: '฿${formatNumber((widget.PerMonth / widget.formatter.getDaysInMonth(widget.CurrentDate.toString())).toString(), removeDecimal: true, withCommas: true)}',
            valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
          ),
          _buildRow(
            label: 'คงเหลือเดือนนี้',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
            value: '฿${formatNumber(30.toString(), removeDecimal: true, withCommas: true)}',
            valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
          ),
          _buildRow(
            label: 'วันเหลือในเดือนนี้',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
            value: '${widget.formatter.getDaysInMonth(widget.CurrentDate.toString()) - DateTime.now().day} วัน',
            valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
          ),
        ],
      );
    }
    if (widget.CurrentType == "month") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRow(
            label: 'วันเหลือในเดือนนี้',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
            value: '${widget.formatter.getDaysInMonth(widget.CurrentDate.toString()) - DateTime.now().day} วัน',
            valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
          ),
        ],
      );
    }
    if (widget.CurrentType == "year") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRow(
            label: 'asdasd',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
            value: '${widget.formatter.getDaysInMonth(widget.CurrentDate.toString()) - DateTime.now().day} วัน',
            valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
          ),
        ],
      );
    }
    return Text('');
  }

  Widget _buildRow({
    String label = "...",
    String value = "0.00",
    TextStyle valueStyle = const TextStyle(),
    TextStyle labelStyle = const TextStyle(),
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            label,
            maxLines: 1,
            minFontSize: 18,
            maxFontSize: 20,
            overflow: TextOverflow.ellipsis,
            style: labelStyle,
          ),
          AutoSizeText(
            widget.isLoading ? "Calculating..." : value,
            maxLines: 1,
            minFontSize: 18,
            maxFontSize: 20,
            overflow: TextOverflow.ellipsis,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}

class NavTab extends StatelessWidget {
  final Function(int) onTab;
  final String label;
  final int index;
  final int currentIndex;

  const NavTab({
    super.key,
    required this.onTab,
    required this.label,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = index == currentIndex ? Colors.indigo[700]! : Colors.indigo;
    return Expanded(
      child: InkWell(
        onTap: () => onTab(index),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          height: 50,
          child: Center(
            child: AutoSizeText(
              label,
              maxLines: 1,
              minFontSize: 18,
              maxFontSize: 26,
              style: const TextStyle(
                fontFamily: 'thaifont',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

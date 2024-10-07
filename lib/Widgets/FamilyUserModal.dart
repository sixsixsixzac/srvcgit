import 'dart:convert';
import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Models/topExpense.dart';
import 'package:srvc/Models/user.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Providers/FetchingHome.dart';
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
  Future<Map<String, dynamic>>? userDataFuture;

  Map<String, dynamic> UserData = {};
  List<Topexpense> ExpenseData = [];

  bool _isLoading = true;

  String? CurrentDate;
  String CurrentType = "month";
  String ModalLabel = '';

  int CurrentYear = DateTime.now().year;
  int CurrentIndex = 1;
  double ExpenseGrandTotal = 0.00;
  int PerMonth = 10000;

  @override
  void initState() {
    super.initState();
    userDataFuture = getUserLocalData();
    _updateVariable(CurrentType, 1);
    _fetching_data();
  }

  Future<void> _fetching_data() async {
    setState(() => _isLoading = true);
    await _getTopExpense();
    await _getUserDBData();
    setState(() => _isLoading = false);
  }

  Future<List<Topexpense>> _getTopExpense() async {
    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'getTopExpense',
      'userID': widget.userData!.id.toString(),
      'date': CurrentDate,
      'type': CurrentType,
    });
    Map<String, dynamic> data = response;

    // await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      ExpenseData = (data['data'] as List).map((item) => Topexpense.fromJson(item)).toList();

      if (ExpenseData.isNotEmpty) ExpenseGrandTotal = ExpenseData[0].grand_total;
      if (ExpenseData.isEmpty) ExpenseGrandTotal = 0;
    });

    return ExpenseData;
  }

  Future<Map<String, dynamic>> _getUserDBData() async {
    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'getUserDBData',
      'userID': widget.userData!.id.toString(),
      'date': CurrentDate,
      'type': CurrentType,
    });
    DateTime date = DateTime.parse(CurrentDate.toString().split('-').reversed.join('-'));
    int totalDaysInMonth = DateTime(date.year, date.month + 1, 0).day;
    setState(() {
      if (response['data'] is List) {
        List<dynamic> dataList = response['data'];
        UserData = dataList.isNotEmpty ? dataList[0] as Map<String, dynamic> : {};
      } else if (response['data'] is Map) {
        UserData = response['data'] as Map<String, dynamic>;
      } else {
        UserData = {};
      }

      if (UserData.isNotEmpty) UserData['moneyCanUse'] = (UserData['income'] ?? 0.00) / totalDaysInMonth;
    });

    return UserData;
  }

  Future<Map<String, dynamic>> getUserLocalData() async {
    final DataString = await Provider.of<UserDataProvider>(context, listen: false).getPref('UserData');
    final Data = jsonDecode(DataString!);
    return Data['data'] as Map<String, dynamic>;
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
    List<Map<String, dynamic>> getExpenseItems(String type, Map<String, dynamic> userData, List expenseData) {
      if (type == 'day') {
        return [
          {
            'label': "งบวันนี้",
            'value': "฿${formatNumber(userData['moneyCanUse'].toString(), withCommas: true)}",
          },
          {
            'label': "ใช้ไป(%)",
            'value': "${((expenseData.first.grand_total / userData['moneyCanUse']) * 100).toStringAsFixed(0)}%",
          },
          {
            'label': "คงเหลือ(วันนี้)",
            'value':
                (userData['moneyCanUse'] - expenseData.first.grand_total) <= 0 ? "฿0.00" : "฿${formatNumber((userData['moneyCanUse'] - expenseData.first.grand_total).toString(), withCommas: true)}",
          },
          {
            'label': "คงเหลือ(เดือนนี้)",
            'value': "฿${formatNumber((userData['result_value']).toString(), withCommas: true)}",
          },
        ];
      } else if (type == 'month') {
        final totalIncome = double.tryParse(userData['income'].toString()) ?? 0.0;
        final resultValue = double.tryParse(userData['result_value'].toString()) ?? 0.0;

        final spent = totalIncome - resultValue;
        final usedPercentage = (spent / totalIncome) * 100;
        DateTime date = DateTime.parse(
          CurrentDate.toString().split('-').reversed.join('-'),
        );
        DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
        int daysLeft = lastDayOfMonth.day - date.day;

        return [
          {
            'label': "งบเดือนนี้",
            'value': "฿${formatNumber(userData['income'].toString(), withCommas: true)}",
          },
          {
            'label': "ใช้ไป(%)",
            'value': (totalIncome == 0) ? "0%" : "${usedPercentage.toStringAsFixed(0)}%",
          },
          {
            'label': "คงเหลือ",
            'value': "฿${formatNumber(resultValue.toString(), withCommas: true)}",
          },
          {
            'label': "จำนวนวันที่เหลือ",
            'value': "$daysLeft วัน",
          }
        ];
      } else if (type == 'year') {}
      return [];
    }

    return FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No User Data found.'));
          } else {
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
                                  await _fetching_data();
                                },
                              ),
                              NavTab(
                                label: "รายเดือน",
                                index: 1,
                                currentIndex: CurrentIndex,
                                onTab: (index) async {
                                  setState(() => _updateVariable('month', index));
                                  await _fetching_data();
                                },
                              ),
                              NavTab(
                                label: "รายปี",
                                index: 2,
                                currentIndex: CurrentIndex,
                                onTab: (index) async {
                                  setState(() => _updateVariable('year', index));
                                  await _fetching_data();
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
                                            _fetching_data();
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
                                            _fetching_data();
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
                                        : (ExpenseData.isEmpty)
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
                                                itemCount: ExpenseData.length,
                                                itemBuilder: (context, index) {
                                                  final expen = ExpenseData[index];

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
                                      child: Column(
                                        children: [
                                          if (ExpenseData.isNotEmpty) ...[
                                            for (var item in getExpenseItems(CurrentType, UserData, ExpenseData)) ...[
                                              Container(
                                                margin: EdgeInsets.only(bottom: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    AutoSizeText(
                                                      item['label'].toString(),
                                                      maxLines: 1,
                                                      minFontSize: 18,
                                                      maxFontSize: 20,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold, fontFamily: 'thaifont'),
                                                    ),
                                                    AutoSizeText(
                                                      _isLoading == true ? "กำลังประมวลผล..." : item['value'].toString(),
                                                      maxLines: 1,
                                                      minFontSize: 18,
                                                      maxFontSize: 20,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontWeight: FontWeight.bold, color: _isLoading == true ? Colors.orange : const Color.fromARGB(255, 49, 49, 49)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ],
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
        });
  }
}

// if (widget.CurrentType == "year") {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       _buildRow(
//         label: 'รายจ่ายทั้งหมด',
//         labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
//         value: '',
//         valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
//       ),
//       _buildRow(
//         label: 'รายจ่ายเฉลี่ยต่อเดือน',
//         labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
//         value: '',
//         valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
//       ),
//       _buildRow(
//         label: 'งบเฉลี่ยต่อเดือน',
//         labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
//         value: '',
//         valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
//       ),
//       _buildRow(
//         label: 'จำนวนวันที่บันทึก',
//         labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont', color: Colors.black),
//         value: '',
//         valueStyle: TextStyle(fontFamily: 'thaifont', color: widget.isLoading ? Colors.orange : Colors.black),
//       ),
//     ],
//   );
// }
// ;

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

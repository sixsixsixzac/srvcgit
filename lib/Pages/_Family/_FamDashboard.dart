import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Pages/_Family/PieChartSample.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Services/Shortcut.dart';
import 'package:srvc/Services/numberFormat.dart';
import 'package:srvc/Widgets/CPointer.dart';

class FamilyDashboard extends StatefulWidget {
  const FamilyDashboard({super.key});

  @override
  State<FamilyDashboard> createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends State<FamilyDashboard> {
  final List<Map> PageState = [
    {"value": true, "name": "ค่าใช้จ่าย"},
    {'value': false, "name": "ข้อมูลบุคคล"}
  ];
  final List<Widget> mainChildren = [];
  late FamilyModel family;
  late Future dashboardData;
  final ApiService apiService = ApiService(serverURL);

  @override
  void initState() {
    super.initState();
    family = Provider.of<FamilyModel>(context, listen: false);
    dashboardData = getDashboardData();
  }

  Future getDashboardData() async {
    try {
      final response = await apiService.post("/SRVC/FamilyController.php", {
        'act': 'getDashboardData',
        'groupCode': family.groupCode,
      });
      return response;
    } catch (error) {
      print("Error fetching dashboard data: $error");
      rethrow;
    }
  }

  void _addWidget({Widget? widget}) {
    setState(() {
      mainChildren.add(Center(child: Text("Not finished yet...", style: TextStyle(fontSize: 30))));
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      for (int i = 0; i < PageState.length; i++) {
        PageState[i]['value'] = (i == index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(children: [
      Consumer<FamilyModel>(
        builder: (context, familyModel, child) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              color: HexColor("#ffffff"),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildAppBar(familyModel),
                    const SizedBox(height: 10),
                    _buildCenterRow(mediaQuery, PageState),
                    const SizedBox(height: 10),
                    _buildContentBox(
                      onTap: () {
                        _addWidget();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      ...mainChildren
    ]);
  }

  Widget _img({required String path}) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Colors.black),
        color: Colors.white,
      ),
      child: Image.asset(
        path,
        width: MediaQuery.of(context).size.width * 0.1,
      ),
    );
  }

  Widget _buildAppBar(FamilyModel familyModel) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppPallete.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              familyModel.title,
              style: TextStyle(color: AppPallete.purple, fontSize: 20),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CPointer(
              onTap: () => familyModel.setWName("home", title: "กลุ่มของฉัน"),
              child: Icon(
                Icons.chevron_left,
                color: AppPallete.purple,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterRow(MediaQueryData mediaQuery, List<Map> pageState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 35,
          width: mediaQuery.size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor("#5144b6"),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < pageState.length; i++)
                _buildCenterDataBox(
                  onTap: () => _onTabSelected(i),
                  pageState[i]['name'],
                  bg: pageState[i]['value'] == true ? AppPallete.white.withOpacity(0.5) : AppPallete.white.withOpacity(0),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenterDataBox(String text, {Color bg = Colors.transparent, required VoidCallback onTap}) {
    return Expanded(
      child: CPointer(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bg,
          ),
          margin: const EdgeInsets.all(3),
          height: double.infinity,
          child: Center(
            child: Text(text, style: TextStyle(color: AppPallete.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildContentBox({required VoidCallback onTap}) {
    final BoxDecoration boxDecoration = BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(.2))));

    return FutureBuilder(
        future: dashboardData,
        initialData: [],
        builder: (context, snapshot) {
          final PieData2 = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (PieData2['status'] == false) {
            return Center(child: Text("${PieData2['title']} ${PieData2['msg']}"));
          }
          final data = PieData2['data'] as List;
          final List<Map<String, double>> pieData = data
              .map((expense) {
                final percentage = expense['expense_percentage'] as double?;
                return percentage != null ? {'value': percentage} : {'value': 0.0};
              })
              .where((item) => item['value']! > 0)
              .toList();

          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: PieChartSample2(
                    PieData: pieData,
                    data: data,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Column(
                    children: (() {
                      List<Widget> children = [];
                      children.add(Container(
                        height: resize(context: context, type: 'h', value: 0.04),
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CPointer(
                              onTap: onTap,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.orange,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.date_range, color: Colors.white, size: 18),
                                    SizedBox(width: 5),
                                    Text("10/2567", style: TextStyle(fontFamily: 'thaifont', color: Colors.white)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                      for (int i = 0; i < pieData.length; i++) {
                        if ((data[i]['total_expense'] ?? 0) > 0) {
                          children.add(
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  _img(path: "assets/images/types/${data[i]['type_img']}"),
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: boxDecoration,
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data[i]['type_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    decoration: boxDecoration,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Text("฿${formatNumber("${data[i]['total_expense']}", withCommas: true)}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      return children;
                    }()),
                  ),
                )
              ],
            ),
          );
        });
  }
}

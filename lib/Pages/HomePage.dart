import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Pages/FillInformation.dart';
import 'package:srvc/Providers/FetchingHome.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/MainPage.dart';
import 'package:srvc/Pages/PlanPage.dart';
import 'package:srvc/Pages/SettingPage.dart';
import 'package:srvc/Pages/StudyPage.dart';
import 'package:srvc/Pages/WalletPage.dart';
import 'package:srvc/Widgets/CustomButtonBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ApiService _apiService;
  int currentIndex = 2;
  bool _fillIncome = false;

  late final List<Widget> _widgetPages;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(serverURL);

    // Initialize the _widgetPages list in initState
    _widgetPages = [
      WalletPage(),
      ReportPage(),
      Mainpage(
        ontab: (index) => updateIndex(index),
        currentIndex: currentIndex,
      ),
      StudyPage(),
      SettingPage(),
    ];

    _fetchUserData();
  }

  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future<void> _fetchUserData() async {
    try {
      final dataString = await Provider.of<UserDataProvider>(context, listen: false).getPref('ข้อมูลผู้ใช้');
      if (dataString == null) return;

      final data = jsonDecode(dataString);
      final userData = data['data'] as Map<String, dynamic>;

      if (userData.isNotEmpty && mounted) {
        final notHasIncomeData = userData['income'] == null;

        setState(() => _fillIncome = userData['income'] != null);
        if (notHasIncomeData) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FillinformationPage()),
            );
          }
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#f5f5f7"),
      body: _fillIncome ? SafeArea(child: _widgetPages[currentIndex]) : FillinformationPage(),
      bottomNavigationBar: _fillIncome
          ? CustomButtonBar(
              defaultIndex: currentIndex,
              imagePaths: const [
                'assets/images/icons/wallet.png',
                'assets/images/icons/analysis.png',
                'assets/images/icons/home.png',
                'assets/images/icons/graduate-cap.png',
                'assets/images/icons/settings.png',
              ],
              labels: const [
                'กระเป๋า',
                'รายงาน',
                'หน้าหลัก',
                'ศึกษา',
                'ตั้งค่า',
              ],
              onTap: (index) => updateIndex(index), // Updated to use the method
            )
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Pages/FillInformation.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/MainPage.dart';
import 'package:srvc/Pages/PlanPage.dart';
import 'package:srvc/Pages/SettingPage.dart';
import 'package:srvc/Pages/StudyPage.dart';
import 'package:srvc/Pages/WalletPage.dart';
import 'package:srvc/Services/IndexProvider.dart';
import 'package:srvc/Services/auth_provider.dart';
import 'package:srvc/Widgets/CustomButtonBar.dart';
import 'package:srvc/Widgets/Loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ApiService _apiService;
  bool _fillIncome = false;
  bool _isLoading = true;

  final List<Widget> _widgetPages = const [
    WalletPage(),
    ReportPage(),
    Mainpage(),
    StudyPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(serverURL);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fetchUserData(authProvider);
  }

  Future<void> _fetchUserData(AuthProvider authProvider) async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(milliseconds: 1000));
    if (authProvider.id.isNotEmpty) {
      try {
        final response = await _apiService.post("/SRVC/AuthController.php", {
          'act': 'getAuthUser',
          'userID': authProvider.id,
        });

        final userData = response['data'];
        _fillIncome = (userData['income'] ?? "").isNotEmpty;

        if (!_fillIncome) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FillinformationPage()),
          );
        }
      } catch (e) {}
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final indexProvider = Provider.of<IndexProvider>(context);

    return Scaffold(
      backgroundColor: HexColor("#f5f5f7"),
      body: _isLoading ? Loading() : (_fillIncome ? SafeArea(child: _widgetPages[indexProvider.currentIndex]) : FillinformationPage()),
      bottomNavigationBar: _fillIncome
          ? CustomButtonBar(
              defaultIndex: indexProvider.currentIndex,
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
              onTap: (index) => indexProvider.updateIndex(index),
            )
          : null,
    );
  }
}

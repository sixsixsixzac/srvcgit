import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/MainPage.dart';
import 'package:srvc/Pages/PlanPage.dart';
import 'package:srvc/Pages/SettingPage.dart';
import 'package:srvc/Pages/StudyPage.dart';
import 'package:srvc/Pages/WalletPage.dart';
import 'package:srvc/Services/IndexProvider.dart';
import 'package:srvc/Widgets/CustomButtonBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> widgetPages = <Widget>[
    const WalletPage(),
    const PlanPage(),
    const Mainpage(),
    const StudyPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final indexProvider = Provider.of<IndexProvider>(context);
    return Scaffold(
        backgroundColor: HexColor("#f5f5f7"),
        body: SafeArea(child: widgetPages[indexProvider.currentIndex]),
        bottomNavigationBar: CustomButtonBar(
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
        ));
  }
}

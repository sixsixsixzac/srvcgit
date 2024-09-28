import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Pages/LoginPage.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/MainPage.dart';
import 'package:srvc/Pages/PlanPage.dart';
import 'package:srvc/Pages/SettingPage.dart';
import 'package:srvc/Pages/StudyPage.dart';
import 'package:srvc/Pages/WalletPage.dart';
import 'package:srvc/Services/IndexProvider.dart';
import 'package:srvc/Services/auth_provider.dart';
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
        // appBar: AppBar(
        //   leading: const Icon(
        //     Icons.menu,
        //     color: Colors.grey,
        //   ),
        //   title: const AutoSizeText.rich(
        //       TextSpan(
        //         text: "รู้ก่อน",
        //         style: TextStyle(fontFamily: 'thaifont', color: Colors.indigo, fontWeight: FontWeight.bold),
        //         children: [
        //           TextSpan(
        //             text: " ดีกว่า",
        //             style: TextStyle(color: Colors.orange, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
        //           ),
        //         ],
        //       ),
        //       maxLines: 1,
        //       minFontSize: 16,
        //       maxFontSize: 46,
        //       overflow: TextOverflow.ellipsis),
        //   centerTitle: true,
        //   actions: [
        //     GestureDetector(
        //       onTap: () {},
        //       child: IconButton(
        //         icon: const Icon(
        //           Icons.account_circle,
        //           size: 36,
        //           color: Colors.indigo,
        //         ),
        //         onPressed: () => logoutUser(),
        //       ),
        //     ),
        //   ],
        // ),
        body: widgetPages[indexProvider.currentIndex],
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

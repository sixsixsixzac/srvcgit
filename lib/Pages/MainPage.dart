import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Animation/Bounce.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Pages/FamilyPage.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/_Expense/_AddExpense.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Widgets/UserTransactionCard.dart';

class Mainpage extends StatefulWidget {
  final Function(int) ontab;
  final int currentIndex;
  const Mainpage({super.key, required this.ontab, required this.currentIndex});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final ApiService apiService = ApiService(serverURL);
  List<Map<String, dynamic>> expenses = [];
  late AuthProvider auth;

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
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
                _NavBar(),
                _helloUser(),
                _StudyCard(),
                TransactionCard(),
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

  Widget _StudyCard() {
    return GestureDetector(
      onTap: () => widget.ontab(3),
      child: BounceAnimation(
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
    );
  }

  Widget _helloUser() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Row(
          children: [
            AutoSizeText(
              "สวัสดีคุณ ${auth.name}",
              maxLines: 1,
              minFontSize: 16,
              maxFontSize: 18,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: HexColor('#919191'), fontFamily: 'thaifont'),
            ),
          ],
        );
      },
    );
  }

  Widget _NavBar() {
    return Consumer<AuthProvider>(
      builder: (context, Auth, child) {
        return BounceAnimation(
          child: Container(
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
                  width: 40,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FamilyPage()),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/icons/family-symbol.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                AutoSizeText.rich(
                  TextSpan(
                    text: "รู้ก่อน",
                    style: TextStyle(
                      fontFamily: 'tumtuy',
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                    ),
                    children: [
                      TextSpan(
                        text: " ดีกว่า",
                        style: TextStyle(
                          color: Colors.orange,
                          fontFamily: 'tumtuy',
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  minFontSize: 16,
                  maxFontSize: (MediaQuery.of(context).size.width * 0.1).roundToDouble(),
                  overflow: TextOverflow.ellipsis,
                ),
                GestureDetector(
                  onTap: () => widget.ontab(4),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset('assets/images/profiles/${Auth.data['profile']}', fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

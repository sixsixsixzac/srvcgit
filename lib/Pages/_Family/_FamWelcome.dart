import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Services/APIService.dart';

class FamilyWelcomePage extends StatefulWidget {
  final VoidCallback onCreated;
  const FamilyWelcomePage({super.key, required this.onCreated});

  @override
  State<FamilyWelcomePage> createState() => _FamilyWelcomePageState();
}

class _FamilyWelcomePageState extends State<FamilyWelcomePage> {
  final ApiService apiService = ApiService(serverURL);

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyModel>(
      builder: (context, FamState, child) {
        return Container(
          color: Colors.indigo,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/icons/empty-folder.png', color: Colors.white, height: 200, width: 200),
                const Text("คุณยังไม่ได้สร้างกลุ่มสมาชิก", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'thaifont')),
                GestureDetector(
                  onTap: () => FamState.createGroup(context),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                    width: 150,
                    height: 35,
                    child: const Center(
                      child: Text("สร้างกลุ่ม", style: TextStyle(color: Colors.indigo, fontSize: 20, fontFamily: 'thaifont')),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => FamState.setWName('join', title: 'เข้าร่วมกลุ่ม'),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.orange),
                    width: 150,
                    height: 35,
                    child: const Center(
                      child: Text("เข้าร่วมกลุ่ม", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'thaifont')),
                    ),
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

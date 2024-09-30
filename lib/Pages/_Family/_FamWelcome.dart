import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/auth_provider.dart';

class FamilyWelcomePage extends StatefulWidget {
  const FamilyWelcomePage({super.key});

  @override
  State<FamilyWelcomePage> createState() => _FamilyWelcomePageState();
}

class _FamilyWelcomePageState extends State<FamilyWelcomePage> {
  final ApiService apiService = ApiService(serverURL);
  Future<void> _createGroup() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final FamState = Provider.of<FamilyModel>(context, listen: false);
    try {
      final data = await apiService.post("/SRVC/FamilyController.php", {
        'act': 'createGroup',
        'userID': auth.id,
      });

      if (data['status']) {
        // FamState.setCode(data['data']['group_code'].toString());
        // FamState.setHas(true);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: data['title'],
          text: data['msg'],
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      } else {
        print("Error: ${data['message']}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final FamState = Provider.of<FamilyModel>(context, listen: false);
    return Visibility(
      visible: (FamState.hasGroup == false && FamState.isJoining == false) ? true : false,
      child: Container(
        color: Colors.indigo,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/icons/empty-folder.png', color: Colors.white, height: 200, width: 200),
              const Text("คุณยังไม่ได้สร้างกลุ่มสมาชิก", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'thaifont')),
              GestureDetector(
                onTap: _createGroup,
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
                onTap: () {
                  FamState.setJoin(true);
                  FamState.setTitle('เข้าร่วมกลุ่ม');
                },
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
      ),
    );
  }
}

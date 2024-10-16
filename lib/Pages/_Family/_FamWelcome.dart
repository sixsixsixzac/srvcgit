import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Providers/AuthProvider.dart';

class FamilyWelcomePage extends StatefulWidget {
  final VoidCallback onCreated;
  const FamilyWelcomePage({super.key, required this.onCreated});

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
        FamState.setCode(data['data']['group_code'].toString());
        FamState.setTitle('กลุ่มของฉัน');
        FamState.setHas(true);
        FamState.setMember((data['data']['members'] as List<dynamic>).map((item) => GroupMembersModel.fromJson(item)).toList());
      } else {
        print("Error: ${data['title']}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<Map<String, dynamic>> _fetch_check_group(String userId) async {
    return await apiService.post("/SRVC/FamilyController.php", {
      'act': 'checkGroup',
      'userID': userId,
    });
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

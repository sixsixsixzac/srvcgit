import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Pages/_Family/_FamHome.dart';
import 'package:srvc/Pages/_Family/_FamJoin.dart';
import 'package:srvc/Pages/_Family/_FamWelcome.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/auth_provider.dart';
import 'dart:async';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final ApiService apiService = ApiService(serverURL);

  String? groupCode;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkGroup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkGroup() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    setState(() => _isLoading = true);
    try {
      final response = await _fetch_check_group(auth.id);

      _updateStateWithResponse(response);
    } catch (e) {
      _handleError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>> _fetch_check_group(String userId) async {
    return await apiService.post("/SRVC/FamilyController.php", {
      'act': 'checkGroup',
      'userID': userId,
    });
  }

  void _updateStateWithResponse(Map<String, dynamic> response) {
    try {
      final groupData = response['data'] ?? {};
      final hasGroup = response['status'] as bool;
      final FamState = Provider.of<FamilyModel>(context, listen: false);

      setState(() {
        FamState.setHas(hasGroup);
        FamState.setTitle(hasGroup ? "กลุ่มของฉัน" : "สร้างกลุ่ม");

        groupCode = groupData.isNotEmpty ? groupData['group_code'].toString() : "";

        if (hasGroup == true) {
          FamState.setCode(groupCode.toString());
          FamState.setLevel(groupData['level'] ?? "");
          _updateGroupMembers(response['data']['members'] ?? []);
        }
      });
    } catch (e, stackTrace) {
      // Print or log the error and stack trace
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');

      // Optionally, you can also show an error message to the user
      // or handle the error in a specific way.
    }
  }

  void _updateGroupMembers(List<dynamic> membersData) {
    final FamState = Provider.of<FamilyModel>(context, listen: false);
    FamState.setMember(membersData.map((member) => GroupMembersModel.fromJson(member as Map<String, dynamic>)).toList()..sort((a, b) => a.level.compareTo(b.level)));
  }

  void _handleError(dynamic error) {
    print("An error occurred: $error");
  }

  void _leaveGroup(BuildContext context) {
    // final familyModel = Provider.of<FamilyModel>(context);
    // setState(() {

    // });
    // QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.confirm,
    //   title: 'ยืนยัน',
    //   text: 'คุณต้องการออกจากกลุ่มใช่หรือไม่?',
    //   confirmBtnText: 'ใช่',
    //   cancelBtnText: 'ไม่',
    //   confirmBtnColor: Colors.red,
    //   onConfirmBtnTap: () {
    //     print('User confirmed to leave the group');
    //     Navigator.pop(context);
    //   },
    //   onCancelBtnTap: () {
    //     print('User canceled leaving the group');
    //     Navigator.pop(context);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final FamState = Provider.of<FamilyModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (FamState.hasGroup) const CustomPopupMenuButton(),
        ],
        backgroundColor: AppPallete.purple,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 20),
          onPressed: () {
            if (FamState.isJoining) {
              FamState.setJoin(false);
              FamState.setTitle("สร้างกลุ่ม");
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(FamState.title, style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
      ),
      body: Stack(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!FamState.hasGroup && !FamState.isJoining) FamilyWelcomePage(onCreated: () => _checkGroup),
          if (FamState.hasGroup) FamilyHomePage(groupCode: FamState.groupCode, groupMembers: FamState.members),
          if (FamState.isJoining) const FamilyJoinGroupPage(),
        ],
      ),
    );
  }
}

class CustomPopupMenuButton extends StatelessWidget {
  const CustomPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        icon: const Icon(FontAwesomeIcons.ellipsisV, color: Colors.white),
        onSelected: (action) {
          _groupAction(action);
        },
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<String>(
              value: 'levelGroup',
              child: Text(
                'ออกจากกลุ่ม',
                style: TextStyle(fontFamily: 'thaifont'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delGroup',
              child: Text(
                'ลบกลุ่ม',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'thaifont'),
              ),
            ),
          ];
        },
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _groupAction(String action) {
    print('Selected action: $action');
  }
}

class FamState {
  static String level = "M";
}

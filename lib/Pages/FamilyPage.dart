import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Pages/_Family/_FamHome.dart';
import 'package:srvc/Pages/_Family/_FamJoin.dart';
import 'package:srvc/Pages/_Family/_FamWelcome.dart';
import 'package:srvc/Services/APIService.dart';
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

  @override
  Widget build(BuildContext context) {
    final FamState = Provider.of<FamilyModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(FontAwesomeIcons.ellipsisV, color: Colors.white),
            onSelected: (value) {
              // Handle the selected value here
              print('Selected: $value');
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  onTap: () => _leaveGroup(context),
                  value: 'ออกจากกลุ่ม ',
                  child: const Text(
                    'ออกจากกลุ่ม',
                    style: TextStyle(fontFamily: 'thaifont'),
                  ),
                ),
              ];
            },
          ),
        ],
        backgroundColor: Colors.indigo,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 20),
          onPressed: () => FamState.isJoining == true ? FamState.setJoin(false) : Navigator.pop(context),
        ),
        title: Text(FamState.title, style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
      ),
      body: Stack(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!FamState.hasGroup && !FamState.isJoining) const FamilyWelcomePage(),
          if (FamState.hasGroup) FamilyHomePage(groupCode: FamState.groupCode, groupMembers: FamState.members),
          if (FamState.isJoining) const FamilyJoinGroupPage(),
        ],
      ),
    );
  }

  Future<void> _checkGroup() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final familyState = Provider.of<FamilyModel>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      final response = await _fetch_check_group(auth.id);
      _updateStateWithResponse(response, familyState);
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

  void _updateStateWithResponse(Map<String, dynamic> response, FamilyModel familyState) {
    final groupData = response['data'] ?? {};
    final hasGroup = response['status'] as bool;

    setState(() {
      familyState.setHas(hasGroup);
      familyState.setTitle(hasGroup ? "กลุ่มของฉัน" : "สร้างกลุ่ม");
      groupCode = groupData.isNotEmpty ? groupData['group_code'].toString() : "";

      if (hasGroup) {
        _updateGroupMembers(response['data']['members']);
      }
    });
  }

  void _updateGroupMembers(List<dynamic> membersData) {
    final FamState = Provider.of<FamilyModel>(context, listen: false);
    FamState.setMember(membersData.map((member) => GroupMembersModel.fromJson(member as Map<String, dynamic>)).toList()..sort((a, b) => a.level.compareTo(b.level)));
  }

  void _handleError(dynamic error) {
    print("An error occurred: $error");
    // Consider adding more robust error handling here
  }

  void __leaveGroup(BuildContext context) {
    // final familyModel = Provider.of<FamilyModel>(context, listen: false);
    // familyModel.setCode("asdๅๅ/-asd");
    // Add your logic to handle leaving the group here
  }

  void _leaveGroup(BuildContext context) {
    // final familyModel = Provider.of<FamilyModel>(context);
    // setState(() {

    // });
    // Show confirmation dialog using QuickAlert
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'ยืนยัน',
      text: 'คุณต้องการออกจากกลุ่มใช่หรือไม่?',
      confirmBtnText: 'ใช่',
      cancelBtnText: 'ไม่',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () {
        print('User confirmed to leave the group');
        Navigator.pop(context);
      },
      onCancelBtnTap: () {
        // Handle the action when user cancels
        print('User canceled leaving the group');
        Navigator.pop(context);
      },
    );
  }
}

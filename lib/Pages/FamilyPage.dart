import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Pages/_Family/_FamHome.dart';
import 'package:srvc/Pages/_Family/_FamJoin.dart';
import 'package:srvc/Pages/_Family/_FamWelcome.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/HexColor.dart';
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
    setState(() {
      _isLoading = true;
    });
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
      print('Error occurred: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _updateGroupMembers(List<dynamic> membersData) {
    final FamState = Provider.of<FamilyModel>(context, listen: false);
    FamState.setMember(membersData.map((member) => GroupMembersModel.fromJson(member as Map<String, dynamic>)).toList()..sort((a, b) => a.level.compareTo(b.level)));
  }

  void _handleError(dynamic error) {
    print("An error occurred: $error");
  }

  void refreshGroupStatus() {
    _checkGroup();
  }

  @override
  Widget build(BuildContext context) {
    final FamState = Provider.of<FamilyModel>(context, listen: true);
    return Scaffold(
      backgroundColor: (_isLoading == true) ? Colors.indigo : HexColor('#ffffff'),
      appBar: FamState.isModalVisible
          ? null
          : AppBar(
              actions: [
                if (FamState.hasGroup)
                  CustomPopupMenuButton(
                    FamState: FamState,
                    onFetchSuccess: refreshGroupStatus,
                  ),
              ],
              backgroundColor: AppPallete.purple,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 20),
                onPressed: () {
                  if (FamState.isJoining && FamState.hasGroup == false) {
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
          if (_isLoading)
            Container(
                color: Colors.indigo,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ))
          else if (!FamState.hasGroup && !FamState.isJoining)
            FamilyWelcomePage(onCreated: () => _checkGroup())
          else if (FamState.hasGroup)
            FamilyHomePage(groupCode: FamState.groupCode, groupMembers: FamState.members)
          else if (FamState.isJoining)
            FamilyJoinGroupPage(joined: () => _checkGroup()),
        ],
      ),
    );
  }
}

class CustomPopupMenuButton extends StatelessWidget {
  final FamilyModel FamState;
  final Function onFetchSuccess;
  CustomPopupMenuButton({super.key, required this.FamState, required this.onFetchSuccess});
  final ApiService apiService = ApiService(serverURL);
  Future<void> _groupAction(BuildContext context, String action, String groupCode) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await apiService.post("/SRVC/FamilyController.php", {
        'act': action,
        'groupCode': groupCode,
        'userID': auth.id,
      });

      bool fetchStatus = response['status'];
      if (fetchStatus == true) {
        onFetchSuccess();
      } else {}
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        icon: const Icon(
          FontAwesomeIcons.ellipsisV,
          color: Colors.white,
        ),
        onSelected: (action) {
          _groupAction(context, action, FamState.groupCode);
        },
        itemBuilder: (BuildContext context) {
          return [
            if (FamState.level != "A")
              const PopupMenuItem<String>(
                value: 'levelGroup',
                child: Text(
                  'ออกจากกลุ่ม',
                  style: TextStyle(fontFamily: 'thaifont'),
                ),
              ),
            if (FamState.level == "A")
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
}

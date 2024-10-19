import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Pages/_Family/_FamDashboard.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Pages/_Family/_FamHome.dart';
import 'package:srvc/Pages/_Family/_FamJoin.dart';
import 'package:srvc/Pages/_Family/_FamWelcome.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'dart:async';
import 'package:srvc/Widgets/CPointer.dart';
import 'package:srvc/Widgets/CustomPopupMenuButton.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late FamilyModel familyModel;
  final ApiService apiService = ApiService(serverURL);
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    familyModel = Provider.of<FamilyModel>(context, listen: false);
    _checkGroup(familyModel);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkGroup(FamilyModel familyModel) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _fetch_check_group(auth.id);

      _updateStateWithResponse(response, familyModel);
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

  void _updateStateWithResponse(Map<String, dynamic> response, FamilyModel familyModel) {
    try {
      final groupData = response['data'] ?? {};
      final hasGroup = response['status'] as bool;

      final String wName = hasGroup ? "home" : "welcome";
      final String title = hasGroup ? "กลุ่มของฉัน" : "สร้างกลุ่ม";

      familyModel.setWName(wName, title: title);

      if (hasGroup == true) {
        familyModel.setCode(groupData['group_code'].toString());
        familyModel.setLevel(groupData['level'] ?? "");
        _updateGroupMembers(response['data']['members'] ?? []);
      } else {
        familyModel.reset();
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _updateGroupMembers(List<dynamic> membersData) {
    final FamState = Provider.of<FamilyModel>(context, listen: false);
    FamState.setMember(membersData.map((member) => GroupMembersModel.fromJson(member as Map<String, dynamic>)).toList()..sort((a, b) => a.level.compareTo(b.level)));
  }

  void _handleError(dynamic error) {
    print("An error occurred: $error");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyModel>(
      builder: (context, familyModel, child) {
        return Scaffold(
          backgroundColor: AppPallete.white,
          appBar: _buildAppBar(familyModel),
          body: _buildBody(familyModel),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar(FamilyModel familyModel) {
    if (familyModel.isModalVisible || familyModel.title == "สร้างกลุ่ม" || familyModel.title == "ภาพรวม") return null;

    return PreferredSize(
      preferredSize: Size.fromHeight(56.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppPallete.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (familyModel.showBack)
              Align(
                alignment: Alignment.centerLeft,
                child: CPointer(
                  onTap: () => familyModel.setWName("home", title: 'กลุ่มของฉัน'),
                  child: Icon(Icons.chevron_left, color: AppPallete.purple, size: 30),
                ),
              ),
            Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                familyModel.title,
                maxLines: 1,
                minFontSize: 18,
                maxFontSize: 26,
                style: TextStyle(color: AppPallete.purple, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
              ),
            ),
            if (familyModel.widget_name == 'home')
              Align(
                alignment: Alignment.centerRight,
                child: CustomPopupMenuButton(
                  ontap: (type) => (type == "dashboard") ? familyModel.setWName("dashboard", title: 'ภาพรวม', showBack: true) : null,
                  famState: familyModel,
                  onFetchSuccess: _checkGroup,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(FamilyModel familyModel) {
    if (_isLoading) return Center(child: CircularProgressIndicator());

    final Map Widgets = {
      "home": FamilyHomePage(groupCode: familyModel.groupCode, groupMembers: familyModel.members),
      "dashboard": FamilyDashboard(),
      "loading": Center(child: CircularProgressIndicator(color: Colors.white)),
      "welcome": FamilyWelcomePage(onCreated: () => _checkGroup(familyModel)),
      "join": FamilyJoinGroupPage(joined: () => _checkGroup(familyModel)),
    };
    return Widgets[familyModel.widget_name] ?? Widgets["welcome"];
  }
}

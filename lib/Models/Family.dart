import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Services/APIService.dart';

class FamilyModel with ChangeNotifier {
  final ApiService apiService = ApiService(serverURL);
  List<GroupMembersModel> _members = [];
  String _groupCode = '';

  String _level = '';
  String _title = '';
  String _widget_name = "welcome";

  bool _isModalVisible = false;
  bool _showBack = false;

  FamilyModel();

  List<GroupMembersModel> get members => _members;

  String get groupCode => _groupCode;
  String get level => _level;

  String get widget_name => _widget_name;
  String get title => _title;

  bool get isModalVisible => _isModalVisible;
  bool get showBack => _showBack;

  void reset() {
    _widget_name = "";
    _title = '';
    _groupCode = '';
    _members = [];
    _showBack = false;
    _isModalVisible = false;

    notifyListeners();
  }

  void setCode(String text) {
    _groupCode = text;
    notifyListeners();
  }

  void setWName(String text, {bool showBack = false, required String title}) {
    _widget_name = text;
    _title = title;
    _showBack = showBack;
    notifyListeners();
  }

  void setLevel(String text) {
    _level = text;
    notifyListeners();
  }

  void setModal(bool state) {
    _isModalVisible = state;
    notifyListeners();
  }

  void setMember(List<GroupMembersModel> list) {
    _members = list;
    notifyListeners();
  }

  void removeMembersExcept(int idToKeep) {
    _members = _members.where((member) => member.id == idToKeep).toList();
    notifyListeners();
  }

  Future<void> createGroup(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final data = await apiService.post("/SRVC/FamilyController.php", {
        'act': 'createGroup',
        'userID': auth.id,
      });

      if (data['status']) {
        _groupCode = data['data']['group_code'];
        _level = "A";
        _members = (data['data']['members'] as List<dynamic>).map((item) => GroupMembersModel.fromJson(item)).toList();
        _widget_name = "home";
        _title = "กลุ่มของฉัน";

        notifyListeners();
      } else {
        print("Error: ${data['title']}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}

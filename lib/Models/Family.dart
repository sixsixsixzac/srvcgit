import 'package:flutter/material.dart';
import 'package:srvc/Models/group_members.dart';

class FamilyModel with ChangeNotifier {
  List<GroupMembersModel> _members = [];
  String _groupCode = '';
  String _title = '';
  bool _hasGroup = false;
  bool _isJoining = false;
  String _currentState = "";

  FamilyModel();

  String get title => _title;
  List<GroupMembersModel> get members => _members;
  String get groupCode => _groupCode;
  String get currentState => _currentState;
  bool get hasGroup => _hasGroup;
  bool get isJoining => _isJoining;
  void reset() {
    _groupCode = '';
    _title = '';
    _hasGroup = false;
    _isJoining = false;
    _currentState = "";

    notifyListeners();
  }

  void setCode(String text) {
    _groupCode = text;
    notifyListeners();
  }

  void setState(String text) {
    _currentState = text;
    notifyListeners();
  }

  void setTitle(String text) {
    _title = text;
    notifyListeners();
  }

  void setHas(bool state) {
    _hasGroup = state;
    notifyListeners();
  }

  void setJoin(bool state) {
    _isJoining = state;
    notifyListeners();
  }
  void setMember(List<GroupMembersModel> list) {
    _members = list;
    notifyListeners();
  }

  void displayWidget() {
    if (this.hasGroup == true) ;
  }
}

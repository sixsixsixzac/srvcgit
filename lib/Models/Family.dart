import 'package:flutter/material.dart';
import 'package:srvc/Models/group_members.dart';

class FamilyModel with ChangeNotifier {
  List<GroupMembersModel> _members = [];
  String _groupCode = '';
  String _title = '';
  String _level = '';
  String _currentState = "";

  bool _hasGroup = false;
  bool _isModalVisible = false;
  bool _isJoining = false;

  FamilyModel();

  List<GroupMembersModel> get members => _members;

  String get title => _title;
  String get groupCode => _groupCode;
  String get level => _level;
  String get currentState => _currentState;

  bool get hasGroup => _hasGroup;
  bool get isModalVisible => _isModalVisible;
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

  void setLevel(String text) {
    _level = text;
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

  void displayWidget() {
    if (hasGroup == true) {}
  }
}

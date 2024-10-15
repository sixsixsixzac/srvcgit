import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _id = '';
  String _name = '';
  String _phone = '';
  Map<String, dynamic> _userData = {};
  bool get isLoggedIn => _isLoggedIn;
  String get id => _id;
  String get name => _name;
  String get phone => _phone;
  Map<String, dynamic> get data => _userData;

  Future<void> login(Map<String, dynamic> data) async {
    if (data.isNotEmpty && data['id'] != null) {
      try {
        _id = data['id'].toString();
        _name = data['name'] ?? 'Unknown';
        _phone = data['phone']?.toString() ?? 'N/A';
        _userData = data;
        await _saveLoginStatus();
        notifyListeners();
      } catch (e) {
        print('Error during login: $e');
      }
    } else {
      print('User data is invalid or not found');
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _id = '';
    _name = '';
    _phone = '';
    await _removeLoginStatus();
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (_isLoggedIn == false) return _removeLoginStatus();
    _id = prefs.getString('id') ?? '';
    _name = prefs.getString('name') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _userData = jsonDecode(prefs.getString('data') ?? '{}');
    notifyListeners();
  }

  Future<void> saveData(Map<String, dynamic> Data) async {
    _userData = Data;
    await _saveLoginStatus();
    notifyListeners();
  }

  Future<void> _saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userInfoJson = jsonEncode(_userData);
    await prefs.setString('data', userInfoJson);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('id', _id);
    await prefs.setString('name', _name);
    await prefs.setString('phone', _phone);
  }

  Future<void> _removeLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('data');
    await prefs.remove('isLoggedIn');
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('phone');
  }
}

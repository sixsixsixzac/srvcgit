import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _id = ''; // Added ID field
  String _name = '';
  String _phone = '';

  bool get isLoggedIn => _isLoggedIn;
  String get id => _id; // Getter for ID
  String get name => _name;
  String get phone => _phone;

  Future<void> login(String id, String name, String phone) async {
    _isLoggedIn = true;
    _id = id;
    _name = name;
    _phone = phone;
    await _saveLoginStatus();
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _id = ''; // Clear ID on logout
    _name = '';
    _phone = '';
    await _removeLoginStatus();
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _id = prefs.getString('id') ?? ''; // Load ID
    _name = prefs.getString('name') ?? '';
    _phone = prefs.getString('phone') ?? '';
    notifyListeners();
  }

  Future<void> _saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('id', _id); // Save ID
    await prefs.setString('name', _name);
    await prefs.setString('phone', _phone);
  }

  Future<void> _removeLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('id'); // Remove ID
    await prefs.remove('name');
    await prefs.remove('phone');
  }
}

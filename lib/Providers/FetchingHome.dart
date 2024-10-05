import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srvc/Services/APIService.dart';

class UserDataProvider with ChangeNotifier {
  final Map<String, Map<String, dynamic>> _data = {};
  bool _isLoading = false;
  final List<String> _fetchStatusMessages = [];
  final Map<String, bool> _loadingStates = {};

  Map<String, Map<String, dynamic>> get data => _data;
  bool get isLoading => _isLoading;
  List<String> get fetchStatusMessages => _fetchStatusMessages;

  Future<void> fetchData(BuildContext context, int userID, ApiService apiService) async {
    _isLoading = true;
    notifyListeners();
    _fetchStatusMessages.clear();

    final dataMap = {
      'ข้อมูลผู้ใช้': () => _getUserData(userID, apiService),
      'ข้อมูลกลุ่มสมาชิก': () => _getUserGroup(userID, apiService),
      'ข้อมูลสมาชิก': () => _getGroupData(userID, apiService),
    };

    for (var entry in dataMap.entries) {
      _loadingStates[entry.key] = true;
      notifyListeners();

      _fetchStatusMessages.add('กำลังโหลด ${entry.key}...');
      notifyListeners();

      try {
        final result = await entry.value();

        _data[entry.key] = {
          'text': result['text'],
          'status': result['status'],
          'data': result['data'],
          'success': true,
        };

        await _save(entry.key, result);

        _fetchStatusMessages.removeLast();
        // _fetchStatusMessages.add('${entry.key} loaded successfully.');
      } catch (e) {
        _data[entry.key] = {
          'text': 'Error loading ${entry.key}',
          'data': null,
          'status': false,
          'success': false,
        };
        _fetchStatusMessages.removeLast();
        _fetchStatusMessages.add('Error loading ${entry.key}');
      } finally {
        _loadingStates[entry.key] = false;
        notifyListeners();
      }
    }

    _isLoading = false;
    Navigator.pushReplacementNamed(context, '/Home');
    notifyListeners();
  }

  bool isEntryLoading(String key) => _loadingStates[key] ?? false;

  Future<void> _save(String key, dynamic result) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(result));
  }

  Future<String?> getPref(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<Map<String, dynamic>> _getUserData(int userID, ApiService apiService) async {
    // await Future.delayed(Duration(milliseconds: 350));
    final response = await apiService.post("/SRVC/AuthController.php", {
      'act': 'getAuthUser',
      'userID': userID,
    });
    return {'text': 'ข้อมูลผู้ใช้', 'status': response['status'], 'data': response['data']};
  }

  Future<Map<String, dynamic>> _getUserGroup(int userID, ApiService apiService) async {
    // await Future.delayed(Duration(milliseconds: 350));
    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'getGroup',
      'userID': userID,
    });
    return {'text': 'ข้อมูลกลุ่มสมาชิก', 'status': response['status'], 'data': response['data']};
  }

  Future<Map<String, dynamic>> _getGroupData(int userID, ApiService apiService) async {
    // await Future.delayed(Duration(milliseconds: 350));
    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'checkGroup',
      'userID': userID,
    });
    return {'text': 'ข้อมูลสมาชิก', 'status': response['status'], 'data': response['data']};
  }

  void updateUserData(String key, Map<String, dynamic> newData) {
    if (_data.containsKey(key)) {
      _data[key] = {
        'text': newData['text'],
        'status': newData['status'],
        'data': newData['data'],
        'success': true,
      };
      notifyListeners();
    } else {
      print('No data found for key: $key');
    }
  }

  void updateIncome(String newIncome) async {
    final prefs = await SharedPreferences.getInstance();

    String? userDataString = prefs.getString('ข้อมูลผู้ใช้');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);

      if (userData['data'] != null) {
        userData['data']['income'] = newIncome;

        await prefs.setString('ข้อมูลผู้ใช้', jsonEncode(userData));

        notifyListeners();
      } else {
        print('Income data is null in user data');
      }
    } else {
      print('No user data found in Shared Preferences');
    }
  }
}

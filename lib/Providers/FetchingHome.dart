import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:srvc/Pages/HomePage.dart';
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
      'UserData': () => _getUserData(userID, apiService),
      'ExpenseData': () => _getUserExpense(userID, apiService),
      'GroupMemberData': () => _getUserGroup(userID, apiService),
      'MemberData': () => _getGroupData(userID, apiService),
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
      } catch (e) {
        _data[entry.key] = {
          'text': "ไม่พบข้อมูล ${entry.key}",
          'data': null,
          'status': false,
          'success': false,
        };
        _fetchStatusMessages.removeLast();
      } finally {
        _loadingStates[entry.key] = false;
        notifyListeners();
      }
    }

    _isLoading = false;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeIn;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
      ),
    );
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
    await Future.delayed(Duration(milliseconds: 0));

    final response = await apiService.post("/SRVC/AuthController.php", {
      'act': 'getAuthUser',
      'userID': userID,
    });
    return {'text': 'UserData', 'status': response['status'], 'data': response['data']};
  }

  Future<Map<String, dynamic>> _getUserExpense(int userID, ApiService apiService) async {
    await Future.delayed(Duration(milliseconds: 0));
    String formattedDate = DateTime.now().toIso8601String().split('T').first;
    final response = await apiService.post("/SRVC/AuthController.php", {
      'act': 'getUserExpense',
      'userID': userID,
      'type': 'month',
      'date': formattedDate,
    });

    return {'text': 'ExpenseData', 'status': response['status'], 'data': response['data']};
  }

  Future<Map<String, dynamic>> _getUserGroup(int userID, ApiService apiService) async {
    await Future.delayed(Duration(milliseconds: 0));
    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'getGroup',
      'userID': userID,
    });
    return {'text': 'GroupMemberData', 'status': response['status'], 'data': response['data']};
  }

  Future<Map<String, dynamic>> _getGroupData(int userID, ApiService apiService) async {
    await Future.delayed(Duration(milliseconds: 0));
    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'checkGroup',
      'userID': userID,
    });
    return {'text': 'MemberData', 'status': response['status'], 'data': response['data']};
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

    String? userDataString = prefs.getString('UserData');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);

      if (userData['data'] != null) {
        userData['data']['income'] = newIncome;

        await prefs.setString('UserData', jsonEncode(userData));

        notifyListeners();
      } else {
        print('Income data is null in user data');
      }
    } else {
      print('No user data found in Shared Preferences');
    }
  }
}

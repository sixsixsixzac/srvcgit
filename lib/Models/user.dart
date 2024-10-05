import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/APIService.dart';

class UserModel {
  ApiService apiService = ApiService(serverURL);

  final int id;
  final String name;
  final String phone;
  final String password;
  final int income;
  final DateTime updateAt;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.updateAt,
    required this.createdAt,
    required this.income,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
      income: json['income'],
      updateAt: DateTime.parse(json['update_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'update_at': updateAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Future<List<UserModel>> getUsers() async {
    final response = await apiService.post("/SRVC/UserController.php", {
      'act': 'getUsers',
    });

    if (response['status']) {
      List<dynamic> usersJson = response['data'];
      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<UserModel> get(int userId) async {
    final response = await apiService.post("/SRVC/UserController.php", {
      'act': 'getUserById',
      'id': userId,
    });

    if (response['status']) {
      return UserModel.fromJson(response['data']);
    } else {
      throw Exception("Failed to load user with id: $userId");
    }
  }
}

Future<void> storeUserData(Map<String, dynamic> userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String jsonString = jsonEncode({
    'id': userData['id'],
    'name': userData['name'],
    'phone': userData['phone'],
    'password': userData['password'],
    'income': userData['income'],
    'update_at': userData['update_at'],
    'created_at': userData['created_at']
  });

  await prefs.setString('user_data', jsonString);
}

Future<Map<String, dynamic>> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? jsonString = prefs.getString('user_data');

  if (jsonString != null) {
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }


  return {};
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Pages/LoginPage.dart';
import 'package:srvc/Services/APIService.dart';

import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Widgets/Fetching.dart';
import 'package:srvc/Widgets/Loading.dart';

class Authcontroller extends StatefulWidget {
  const Authcontroller({super.key});

  @override
  State<Authcontroller> createState() => _AuthcontrollerState();
}

class _AuthcontrollerState extends State<Authcontroller> {
  late final ApiService apiService;
  late Future<void> _checkLoginStatus;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(serverURL);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _checkLoginStatus = authProvider.checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppPallete.purple,
        child: FutureBuilder<void>(
          future: _checkLoginStatus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error checking login status: ${snapshot.error}'));
            } else {
              final isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
              final id = Provider.of<AuthProvider>(context).id;
              return isLoggedIn && id.isNotEmpty && int.tryParse(id) != null ? FetchingContainer(userID: int.parse(id)) : const LoginPage();
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Pages/HomePage.dart';
import 'package:srvc/Pages/LoginPage.dart';
import 'package:srvc/Services/auth_provider.dart';

class Authcontroller extends StatefulWidget {
  const Authcontroller({super.key});

  @override
  State<Authcontroller> createState() => _AuthcontrollerState();
}

class _AuthcontrollerState extends State<Authcontroller> {
  late Future<void> _checkLoginStatus;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus = Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _checkLoginStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error checking login status'));
        } else {
          bool isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
          return isLoggedIn ? const HomePage() : const LoginPage();
        }
      },
    );
  }
}

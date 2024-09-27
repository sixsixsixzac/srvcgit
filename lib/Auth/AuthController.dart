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
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Provider.of<AuthProvider>(context).isLoggedIn;
    if (isLoggedIn) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}

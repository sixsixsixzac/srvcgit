import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srvc/Models/_AddExpense/menu_options.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => __AddExpenseState();
}

class __AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    return const IncomeExpenseForm();
  }
}

class IncomeExpenseForm extends StatefulWidget {
  const IncomeExpenseForm({super.key});

  @override
  State<IncomeExpenseForm> createState() => _IncomeExpenseFormState();
}

class _IncomeExpenseFormState extends State<IncomeExpenseForm> {

  List<MenuItems>? menuItems;

  @override
  void initState() {
    super.initState();
    loadMenuItems();
  }

  Future<void> loadMenuItems() async{
    String jsonString = await rootBundle.loadString('assets/json/_AddExpense/menu_options.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    setState(() {
      menuItems = jsonList.map((json) => MenuItems.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.check, size: 20.0, color: AppPallete.gradient1,),
                Icon(FontAwesomeIcons.times, size: 20.0, color: AppPallete.gradient1,),
              ],
            ),
          )
        ],
      ),
    );
  }
}


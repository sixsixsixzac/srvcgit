import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srvc/Models/_AddExpense/menu_options.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/Shortcut.dart';
import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  int activeOption = 0;

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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: menuItems != null 
        ? Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: SizedBox(
              height: resize(context: context, type: 'h', value: 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.check, size: 20.0, color: AppPallete.gradient1,),
                  Icon(FontAwesomeIcons.times, size: 20.0, color: AppPallete.gradient1,),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 25.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppPallete.gradient2,
                  width: 2
                ),
                color: AppPallete.gradient2,
                borderRadius: BorderRadius.circular(1000),
              ),
              width: resize(context: context, type: 'w', value: 0.35),
              height: resize(context: context, type: 'w', value: 0.35),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(menuItems![activeOption].menuIcons.path, height: 50, width: 50,),
                    Text(
                      textAlign: TextAlign.center,
                      menuItems![activeOption].text.th, 
                      style: TextStyle(
                        fontFamily: 'thaifont', 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                        fontSize: 10.0
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    )
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(menuItems!.length,(index){
                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        activeOption = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.transparent
                        ),
                      ),
                      width: 50,
                      height: resize(context: context, type: 'h', value: 0.15),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(menuItems![index].menuIcons.path, width: 35, height: 35,),
                            Text(
                              menuItems![index].text.th,
                              textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'thaifont',
                                  fontWeight: FontWeight.bold,
                                  color: AppPallete.gradient1,
                                  fontSize: 8.0
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      )
      : Placeholder(),
    );
  }
}


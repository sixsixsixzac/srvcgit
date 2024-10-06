import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:srvc/Models/_AddExpense/menu_options.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Services/Shortcut.dart';
import 'dart:convert';
import 'package:srvc/Services/_Expense/numpad.dart';
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

  Future<void> loadMenuItems() async {
    String jsonString = await rootBundle
        .loadString('assets/json/_AddExpense/menu_options.json');
    List<dynamic> jsonList = jsonDecode(jsonString);
    setState(() {
      menuItems = jsonList.map((json) => MenuItems.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                height: resize(context: context, type: 'h', value: 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.check,
                      size: 20.0,
                      color: AppPallete.white,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        FontAwesomeIcons.times,
                        size: 20.0,
                        color: AppPallete.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            if (menuItems != null) ...[
              _PreviewOptions(
                menuItems: menuItems!,
                activeOption: activeOption,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FontAwesomeIcons.arrowLeftLong,
                    color: Colors.grey.withOpacity(0.35),
                    size: 15,
                  ),
                  Icon(
                    FontAwesomeIcons.arrowRightLong,
                    color: Colors.grey.withOpacity(0.35),
                    size: 15,
                  ),
                ],
                            ),
              ),
              __ListOptionState(
                menuItems: menuItems!,
                ontap: (index) {
                  setState(() => activeOption = index);
                },
                activeOption: activeOption,
              ),
            ],
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: AppPallete.backgroundColor,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 5, left: 1, bottom: 5),
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: "จำนวนเงิน",
                                    border: OutlineInputBorder(),
                                    
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2.5,
                                      color: Colors.transparent
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppPallete.green
                                  ),
                                  height: 40,
                                  child: Center(child: Text("Save", style: TextStyle(color: Colors.white),)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      _Mynumpad()
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class _PreviewOptions extends StatefulWidget {
  final List<MenuItems> menuItems;
  final int activeOption;
  const _PreviewOptions(
      {super.key, required this.menuItems, this.activeOption = 0});
  @override
  State<_PreviewOptions> createState() => __PreviewOptionsState();
}

class __PreviewOptionsState extends State<_PreviewOptions> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppPallete.gradient3, width: 5),
          color: AppPallete.backgroundColor,
          borderRadius: BorderRadius.circular(1000),
        ),
        width: resize(context: context, type: 'w', value: 0.45),
        height: resize(context: context, type: 'w', value: 0.45),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.menuItems[widget.activeOption].menuIcons.path,
                height: 50,
                width: 50,
              ),
              AutoSizeText(
                minFontSize: 12.0,
                maxFontSize: 16.0,
                maxLines: 2,
                widget.menuItems[widget.activeOption].text.th,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'thaifont',
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class __ListOptionState extends StatefulWidget {
  final List<MenuItems> menuItems;
  final Function(int) ontap;
  final int activeOption;
  const __ListOptionState(
      {super.key,
      required this.menuItems,
      required this.ontap(index),
      this.activeOption = 0});

  @override
  State<__ListOptionState> createState() => ___ListOptionStateState();
}

class ___ListOptionStateState extends State<__ListOptionState> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.menuItems.length, (index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 12, 10, 0),
            child: GestureDetector(
              onTap: () {
                widget.ontap(index);
              },
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: widget.activeOption == index ? AppPallete.gradient3 : Colors.transparent),
                      shape: BoxShape.circle,
                      color: Colors.white
                    ),
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Image.asset(
                        widget.menuItems[index].menuIcons.path,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                      child: AutoSizeText(
                        minFontSize: 8.0,
                        maxFontSize: 14.0,
                        maxLines: 1,
                        widget.menuItems[index].text.th,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'thaifont',
                            fontWeight: FontWeight.bold,
                            color: widget.activeOption == index ? AppPallete.gradient3 : Colors.white,
                            fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Mynumpad extends StatefulWidget {
  const _Mynumpad({super.key});

  @override
  State<_Mynumpad> createState() => __MynumpadState();
}

class __MynumpadState extends State<_Mynumpad> {
  List<Map<String, dynamic>> numkeys = Numpad.numpadKeys;
  @override
  Widget build(BuildContext context) {
    
    return createNumpad();
  }

  Widget createNumpad(){
    int maxKeysPerRow = 3;
    List<Widget> currentRowItems = [];
    List<Widget> rows = [];

    for (var item in numkeys) {
      Widget key = Placeholder();
      if (item['type'] == 'functional') {
        key = Expanded(
          child: GestureDetector(
            onTap: item['ontap'],
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.grey
                  ),
                  borderRadius: BorderRadius.circular(5)
                ),
                height: 40,
                child: Center(child: Text(item['key'])),
              ),
            ),
          ),
        );
      } else if (item['type'] == 'number') {
        key = Expanded(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.grey
                ),
                borderRadius: BorderRadius.circular(5)
              ),
              height: 40,
              child: Center(child: Text(item['key'])),
            ),
          ),
        );
      }

      currentRowItems.add(key);

      if (currentRowItems.length >= maxKeysPerRow) {
        rows.add(Row(children: currentRowItems,));
        currentRowItems = [];
      }
    }

    if (currentRowItems.isNotEmpty) {
      rows.add(Row(
        children: currentRowItems,
      ));
    }

    return Column(
      children: rows,
    );
  }
}
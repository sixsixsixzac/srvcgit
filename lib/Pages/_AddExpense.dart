import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:srvc/Widgets/BounceAnim.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => __AddExpenseState();
}

class __AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(8.0),
            child: BounceInPage(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.blue,
                child: const Center(
                  child: AutoSizeText(
                    "Click Me!",
                    maxLines: 1,
                    minFontSize: 18,
                    maxFontSize: 36,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'thaifont',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

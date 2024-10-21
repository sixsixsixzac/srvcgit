import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Widgets/CPointer.dart';
import 'package:srvc/Widgets/RaRenRer.dart';

class DatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) getDatePicker;
  const DatePicker({super.key, required this.getDatePicker, required this.selectedDate});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  void getDateTime(data){
    widget.getDatePicker(data['DateTime']);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CPointer(
                  onTap: ()=> Navigator.pop(context),
                  child: Icon(
                    FontAwesomeIcons.arrowLeft,
                    size: 20,
                    color: AppPallete.white,
                  ),
                ),
                Text("เลือกวัน/เดือน/ปี", style: TextStyle(fontFamily: "thaifont", fontSize: 16, color: AppPallete.white),),
                SizedBox(width: 20,)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: RaRenRer(getDateTime: getDateTime, selectedDate: widget.selectedDate, basicSetting: {"time_selector": true, "border_radius": 16.0},),
          )
        ],
      ),
    );
  }
}
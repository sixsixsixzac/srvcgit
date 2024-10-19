import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Widgets/CPointer.dart';

class Rarender extends StatefulWidget {
  final Color backgroundColor;
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color weekdaysColor;
  final Color daysColor;
  final Color currentDateColor;
  final Color activeDateColor;

  const Rarender({
    super.key,
    this.backgroundColor = Colors.white,
    this.headerBackgroundColor = Colors.white,
    this.headerTextColor = Colors.indigo,
    this.weekdaysColor = Colors.grey,
    this.daysColor = Colors.black,
    this.currentDateColor = const Color.fromARGB(90, 83, 109, 254),
    this.activeDateColor = Colors.indigo,
  });

  @override
  State<Rarender> createState() => _RarenderState();
}

class _RarenderState extends State<Rarender> {
  final DateTime currentDate = DateTime.now();
  late DateTime focusedDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

  final List<String> thaiMonths = [
    "มกราคม", "กุมภาพันธุ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
  ];

  final List<String> thaiDays = [
    "อา", "จ", "อ", "พ", "พฤ", "ศ", "ส"
  ];

  late DateTime selectedDay = currentDate;

  void changeMonth(int amount) {
    setState(() {
      focusedDate = DateTime(focusedDate.year, focusedDate.month + amount);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: widget.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only( bottom: 8),
            child: Container(
              color: widget.headerBackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CPointer(
                    onTap: () => changeMonth(-1),
                    child: Icon(FontAwesomeIcons.chevronLeft, size: 20, color: widget.headerTextColor,)
                  ),
                  Text("${thaiMonths[focusedDate.month-1]}, ${focusedDate.year + 543}", style: TextStyle(fontFamily: 'thaifont', fontSize: 16, fontWeight: FontWeight.bold, color: widget.headerTextColor),),
                  CPointer(
                    onTap: () => changeMonth(1),
                    child: Icon(FontAwesomeIcons.chevronRight, size: 20, color: widget.headerTextColor,)
                  )
                ],
              ),
            ),
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            children: buildCalendar(),
          )
        ],
      ),
    );
  }

  List<Widget> buildCalendar () {
    List<Widget> children = [];
    int firstday = DateTime(focusedDate.year, focusedDate.month, 1).weekday;
    int daysInMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0).day;

    for (var thaiDays in thaiDays) {
      children.add(
        Center(
          child: AutoSizeText(
                          thaiDays,
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 10,
                          wrapWords: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.weekdaysColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
      );
    }

    if (firstday < 7) {
      children.addAll(List.generate(firstday, (index) => Container()));
    }

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime iDate = DateTime(focusedDate.year, focusedDate.month, i);
      bool today = (DateTime(currentDate.year, currentDate.month, currentDate.day) == iDate);
      bool selected = iDate == (DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
      children.add(
        CPointer(
          onTap: () => setState(() => selectedDay = iDate),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: selected? widget.activeDateColor : today? widget.currentDateColor : Colors.transparent
              )
            ),
            child: Center(
              child: AutoSizeText(
                          i.toString(),
                          maxLines: 1,
                          minFontSize: 10,
                          maxFontSize: 10,
                          wrapWords: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.daysColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
            )
          ),
      );
    }

    return children;
  }
}
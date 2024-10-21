import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Widgets/CPointer.dart';

class RaRenRer extends StatefulWidget {
  final Map<String, dynamic> basicSetting;
  final Map<String, dynamic> colorSetting;
  final Function(Map<String, dynamic>) getDateTime;
  final DateTime selectedDate;

  RaRenRer(
    {
      super.key,
      Map<String, dynamic>? basicSetting,
      Map<String, dynamic>? colorSetting,
      required this.getDateTime,
      DateTime? selectedDate,
    }
  ) : basicSetting = {
          // ค่าเริ่มต้นสำหรับ basicSetting
          ...{
            "thai_year": true,
            "month_n_year_only": false,
            "time_selector": false,
            "border_radius": 0.0,
          },
          // รวมค่าจาก basicSetting ที่ผู้ใช้ส่งมา (หากไม่ null)
          if (basicSetting != null) ...basicSetting,
        },
        colorSetting = {
          // ค่าเริ่มต้นสำหรับ colorSetting
          ...{
            "background_color": Colors.white,
            "header": {
              "background_color": Colors.white,
              "font_color": Colors.indigo,
              "sign_color": Colors.indigo,
            },
            "calendar": {
              "background_color": Colors.white,
              "weekdays_color": Colors.grey,
              "monthdays_color": Colors.black,
            },
            "active": {
              "border_color": Colors.indigo,
              "font_color": Colors.indigo,
            },
            "current": {
              "border_color": Color.fromARGB(100, 63, 81, 181),
              "font_color": Color.fromARGB(100, 63, 81, 181),
            }
          },
          // รวมค่าจาก colorSetting ที่ผู้ใช้ส่งมา (หากไม่ null)
          if (colorSetting != null) ...colorSetting,
        },
        selectedDate = selectedDate ?? DateTime.now();

  @override
  State<RaRenRer> createState() => _RaRenRerState();
}

class _RaRenRerState extends State<RaRenRer> {
  final List<String> thaiMonths = [
    "มกราคม", "กุมภาพันธุ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"
  ];

  final List<String> thaiDays = [
    "อา", "จ", "อ", "พ", "พฤ", "ศ", "ส"
  ];

  DateTime current = DateTime.now();
  late DateTime focus;
  late DateTime selected;

  void prepareToSend (DateTime send) {
    Map<String, dynamic> response = {
      "DateTime" : send,
      "String" : send.toString(),
      "forRead" : "วัน ${send.weekday < 7 ? thaiDays[send.weekday] : thaiDays[0]} ที่ ${send.day} ${thaiMonths[send.month - 1]} ${widget.basicSetting['thai_year'] == true ? (send.year + 543) : send.year}" 
    };

    widget.getDateTime(response);
  }

  void changeTime (String type, bool increase) {
    setState(() {
      if (type == "h") {
        selected = DateTime(selected.year, selected.month, selected.day, (increase ? selected.hour + 1 : selected.hour - 1).clamp(0, 23), selected.minute);
      } else {
        selected = DateTime(selected.year, selected.month, selected.day, selected.hour, (increase ? selected.minute + 1 : selected.minute - 1).clamp(0, 59));
      }
      prepareToSend(selected);
    });
  }

  void pickItUp (DateTime pickup) {
    setState(() {
      selected = DateTime(pickup.year, pickup.month, pickup.day, selected.hour, selected.minute);
      prepareToSend(selected);
    });
  }

  void changeMonth (int amount) {
    setState(() {
      focus = DateTime(focus.year, focus.month + amount);
      if (widget.basicSetting['month_n_year_only']) {
        prepareToSend(focus);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selected = widget.selectedDate;
    focus = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.basicSetting['border_radius']),
        color: widget.colorSetting['background_color']
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CPointer(
                  onTap: () => changeMonth(-1),
                  child: Icon(FontAwesomeIcons.chevronLeft, size: 20, color: widget.colorSetting['header']['font_color'],)
                ),
                Text("${thaiMonths[focus.month-1]}, ${widget.basicSetting['thai_year'] ? focus.year + 543 : focus.year}", style: TextStyle(fontFamily: 'thaifont', fontSize: 16, fontWeight: FontWeight.bold, color: widget.colorSetting['header']['font_color']),),
                CPointer(
                  onTap: () => changeMonth(1),
                  child: Icon(FontAwesomeIcons.chevronRight, size: 20, color: widget.colorSetting['header']['font_color'],)
                )
              ],
            ),
          ),
          showCalendar(),
          timeSelector(),
        ],
      ),
    );
  }

  Widget showCalendar () {
    if (widget.basicSetting['month_n_year_only']){
      return SizedBox(width: 0, height: 0,);
    } else {
      return GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        children: buildCalendar(),
      );
    }
  }

  List<Widget> buildCalendar (){
    List<Widget> children = [];
    int firstday = DateTime(focus.year, focus.month, 1).weekday;
    int daysInMonth = DateTime(focus.year, focus.month + 1, 0).day;

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
                    color: widget.colorSetting['calendar']['weekdays_color'],
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
      DateTime iDate = DateTime(focus.year, focus.month, i);
      bool today = (DateTime(current.year, current.month, current.day) == iDate);
      bool is_selected = DateTime(selected.year, selected.month, selected.day) == iDate;
      children.add(
        CPointer(
          onTap: () {
            pickItUp(iDate);
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: is_selected? widget.colorSetting['active']['border_color'] : today? widget.colorSetting['current']['border_color'] : Colors.transparent
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
                            color: is_selected? widget.colorSetting['active']['font_color'] : today? widget.colorSetting['current']['font_color'] : widget.colorSetting['calendar']['monthdays_color'],
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

  Widget timeSelector () {
    if (widget.basicSetting['time_selector'] == true) {
      return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.sortUp, size: 16, color: widget.colorSetting['calendar']['weekdays_color'],),
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy > 5) {
                          changeTime('h', true);
                        } else if (details.delta.dy < -5){
                          changeTime('h', false);
                        }
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(child: showTime(selected.hour))
                      )
                    ),
                    Icon(FontAwesomeIcons.sortDown, size: 16, color: widget.colorSetting['calendar']['weekdays_color'],)
                  ],
                ),
              ),
              Text(":", style: TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold, fontSize: 16),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.sortUp, size: 16, color: widget.colorSetting['calendar']['weekdays_color'],),
                    GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (details.delta.dy > 5) {
                          changeTime('m', true);
                        } else if (details.delta.dy < -5){
                          changeTime('m', false);
                        }
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(child: showTime(selected.minute))
                      )
                    ),
                    Icon(FontAwesomeIcons.sortDown, size: 16, color: widget.colorSetting['calendar']['weekdays_color'],)
                  ],
                ),
              ),
            ],
          );
    } else {
      return Container();
    }
  }

  Widget showTime (int timeNum) {
    String timeText = timeNum.toString();
    timeText = timeText.length < 2 ? "0$timeText" : timeText;
    return Text(timeText, style: TextStyle(fontFamily: 'thaifont', fontSize: 16, color: widget.colorSetting['header']['font_color'], fontWeight: FontWeight.bold),);
  }
}
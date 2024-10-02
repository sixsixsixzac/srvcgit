import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/dateformat.dart';

class UserModal extends StatefulWidget {
  final VoidCallback onClose;
  final GroupMembersModel? userData;
  const UserModal({super.key, required this.onClose, this.userData});

  @override
  State<UserModal> createState() => _UserModalState();
}

class _UserModalState extends State<UserModal> {
  String? CurrentDate;
  String CurrentType = "day";
  int CurrentYear = DateTime.now().year;
  int CurrentIndex = 0;
  final formatter = ThaiDateFormatter();
  String ModalLabel = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      CurrentDate = getCurrentDate();
      ModalLabel = formatter.format(CurrentDate!, type: 'day');
    });
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';

    return formattedDate;
  }

  void _updateVariable(type, index) {
    setState(() {
      CurrentType = type;
      CurrentIndex = index;
      CurrentDate = getCurrentDate();
      ModalLabel = formatter.format(CurrentDate!, type: CurrentType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      NavTab(
                        label: "รายวัน",
                        index: 0,
                        currentIndex: CurrentIndex,
                        onTab: (index) => setState(() => _updateVariable('day', index)),
                      ),
                      NavTab(
                        label: "รายเดือน",
                        index: 1,
                        currentIndex: CurrentIndex,
                        onTab: (index) => setState(() => _updateVariable('month', index)),
                      ),
                      NavTab(
                        label: "รายปี",
                        index: 2,
                        currentIndex: CurrentIndex,
                        onTab: (index) => setState(() => _updateVariable('year', index)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    CurrentDate = formatter.back(CurrentDate!, CurrentType);
                                    ModalLabel = formatter.format(CurrentDate!, type: CurrentType);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      )),
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  child: const Icon(
                                    FontAwesomeIcons.arrowLeft,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  ModalLabel,
                                  maxLines: 1,
                                  minFontSize: 18,
                                  maxFontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    CurrentDate = formatter.forward(CurrentDate!, CurrentType);
                                    ModalLabel = formatter.format(CurrentDate!, type: CurrentType);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      )),
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  child: const Icon(
                                    FontAwesomeIcons.arrowRight,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(color: Colors.red,),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: widget.onClose,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(bottom: 5, top: 5),
                    height: 35,
                    width: 100,
                    child: Center(
                        child: Text(
                      "ปิด",
                      style: TextStyle(
                        fontFamily: 'thaifont',
                        fontWeight: FontWeight.bold,
                        color: AppPallete.white,
                        fontSize: 18,
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class NavTab extends StatelessWidget {
  final Function(int) onTab;
  final String label;
  final int index;
  final int currentIndex;

  const NavTab({
    super.key,
    required this.onTab,
    required this.label,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = index == currentIndex ? Colors.indigo[700]! : Colors.indigo;
    return Expanded(
      child: InkWell(
        onTap: () => onTab(index),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          height: 50,
          child: Center(
            child: AutoSizeText(
              label,
              maxLines: 1,
              minFontSize: 18,
              maxFontSize: 26,
              style: const TextStyle(
                fontFamily: 'thaifont',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

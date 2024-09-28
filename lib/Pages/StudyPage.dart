import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Services/HexColor.dart';

class StudyPage extends StatefulWidget {
  const StudyPage({super.key});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: AutoSizeText(
                  "หัวขอที่สนใจ",
                  maxLines: 1,
                  minFontSize: 18,
                  maxFontSize: 20,
                  style: TextStyle(fontFamily: 'thaifont', color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: HexColor("#d5d5d5")),
                  color: Colors.grey[200],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.filter,
                      size: 14,
                      color: HexColor('#7f8889'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    AutoSizeText(
                      "เลือกหัวข้อ (0)",
                      maxLines: 1,
                      minFontSize: 16,
                      maxFontSize: 20,
                      style: TextStyle(fontFamily: 'thaifont', color: HexColor('#7f8889')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

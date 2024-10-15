import 'package:flutter/material.dart';
import 'package:srvc/Services/HexColor.dart';

class StaticLoadingBar extends StatelessWidget {
  final double progress;
  final String label;
  final Color styleColor;

  const StaticLoadingBar({super.key, this.progress = 1, this.label = "Loading...", this.styleColor = Colors.orange});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: styleColor,
            fontFamily: 'thaifont',
          ),
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: HexColor("#d7d7d7"),
              ),
              width: MediaQuery.of(context).size.width,
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: styleColor,
              ),
              width: MediaQuery.of(context).size.width * progress,
              height: 10,
            ),
            Center(
              child: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'thaifont',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
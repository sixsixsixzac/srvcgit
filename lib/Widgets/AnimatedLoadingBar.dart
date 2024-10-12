

import 'package:flutter/material.dart';
import 'package:srvc/Services/HexColor.dart';

class AnimatedLoadingBar extends StatelessWidget {
  final double progress;
  final String label;
  final Color styleColor;

  const AnimatedLoadingBar({
    super.key,
    this.progress = 1,
    this.label = "Loading...",
    this.styleColor = Colors.orange,
  });

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
            TweenAnimationBuilder<double>(
              curve: Curves.bounceOut,
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: styleColor,
                  ),
                  width: MediaQuery.of(context).size.width * value,
                  height: 10,
                );
              },
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
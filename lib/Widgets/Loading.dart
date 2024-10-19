import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:srvc/Services/AppPallete.dart';


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPallete.purple,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppPallete.white,
          ),
          AutoSizeText(
            "กรุณารอสักครู่",
            maxLines: 1,
            minFontSize: 20,
            maxFontSize: 26,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

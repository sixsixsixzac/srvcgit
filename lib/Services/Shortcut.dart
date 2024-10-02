import 'package:flutter/material.dart';

double resize({required BuildContext context, required String type, required double value}) {
  final size = MediaQuery.of(context).size;

  if (type == 'h') {
    return size.height * value;
  } else if (type == 'w') {
    return size.width * value;
  } else {
    throw ArgumentError('Invalid type: $type. Use "h" for height or "w" for width.');
  }
}


import 'package:flutter/material.dart';

dynamic resize(BuildContext context ,String type, double value) {
  return MediaQuery.of(context).size.height * value;
}
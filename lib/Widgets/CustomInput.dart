import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Color fillColor;
  final Color iconColor;
  final double borderRadius;
  final bool? hashPass;
  final EdgeInsetsGeometry margin;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.validator, // Add this line
    this.fillColor = const Color(0xFFE4E4E4),
    this.iconColor = const Color(0xFFA0A0A0),
    this.borderRadius = 10,
    this.hashPass = false,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 45,
      child: TextFormField(
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.always,
        obscureText: hashPass!,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: FaIcon(
              prefixIcon,
              color: iconColor,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: iconColor, fontFamily: 'thaifont'),
        ),
      ),
    );
  }
}

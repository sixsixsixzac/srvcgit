import 'package:flutter/material.dart';

class CPointer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const CPointer({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}

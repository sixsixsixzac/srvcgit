import 'package:flutter/material.dart';

class SlideFromBottomPage extends StatefulWidget {
  final Widget child;

  SlideFromBottomPage({required this.child});

  @override
  _SlideFromBottomPageState createState() => _SlideFromBottomPageState();
}

class _SlideFromBottomPageState extends State<SlideFromBottomPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from below the screen
      end: Offset.zero, // End at the original position
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _animation,
        child: Center(child: widget.child), // Use the passed widget here
      ),
    );
  }
}



// Ensure HexColor is properly defined if you are using a custom class for it
/*  */
import 'package:flutter/material.dart';

class BounceInPage extends StatefulWidget {
  final Widget child;
  // ความเร็วของ Animation
  final int speed;

  const BounceInPage({super.key, required this.child, this.speed = 1});

  @override
  _BounceInPageState createState() => _BounceInPageState();
}

class _BounceInPageState extends State<BounceInPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.speed),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: widget.child,
        ),
      ),
    );
  }
}

// Usage example
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BounceInPage(
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
        child: const Center(
          child: Text('Bounce In'),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomButtonBar extends StatefulWidget {
  final List<String> imagePaths;
  final List<String> labels;
  final int defaultIndex;
  final Function(int) onTap;

  const CustomButtonBar({
    super.key,
    required this.imagePaths,
    required this.labels,
    required this.onTap,
    this.defaultIndex = 0,
  });

  @override
  _CustomButtonBarState createState() => _CustomButtonBarState();
}

class _CustomButtonBarState extends State<CustomButtonBar> with SingleTickerProviderStateMixin {
  late int selectedIndex;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.defaultIndex;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 40, end: 45).animate(_controller);
  }

  @override
  void didUpdateWidget(CustomButtonBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultIndex != widget.defaultIndex) {
      setState(() {
        selectedIndex = widget.defaultIndex;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateToIndex(int index) {
    _controller.forward().then((_) {
      setState(() {
        selectedIndex = index;
      });
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.imagePaths.length, (index) {
          return GestureDetector(
            onTap: () {
              _animateToIndex(index);
              widget.onTap(index);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1, end: selectedIndex == index ? 1.1 : 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
                    child: Image.asset(
                      widget.imagePaths[index],
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                Text(
                  widget.labels[index],
                  style: TextStyle(
                    fontFamily: 'thaifont',
                    color: selectedIndex == index ? Colors.indigo : Colors.grey,
                    fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

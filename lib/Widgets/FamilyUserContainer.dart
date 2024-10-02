import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Services/auth_provider.dart';

class MyImageContainer extends StatefulWidget {
  final VoidCallback onTabView;
  final GroupMembersModel data;

  const MyImageContainer({super.key, required this.data, required this.onTabView});

  @override
  _MyImageContainerState createState() => _MyImageContainerState();
}

class _MyImageContainerState extends State<MyImageContainer> {
  bool _showToolbar = false;
  Timer? _toolbarTimer;

  void _onLongPress() {
    setState(() {
      _showToolbar = true;
    });

    _toolbarTimer?.cancel();
    _toolbarTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _showToolbar = false;
      });
    });
  }

  @override
  void dispose() {
    _toolbarTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth = Provider.of<AuthProvider>(context, listen: false);
    bool itMe = (Auth.phone == widget.data.phone);
    return GestureDetector(
      onTap: _onLongPress,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigoAccent, width: 5),
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/test/person.png', height: 100, width: 100),
            if (widget.data.level == "A")
              Positioned(
                top: 5,
                child: Image.asset('assets/images/icons/crown.png', height: 30, width: 30),
              ),
            Positioned(
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: AutoSizeText(
                  (itMe) ? "ฉัน" : widget.data.name,
                  maxLines: 1,
                  minFontSize: 16,
                  maxFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: (itMe ? Colors.orange : Colors.white), fontFamily: 'thaifont', fontWeight: (itMe ? FontWeight.bold : FontWeight.normal)),
                ),
              ),
            ),
            if (_showToolbar)
              Positioned(
                bottom: 10,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.indigo),
                        onPressed: () {
                          widget.onTabView();
                        },
                      ),
                      if (!itMe)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _toolbarTimer?.cancel();
                            setState(() {
                              _showToolbar = false;
                            });
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.info, color: Colors.orange),
                        onPressed: () {
                          _toolbarTimer?.cancel();
                          setState(() {
                            _showToolbar = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

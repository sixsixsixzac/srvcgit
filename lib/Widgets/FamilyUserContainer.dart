import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Providers/FetchingHome.dart';

class MyImageContainer extends StatefulWidget {
  final VoidCallback onTabView;
  final VoidCallback onTabDel;
  final GroupMembersModel data;

  const MyImageContainer({super.key, required this.data, required this.onTabView, required this.onTabDel});

  @override
  _MyImageContainerState createState() => _MyImageContainerState();
}

class _MyImageContainerState extends State<MyImageContainer> {
  Map<String, dynamic> UserData = {};
  bool _showToolbar = false;
  Timer? _toolbarTimer;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future _getUserData() async {
    final dataString = await Provider.of<UserDataProvider>(context, listen: false).getPref('UserData');
    if (dataString != null) {
      final data0 = jsonDecode(dataString!);
      setState(() {
        UserData = data0['data'] as Map<String, dynamic>;
      });
    }
  }

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
    bool itMe = (widget.data.id == UserData['id']);
    return GestureDetector(
      onTap: _onLongPress,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: itMe ? AppPallete.orange : Colors.indigoAccent, width: 5),
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.indigoAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                      if (widget.data.level == "M" && !itMe)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _toolbarTimer?.cancel();
                            setState(() {
                              _showToolbar = false;
                            });
                            widget.onTabDel();
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

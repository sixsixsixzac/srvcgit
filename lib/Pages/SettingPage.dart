import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/auth_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const double _paddingValue = 10.0;
  static const double _rowHeight = 50.0;
  static const EdgeInsets _rowMargin = EdgeInsets.symmetric(vertical: 5, horizontal: 10);
  static const EdgeInsets _containerPadding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);

  final TextStyle _textStyle = TextStyle(fontFamily: 'thaifont');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPallete.backgroundColor,
      padding: EdgeInsets.all(5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle("Settings"),
            ..._buildSettingsRows(),
            _buildLogOutRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _paddingValue),
      child: AutoSizeText(
        title,
        maxLines: 1,
        minFontSize: 16,
        maxFontSize: 20,
        style: _textStyle,
      ),
    );
  }

  List<Widget> _buildSettingsRows() {
    final settings = ["Setting 1", "Setting 2", "Setting 3"];
    return settings.map((setting) {
      return _row(setting, () {}, showSuffix: true);
    }).toList();
  }

  Widget _row(
    String title,
    VoidCallback onTap, {
    bool showSuffix = false,
    Color bgColor = Colors.white,
    Color textColor = Colors.black,
    bool centralTitel = false,
  }) {
    return InkWell(
      splashColor: Colors.blue.withOpacity(0.5),
      highlightColor: Colors.blue.withOpacity(0.3),
      onTap: onTap,
      child: Container(
        height: _rowHeight,
        margin: _rowMargin,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: _containerPadding,
        child: Row(
          mainAxisAlignment: centralTitel ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: [
            if (!centralTitel)
              AutoSizeText(
                title,
                style: TextStyle(fontFamily: 'thaifont', color: textColor),
              ),
            if (centralTitel && showSuffix) SizedBox(width: 24),
            if (centralTitel)
              AutoSizeText(
                title,
                style: TextStyle(fontFamily: 'thaifont', color: textColor),
              ),
            if (showSuffix && !centralTitel) Icon(Icons.arrow_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOutRow() {
    return _row("ออกจากระบบ", _logout, showSuffix: false, bgColor: Colors.red, textColor: Colors.white, centralTitel: true);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "ออกจากระบบ",
          style: TextStyle(color: Colors.red),
        ),
        content: Text("ต้องการออกจากระบบใช่หรือไม่?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("ไม่"),
          ),
          TextButton(
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/Login');
            },
            child: Text("ใช่"),
          ),
        ],
      ),
    );
  }
}

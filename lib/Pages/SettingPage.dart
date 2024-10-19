import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Animation/Bounce.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/HexColor.dart';

import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Widgets/CPointer.dart';

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
    return Stack(
      children: [
        Container(
          color: AppPallete.backgroundColor,
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<AuthProvider>(
                  builder: (context, Auth, child) {
                    return BounceAnimation(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.height * 0.2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.indigo,
                                        width: 5,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/profiles/${Auth.data['profile']}',
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        width: MediaQuery.of(context).size.height * 0.2,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.indigo,
                                          width: 2,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: IconButton(
                                        icon: Icon(FontAwesomeIcons.edit, size: 18, color: Colors.indigo),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ProfileSelectionModal()),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: AutoSizeText(Auth.name,
                                          maxLines: 1, maxFontSize: 20, minFontSize: 16, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.w700)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.1,
                  endIndent: MediaQuery.of(context).size.width * 0.1,
                  color: Colors.grey.withOpacity(0.2),
                  thickness: 2,
                ),
                _buildTitle("Settings"),
                ..._buildSettingsRows(),
                _logoutButton(),
              ],
            ),
          ),
        ),
      ],
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
      child: BounceAnimation(
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
      ),
    );
  }

  Widget _logoutButton() {
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

class ProfileSelectionModal extends StatefulWidget {
  const ProfileSelectionModal({super.key});

  @override
  ProfileSelectionModalState createState() => ProfileSelectionModalState();
}

class ProfileSelectionModalState extends State<ProfileSelectionModal> {
  final ApiService apiService = ApiService(serverURL);
  late AuthProvider Auth;
  bool isLoading = false;
  int selectedIndex = -1;
  String selectedImg = "";
  final List<String> images = [
    'assets/images/profiles/dog.png',
    'assets/images/profiles/cat.png',
    'assets/images/profiles/panda.png',
    'assets/images/profiles/man.png',
    'assets/images/profiles/woman.png',
    'assets/images/profiles/woman2.png',
    'assets/images/profiles/boy.png',
    'assets/images/profiles/girl.png',
    'assets/images/profiles/girl2.png',
    'assets/images/profiles/teenager1.png',
    'assets/images/profiles/teenager2.png',
    'assets/images/profiles/teenager3.png',
    'assets/images/profiles/teenager4.png',
    'assets/images/profiles/father.png',
    'assets/images/profiles/mother.png',
    'assets/images/profiles/frog.png',
    'assets/images/profiles/angry-birds.png',
    'assets/images/profiles/bussiness-man.png',
  ];
  @override
  void initState() {
    super.initState();
    Auth = Provider.of<AuthProvider>(context, listen: false);
    String oldProfile = Auth.data['profile'];
    reset(oldProfile);
  }

  reset(String oldProfile) {
    selectedIndex = images.indexWhere((image) => image.split('/').last == oldProfile);
    if (selectedIndex >= 0) {
      return selectedIndex;
    } else {
      return false;
    }
  }

  bool isOldProfile(String name, int index) {
    int oldIndex = images.indexWhere((image) => image.split('/').last == name);
    return oldIndex >= 0 && oldIndex == index;
  }

  Future<void> _handleChangeProfile() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    String selectedImagePath = images[selectedIndex];
    String imageName = selectedImagePath.split('/').last;

    final response = await apiService.post("/SRVC/AuthController.php", {
      'act': 'updateProfile',
      'userID': Auth.id,
      'imageName': imageName,
    });
    if (response['status'] == true) {
      Auth.saveData(Map<String, dynamic>.from(response['data']));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String oldProfile = Auth.data['profile'];
    return Scaffold(
      appBar: AppBar(
        title: Text("กรุณาเลือก"),
        centerTitle: true,
        backgroundColor: AppPallete.purple,
        leading: CPointer(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            color: AppPallete.white,
            size: 30,
          ),
        ),
        actions: [
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: HexColor('#ffdd40'),
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                selectedIndex > -1 ? images[selectedIndex] : 'assets/images/profiles/panda.png',
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedIndex == index;
              return CPointer(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: HexColor('#ffdd40'),
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 5,
                            color: isSelected ? HexColor('#5efc9e') : (isOldProfile(oldProfile, index) ? Colors.orange : Colors.indigo),
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(images[index]),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (selectedIndex >= 0 && !isOldProfile(oldProfile, selectedIndex))
            Positioned(
                bottom: 0,
                child: BounceAnimation(
                  child: CPointer(
                    onTap: () async {
                      await _handleChangeProfile();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: HexColor('#5efc9e'),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          border: Border(
                            top: BorderSide(width: 5, color: HexColor('#4ce088')),
                            right: BorderSide(width: 5, color: HexColor('#4ce088')),
                            left: BorderSide(width: 5, color: HexColor('#4ce088')),
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(HexColor("#2a7868")),
                              )
                            : Text(
                                "ยืนยัน",
                                style: TextStyle(
                                  fontFamily: 'thaifont',
                                  color: HexColor("#2a7868"),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}

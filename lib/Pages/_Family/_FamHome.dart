import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Providers/FetchingHome.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Widgets/CPointer.dart';
import 'package:srvc/Widgets/FamilyUserContainer.dart';
import 'package:srvc/Widgets/FamilyUserModal.dart';

class FamilyHomePage extends StatefulWidget {
  final String groupCode;
  final List<GroupMembersModel> groupMembers;

  const FamilyHomePage({
    super.key,
    required this.groupCode,
    this.groupMembers = const [],
  });

  @override
  State<FamilyHomePage> createState() => _FamilyHomePageState();
}

class _FamilyHomePageState extends State<FamilyHomePage> {
  final ApiService apiService = ApiService(serverURL);
  late Future UserDataFuture;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    UserDataFuture = _getUserData();
  }

  void _toggleModal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserModal(userData: widget.groupMembers[selectedIndex!], onClose: _toggleModal)),
    );
  }

  Future<void> _leaveGroup(int index) async {
    final user = widget.groupMembers[index];

    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'delMember',
      'userID': user.id,
    });
    bool status = response['status'];
    if (status) {
      setState(() {
        widget.groupMembers.removeAt(index);
      });
    }
  }

  Future _getUserData() async {
    final dataString = await Provider.of<UserDataProvider>(context, listen: false).getPref('UserData');
    if (dataString != null) {
      final data0 = jsonDecode(dataString);
      return data0['data'] as Map<String, dynamic>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyModel>(
      builder: (context, FamState, child) {
        return Stack(
          children: [
            Container(
              color: AppPallete.white,
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 1,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                      border: Border.all(color: const Color.fromARGB(255, 46, 145, 50), width: 2),
                      color: Colors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AutoSizeText(
                            maxLines: 1,
                            minFontSize: 20,
                            textAlign: TextAlign.center,
                            maxFontSize: 26,
                            'รหัสกลุ่ม: ${FamState.groupCode}',
                            style: const TextStyle(
                              fontFamily: 'thaifont',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.white),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.groupCode.toString())).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.green,
                                  content: Center(
                                    child: Text(
                                      'คัดลอกแล้ว: ${widget.groupCode.toString()}',
                                      style: const TextStyle(
                                        fontFamily: 'thaifont',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: _row(),
                    ),
                  ),
                ],
              ),
            ),
            // if (FamState.isModalVisible)
            // ,
          ],
        );
      },
    );
  }

  Widget _row() {
    return Consumer2<AuthProvider, FamilyModel>(builder: (context, Auth, Family, child) {
      return ListView.builder(
        itemCount: widget.groupMembers.length,
        itemBuilder: (context, index) {
          final user = widget.groupMembers[index];
          final itMe = (user.phone == Auth.phone ? user : null);

          return Container(
            // color: Colors.grey.withOpacity(.05),
            margin: EdgeInsets.only(bottom: 10),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    child: ClipOval(
                      child: Image.asset('assets/images/profiles/${user.profile}', fit: BoxFit.cover),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CPointer(
                    onTap: () {
                      // Family.setWName("modal", title: 'modal');
                      _toggleModal();
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 5),
                      margin: EdgeInsets.only(left: 65),
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(.2)))),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          itMe != null ? "ฉัน" : user.name,
                          maxLines: 1,
                          minFontSize: 18,
                          maxFontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: user.level == "A" ? Colors.orange : Colors.black, fontWeight: user.level == "A" ? FontWeight.bold : null),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (itMe == null && user.level == "M"),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CPointer(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ยืนยันการลบสมาชิก ${user.name}'),
                              content: Text('คุณต้องการลบใช่หรือไม่?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ยกเลิก'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                    _leaveGroup(index);
                                  },
                                  child: Text('ลบ'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(FontAwesomeIcons.trash, size: 20, color: AppPallete.error),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (itMe != null && itMe.level == "A") || (user.phone != Auth.phone && user.level == "M") ? false : true,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CPointer(
                      onTap: () {
                        _toggleModal();
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(FontAwesomeIcons.search, size: 20, color: AppPallete.purple),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _grid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemCount: widget.groupMembers.length,
      itemBuilder: (context, index) {
        final user = widget.groupMembers[index];
        return MyImageContainer(
          data: widget.groupMembers[index],
          onTabView: () {
            _toggleModal();
            setState(() {
              selectedIndex = index;
            });
          },
          onTabDel: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ยืนยันการลบสมาชิก ${user.name}'),
                  content: Text('คุณต้องการลบใช่หรือไม่?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('ยกเลิก'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          selectedIndex = index;
                        });
                        _leaveGroup(index);
                      },
                      child: Text('ลบ'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

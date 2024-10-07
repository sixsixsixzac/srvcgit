import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Providers/FetchingHome.dart';
import 'package:srvc/Services/APIService.dart';

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
  int? selectedIndex;
  final ApiService apiService = ApiService(serverURL);
  void _toggleModal() {
    final FamState = Provider.of<FamilyModel>(context, listen: false);
    FamState.setModal(!FamState.isModalVisible);
  }

  Future<void> _leaveGroup(int index) async {
    final user = widget.groupMembers[index];

    final response = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'delMember',
      'userID': user.id,
    });
    bool status = response['status'];
    setState(() {
      widget.groupMembers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final FamState = Provider.of<FamilyModel>(context, listen: true);
    return Stack(
      children: [
        Container(
          color: AppPallete.transparent,
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
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
                  ),
                ),
              ),
            ],
          ),
        ),
        if (FamState.isModalVisible)
          UserModal(
            userData: widget.groupMembers[selectedIndex!],
            onClose: _toggleModal,
          ),
      ],
    );
  }
}

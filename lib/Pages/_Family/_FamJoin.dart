import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Providers/FetchingHome.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Widgets/CPointer.dart';

class FamilyJoinGroupPage extends StatefulWidget {
  final VoidCallback joined;
  const FamilyJoinGroupPage({super.key, required this.joined});

  @override
  State<FamilyJoinGroupPage> createState() => _FamilyJoinGroupPageState();
}

class _FamilyJoinGroupPageState extends State<FamilyJoinGroupPage> {
  final ApiService apiService = ApiService(serverURL);
  bool _isValid = false;
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  String getPinCode() {
    String pinCode = _controllers.map((controller) => controller.text).join();
    return pinCode;
  }

  Future<void> _confirmJoin(context) async {
    final dataString = await Provider.of<UserDataProvider>(context, listen: false).getPref('UserData');

    final data0 = jsonDecode(dataString!);
    final userData = data0['data'] as Map<String, dynamic>;

    final familyModel = Provider.of<FamilyModel>(context, listen: false);

    if (_isValid == false || getPinCode().length == 5) return;

    // final auth = Provider.of<AuthProvider>(context, listen: false);
    final data = await apiService.post("/SRVC/FamilyController.php", {
      'act': 'joinGroup',
      'userID': userData['id'],
      'group_code': getPinCode().toString(),
    });
    // print(data);
    if (data['status'] == true) {
      familyModel.setCode(data['data']['group_code']);
      familyModel.setWName('home', title: "กลุ่มของฉัน");
      widget.joined();
    } else {}
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: const AutoSizeText(
              "กรอกรหัสลงช่องด้านล่างนี้",
              style: TextStyle(fontFamily: 'thaifont'),
              maxLines: 1,
              minFontSize: 20,
              maxFontSize: 26,
            ),
          ),
          Form(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 40,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                      } else if (index > 0 && value.isEmpty) {
                        _controllers[index].clear();
                        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                      }
                      if (value.isNotEmpty && index == 5) {
                        setState(() => _isValid = true);
                      }
                    },
                    onFieldSubmitted: (value) {
                      if (index == 5) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                );
              }),
            ),
          ),
          CPointer(
            onTap: () {
              _confirmJoin(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * .4,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: const AutoSizeText(
                  "เข้าร่วมกลุ่ม",
                  maxLines: 1,
                  minFontSize: 20,
                  maxFontSize: 26,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          CPointer(
            onTap: () {
              final famState = Provider.of<FamilyModel>(context, listen: false);
              famState.setWName('welcome', title: "สร้างกลุ่ม");
            },
            child: Container(
              width: MediaQuery.of(context).size.width * .4,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: const AutoSizeText(
                  "ย้อนกลับ",
                  maxLines: 1,
                  minFontSize: 20,
                  maxFontSize: 26,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

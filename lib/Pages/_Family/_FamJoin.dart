import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/user.dart';
import 'package:srvc/Services/APIService.dart';

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
    final familyModel = Provider.of<FamilyModel>(context, listen: false);
    final userData = await getUserData();

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
      familyModel.setHas(true);
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
          GestureDetector(
            onTap: () {
              _confirmJoin(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.only(top: 20),
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
          )
        ],
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:srvc/Configs/URL.dart';

import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/HomePage.dart';
import 'package:srvc/Pages/LoginPage.dart';

import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/auth_provider.dart';
import 'package:srvc/Widgets/CustomInput.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiService apiService = ApiService(serverURL);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  Future<Map<String, dynamic>> registerUser(String name, String phone, String password) {
    return apiService.post("/SRVC/AuthController.php", {
      'name': name,
      'phone': phone,
      'password': password,
      'act': 'register',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor('#4c57b9'),
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  const AutoSizeText.rich(
                      TextSpan(
                        text: "รู้ก่อน",
                        style: TextStyle(fontFamily: 'thaifont', color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "ดีกว่า",
                            style: TextStyle(color: Colors.orange, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      minFontSize: 36,
                      maxFontSize: 46,
                      overflow: TextOverflow.ellipsis),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/icons/add-user.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 1,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  )),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AutoSizeText("สมัครสมาชิก", maxLines: 1, minFontSize: 26, maxFontSize: 36, style: TextStyle(color: HexColor("#999999"), fontFamily: 'thaifont')),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: _phoneController,
                              hintText: 'เบอร์มือถือ',
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              prefixIcon: FontAwesomeIcons.mobileAlt,
                            ),
                            CustomTextFormField(
                              controller: _userNameController,
                              hintText: 'ชื่อผู้ใช้',
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              prefixIcon: FontAwesomeIcons.user,
                            ),
                            CustomTextFormField(
                              controller: _passwordController,
                              hintText: 'รหัสผ่าน',
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              prefixIcon: Icons.password,
                            ),
                            CustomTextFormField(
                              controller: _confirmpassController,
                              hintText: 'ยืนยันรหัสผ่าน',
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              prefixIcon: Icons.password,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final response = await registerUser(
                                      _userNameController.text,
                                      _phoneController.text,
                                      _passwordController.text,
                                    );

                                    QuickAlert.show(
                                      context: context,
                                      type: response['status'] == true ? QuickAlertType.success : QuickAlertType.error,
                                      title: response['title'],
                                      text: response['msg'],
                                      autoCloseDuration: const Duration(seconds: 2),
                                      showConfirmBtn: false,
                                    ).then((_) async {
                                      if (response['status'] == true) {
                                        String name = _userNameController.text;
                                        String phone = _phoneController.text;
                                        String userId = response['data']['id'].toString();
                                        await Provider.of<AuthProvider>(context, listen: false).login(userId, name, phone);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const HomePage()),
                                        );
                                      }
                                    });
                                  } catch (e) {
                                    print('Error during registration: $e');
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(color: HexColor("#4e55bd"), borderRadius: BorderRadius.circular(5)),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      "สมัครสมาชิก",
                                      style: TextStyle(color: Colors.white, fontFamily: 'thaifont'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(color: HexColor("#e6e6e6"), borderRadius: BorderRadius.circular(5)),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      "เข้าสู่ระบบ",
                                      style: TextStyle(color: HexColor('#6B6B6B'), fontFamily: 'thaifont'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

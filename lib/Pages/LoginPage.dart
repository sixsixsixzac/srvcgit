import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Pages/RegisterPage.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Widgets/CustomInput.dart';
import 'package:srvc/Widgets/Fetching.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService(serverURL);
  bool _isChecked = false;
  final storage = FlutterSecureStorage();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<Map<String, dynamic>> loginUser(String phone, String password) async {
    final response = await apiService.post("/SRVC/AuthController.php", {
      'phone': phone,
      'password': password,
      'act': 'login',
    });
    bool fetchStatus = response['status'];
    if (fetchStatus == true) {
      Provider.of<AuthProvider>(context, listen: false).login(response['data']);
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
    _loadCheckboxState();
  }

  Future<void> _loadCheckboxState() async {
    String? storedPassword = await storage.read(key: 'password');
    String? storedPhone = await storage.read(key: 'phone');
    setState(() {
      _phoneController.text = storedPhone ?? "";
      _passwordController.text = storedPassword ?? "";

      _isChecked = storedPassword != null;
    });
  }

  Future<void> _savePassword(String phone, String password) async {
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'phone', value: phone);
  }

  Future<void> _deletePassword() async {
    await storage.delete(key: 'phone');
    await storage.delete(key: 'password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor('#4c57b9'),
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
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
                          'assets/images/icons/signin.png',
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
                child: Column(
                  children: [
                    AutoSizeText("เข้าสู่ระบบ", maxLines: 1, minFontSize: 26, maxFontSize: 36, style: TextStyle(color: HexColor("#999999"), fontFamily: 'thaifont', fontWeight: FontWeight.bold)),
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
                              hashPass: true,
                              controller: _passwordController,
                              hintText: 'รหัสผ่าน',
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              prefixIcon: FontAwesomeIcons.lock,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _isChecked = value ?? false;
                                            if (_isChecked) {
                                              _savePassword(_phoneController.text, _passwordController.text);
                                            } else {
                                              _deletePassword();
                                            }
                                          });
                                        },
                                      ),
                                      Text('บันทึกรหัสผ่าน'),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  child: AutoSizeText(
                                    "ลืมรหัสผ่าน",
                                    style: TextStyle(color: HexColor('#4c57b9'), fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final response = await loginUser(_phoneController.text, _passwordController.text);
                                // final user = UserModel.fromJson(response['data']);

                                bool status = response['status'];

                                if (!mounted) return;

                                if (status) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => FetchingContainer(userID: response['data']['id'])),
                                    (Route<dynamic> route) => false,
                                  );
                                } else {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: response['title'],
                                    text: response['msg'],
                                    autoCloseDuration: const Duration(seconds: 2),
                                    showConfirmBtn: false,
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(color: HexColor("#4e55bd"), borderRadius: BorderRadius.circular(5)),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      "เข้าสู่ระบบ",
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
                                  builder: (context) => const RegisterPage(),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(color: HexColor("#e6e6e6"), borderRadius: BorderRadius.circular(5)),
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(
                                    child: AutoSizeText(
                                      "สมัครสมาชิก",
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
            ],
          ),
        ),
      ),
    );
  }
}

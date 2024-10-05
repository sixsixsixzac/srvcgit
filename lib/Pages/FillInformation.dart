import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:http/http.dart' as http;
import 'package:srvc/Providers/FetchingHome.dart';
import 'dart:convert';
import 'package:srvc/Services/auth_provider.dart';

class FillinformationPage extends StatefulWidget {
  const FillinformationPage({super.key});

  @override
  State<FillinformationPage> createState() => _FillinformationPageState();
}

class _FillinformationPageState extends State<FillinformationPage> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();

  Future<void> _submitForm() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('$serverURL/SRVC/AuthController.php/updateIncome'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'income': _incomeController.text,
            'act': 'updateIncome',
            'userID': auth.id,
          }),
        );

        if (!mounted) return;

        final Map<String, dynamic> data = jsonDecode(response.body);
        bool status = data['status'];

        if (status) {
          userDataProvider.updateIncome(_incomeController.text);
          Navigator.pushReplacementNamed(context, '/Home');
        } else {
          _showSnackBar('Submission failed.');
        }
      } catch (e) {
        // Handle exceptions here
        _showSnackBar('An error occurred: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppPallete.purple,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  'กรุณากรอกรายได้ต่อเดือน',
                  maxLines: 1,
                  minFontSize: 20,
                  maxFontSize: 28,
                  style: TextStyle(color: Colors.white, fontFamily: 'thaifont'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _incomeController,
                  decoration: InputDecoration(
                    labelText: 'รายได้ต่อเดือน',
                    labelStyle: TextStyle(fontFamily: 'thaifont', color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      FontAwesomeIcons.moneyBill,
                      color: AppPallete.gradient3,
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกข้อมูล';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    minimumSize: Size(200, 50),
                  ),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(fontSize: 18, color: AppPallete.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

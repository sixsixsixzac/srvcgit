import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/auth_provider.dart';
import 'dart:async';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final ApiService apiService = ApiService(serverURL);
  String _pageTitle = "";
  bool? hasGroup;
  String? groupCode;
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _checkGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(_pageTitle, style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
      ),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Visibility(
              visible: hasGroup ?? true,
              child: Container(
                color: Colors.indigo,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/icons/empty-folder.png', color: Colors.white, height: 200, width: 200),
                      const Text("คุณยังไม่ได้สร้างกลุ่มสมาชิก", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'thaifont')),
                      GestureDetector(
                        onTap: _createGroup,
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                          width: 150,
                          height: 35,
                          child: const Center(
                            child: Text("สร้างกลุ่ม", style: TextStyle(color: Colors.indigo, fontSize: 20, fontFamily: 'thaifont')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // mean has group
          if (hasGroup == false)
            Container(
              color: Colors.transparent,
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
                            'รหัสกลุ่ม: ${groupCode.toString()}',
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
                            // Add your copy functionality here
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
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return const MyImageContainer();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _createGroup() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final data = await apiService.post("/SRVC/FamilyController.php", {
        'act': 'createGroup',
        'userID': auth.id,
      });

      if (data['status']) {
        setState(() {
          groupCode = data['data']['group_code'].toString();
          hasGroup = false;
        });
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: data['title'],
          text: data['msg'],
          autoCloseDuration: const Duration(seconds: 2),
          showConfirmBtn: false,
        );
      } else {
        print("Error: ${data['message']}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<void> _checkGroup() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final data = await apiService.post("/SRVC/FamilyController.php", {
        'act': 'checkGroup',
        'userID': auth.id,
      });

      setState(() {
        _pageTitle = data['status'] ? "สร้างกลุ่ม" : "กลุ่มสมาชิก";
        groupCode = data['data']['group_code'].toString();

        _isLoading = false;
        hasGroup = data['status'];
      });
    } catch (e) {
      print("An error occurred: $e");
      setState(() => _isLoading = false);
    }
  }
}

class MyImageContainer extends StatefulWidget {
  const MyImageContainer({super.key});

  @override
  _MyImageContainerState createState() => _MyImageContainerState();
}

class _MyImageContainerState extends State<MyImageContainer> {
  bool _showToolbar = false;
  Timer? _toolbarTimer;

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
    return GestureDetector(
      onTap: _onLongPress,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigoAccent, width: 5),
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/images/test/person.png', height: 100, width: 100),
            Positioned(
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: const AutoSizeText(
                  "User Name",
                  maxLines: 1,
                  minFontSize: 16,
                  maxFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontFamily: 'thaifont'),
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
                          _toolbarTimer?.cancel();
                          setState(() {
                            _showToolbar = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Add delete action
                          _toolbarTimer?.cancel(); // Cancel timer if action taken
                          setState(() {
                            _showToolbar = false; // Hide toolbar after action
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.info, color: Colors.orange),
                        onPressed: () {
                          // Add info action
                          _toolbarTimer?.cancel(); // Cancel timer if action taken
                          setState(() {
                            _showToolbar = false; // Hide toolbar after action
                          });
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

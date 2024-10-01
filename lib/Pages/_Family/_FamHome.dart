import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Models/group_members.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/auth_provider.dart';

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
  bool _isModalVisible = false; 

  void _toggleModal() {
    setState(() {
      _isModalVisible = !_isModalVisible;
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
                      return MyImageContainer(
                        data: widget.groupMembers[index],
                        onTabView: _toggleModal, // Pass the toggleModal method here
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isModalVisible)
          UserModal(
            onClose: _toggleModal,
          ),
      ],
    );
  }
}

class UserModal extends StatelessWidget {
  final VoidCallback onClose;

  const UserModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Positioned(
          left: (MediaQuery.of(context).size.width - (MediaQuery.of(context).size.width * 0.9)) / 2,
          top: 20,
          child: GestureDetector(
            onTap: () {
              // Do nothing on tap to prevent closing
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'This is a modal',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onClose, // Close modal when button is pressed
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyImageContainer extends StatefulWidget {
  final VoidCallback onTabView;
  final GroupMembersModel data;

  const MyImageContainer({super.key, required this.data, required this.onTabView});

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
    final Auth = Provider.of<AuthProvider>(context, listen: false);
    bool itMe = (Auth.phone == widget.data.phone);
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
            if (widget.data.level == "A")
              Positioned(
                top: 5,
                child: Image.asset('assets/images/icons/crown.png', height: 30, width: 30),
              ),
            Positioned(
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: AutoSizeText(
                  (itMe) ? "ฉัน" : widget.data.name,
                  maxLines: 1,
                  minFontSize: 16,
                  maxFontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: (itMe ? Colors.orange : Colors.white), fontFamily: 'thaifont', fontWeight: (itMe ? FontWeight.bold : FontWeight.normal)),
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
                          widget.onTabView(); // Call the onTabView callback
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Add delete action
                          _toolbarTimer?.cancel();
                          setState(() {
                            _showToolbar = false;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.info, color: Colors.orange),
                        onPressed: () {
                          // Add info action
                          _toolbarTimer?.cancel();
                          setState(() {
                            _showToolbar = false;
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

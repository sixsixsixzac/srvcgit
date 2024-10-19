import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/AppPallete.dart';

class CustomPopupMenuButton extends StatelessWidget {
  final FamilyModel famState;
  final Function(FamilyModel) onFetchSuccess;
  final void Function(String?)? ontap;

  CustomPopupMenuButton({
    super.key,
    required this.famState,
    required this.onFetchSuccess,
    this.ontap,
  });

  final ApiService apiService = ApiService(serverURL);
  Future<void> _groupAction(BuildContext context, String action, String groupCode) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await apiService.post("/SRVC/FamilyController.php", {
        'act': action,
        'groupCode': groupCode,
        'userID': auth.id,
      });
      if (response['status'] == true) {
        if (action == "delGroup") {
          // famState.removeMembersExcept(int.parse(auth.id));
          famState.reset();
          famState.setWName("welcome", title: "สร้างกลุ่ม");
        }

        // onFetchSuccess(famState);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            textStyle: TextStyle(color: AppPallete.white),
            color: Colors.indigo, 
          ),
        ),
        child: PopupMenuButton<String>(
          icon: Icon(
            FontAwesomeIcons.ellipsisV,
            color: AppPallete.purple,
          ),
          onSelected: (action) {
            if (ontap != null) ontap!(action);

            _groupAction(context, action, famState.groupCode);
          },
          itemBuilder: (BuildContext context) => _buildMenuItems(),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems() {
    final menuItems = <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'dashboard',
        child: Text('ภาพรวม', style: TextStyle(fontFamily: 'thaifont',color: AppPallete.white)),
      ),
    ];

    if (famState.level != "A") {
      menuItems.add(
         PopupMenuItem<String>(
          value: 'levelGroup',
          child: Text('ออกจากกลุ่ม', style: TextStyle(fontFamily: 'thaifont',color: AppPallete.white)),
        ),
      );
    } else if (famState.level == "A") {
      menuItems.add(
         PopupMenuItem<String>(
          value: 'delGroup',
          child: Text('ลบกลุ่ม', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'thaifont',color: AppPallete.white)),
        ),
      );
    }

    return menuItems;
  }
}

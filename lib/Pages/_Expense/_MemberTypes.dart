import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/_AddExpense/member_types.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Widgets/CPointer.dart';

class MemberTypesOptions extends StatefulWidget {
  final List<MemberTypesModel> memberTypesModel;
  final MemberTypesModel currentMemberType;
  final Function(MemberTypesModel) setValueMember;

  const MemberTypesOptions(
    {
      super.key, 
      required this.memberTypesModel, 
      required this.currentMemberType, 
      required this.setValueMember, 
    }
  );

  @override
  State<MemberTypesOptions> createState() => _MemberTypesOptionsState();
}

class _MemberTypesOptionsState extends State<MemberTypesOptions> {
  MemberTypesModel? newMemberType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newMemberType = widget.currentMemberType;
  }

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CPointer(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    FontAwesomeIcons.times,
                    size: 20,
                    color: AppPallete.white,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "ประเภทผู้ใช้",
            style: TextStyle(
                fontFamily: 'thaifont',
                fontSize: 16,
                color: AppPallete.white),
          ),
          // GridView directly in the Column without SingleChildScrollView
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.memberTypesModel.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CPointer(
                    onTap: () => setState(() {
                      widget.setValueMember(widget.memberTypesModel[index]);
                      newMemberType = widget.memberTypesModel[index];
                      Navigator.pop(context);
                    }),
                    child: Center(
                      child: Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1, 
                            color: newMemberType!.id == widget.memberTypesModel[index].id? AppPallete.gradient3 : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: AppPallete.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer<AuthProvider>(builder:  (context, auth, child) {
                              return Image.asset(widget.memberTypesModel[index].id == 1 ? "assets/images/profiles/${auth.data['profile']}" : "assets/images/member_types/${widget.memberTypesModel[index].img}", width: 50);
                            }, ),
                            AutoSizeText(
                              minFontSize: 12.0,
                              maxFontSize: 16.0,
                              maxLines: 2,
                              widget.memberTypesModel[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'thaifont',
                                fontWeight: FontWeight.bold,
                                color: newMemberType!.id == widget.memberTypesModel[index].id ? AppPallete.gradient3 : Colors.indigo,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Widgets/CPointer.dart';

class FamilyDashboard extends StatefulWidget {
  const FamilyDashboard({super.key});

  @override
  State<FamilyDashboard> createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends State<FamilyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FamilyModel>(
      builder: (context, Family, child) {
        return Container(
          color: HexColor("#6a5ae0"),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.only(bottom: 10),
                child: Stack(
                  children: [
                    Align(alignment: Alignment.center, child: Text(Family.title, style: TextStyle(color: Colors.white, fontSize: 20))),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: CPointer(onTap: () => Family.setWName("home", title: "กลุ่มของฉัน"), child: Icon(Icons.chevron_left, color: AppPallete.white, size: 30))),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor("#5144b6"),
                    ),
                    width: MediaQuery.of(context).size.width * .8,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(.5),
                            ),
                            margin: EdgeInsets.all(3),
                            height: double.infinity,
                            child: Center(child: Text("data", style: TextStyle(color: AppPallete.white))),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.all(3),
                            height: double.infinity,
                            child: Center(child: Text("data", style: TextStyle(color: AppPallete.grey))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: HexColor('#efeefc'),
                ),
                child: Column(
                  children: [],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

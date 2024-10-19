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
    // Cache media query for performance
    final mediaQuery = MediaQuery.of(context);

    return Consumer<FamilyModel>(
      builder: (context, familyModel, child) {
        return Container(
          color: HexColor("#6a5ae0"),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildHeader(familyModel),
              const SizedBox(height: 10),
              _buildCenterRow(mediaQuery),
              const SizedBox(height: 10),
              _buildContentBox(),
            ],
          ),
        );
      },
    );
  }

  // Extracted header to a separate method
  Widget _buildHeader(FamilyModel familyModel) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              familyModel.title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CPointer(
              onTap: () => familyModel.setWName("home", title: "กลุ่มของฉัน"),
              child: Icon(
                Icons.chevron_left,
                color: AppPallete.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterRow(MediaQueryData mediaQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 35,
          width: mediaQuery.size.width * .8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: HexColor("#5144b6"),
          ),
          child: Row(
            children: [
              _buildCenterDataBox("data", bg: AppPallete.white.withOpacity(0.5)),
              _buildCenterDataBox("data"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenterDataBox(String text, {Color bg = Colors.transparent}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bg,
        ),
        margin: const EdgeInsets.all(3),
        height: double.infinity,
        child: Center(
          child: Text(text, style: TextStyle(color: AppPallete.white)),
        ),
      ),
    );
  }

  Widget _buildContentBox() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: HexColor('#efeefc'),
      ),
      child: const Column(
        children: [], 
      ),
    );
  }
}

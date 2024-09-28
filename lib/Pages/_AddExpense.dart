import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:srvc/Widgets/BounceAnim.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => __AddExpenseState();
}

class __AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {

    return PopUp();
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Center(
    //     child: InkWell(
    //       onTap: () => Navigator.pop(context),
    //       child: Container(
    //         color: Colors.grey[50],
    //         padding: const EdgeInsets.all(8.0),
    //         child: BounceInPage(
    //           child: Container(
    //             height: 100,
    //             width: 100,
    //             color: Colors.blue,
    //             child: const Center(
    //               child: AutoSizeText(
    //                 "Click Me!",
    //                 maxLines: 1,
    //                 minFontSize: 18,
    //                 maxFontSize: 36,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontFamily: 'thaifont',
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}

class PopUp extends StatefulWidget {
  const PopUp({super.key});

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  int active = 0;
  List<Map<String, dynamic>> options = [
    {'menuIcon': Image.asset('assets/images/types/food.png', width: 25.0, height: 25.0,), 'menuTextTH': 'อาหาร', 'menuTextEN': 'food'},
    {'menuIcon': Image.asset('assets/images/types/apartments.png', width: 25.0, height: 25.0,), 'menuTextTH': 'ค่าเช่า', 'menuTextEN': 'apartments'},
    {'menuIcon': Image.asset('assets/images/types/baby.png', width: 25.0, height: 25.0,), 'menuTextTH': 'ลูก', 'menuTextEN': 'baby'},
    {'menuIcon': Image.asset('assets/images/types/car.png', width: 25.0, height: 25.0,), 'menuTextTH': 'การเดินทาง', 'menuTextEN': 'car'},
    {'menuIcon': Image.asset('assets/images/types/heal.png', width: 25.0, height: 25.0,), 'menuTextTH': 'พยาบาล', 'menuTextEN': 'heal'},
    {'menuIcon': Image.asset('assets/images/types/internet.png', width: 25.0, height: 25.0,), 'menuTextTH': 'อินเทอร์เน็ต', 'menuTextEN': 'internet'},
    {'menuIcon': Image.asset('assets/images/types/pet.png', width: 25.0, height: 25.0,), 'menuTextTH': 'สัตว์เลี้ยง', 'menuTextEN': 'pet'},
    {'menuIcon': Image.asset('assets/images/types/shirt.png', width: 25.0, height: 25.0,), 'menuTextTH': 'เสื้อผ้า', 'menuTextEN': 'shirt'},
    {'menuIcon': Image.asset('assets/images/types/study.png', width: 25.0, height: 25.0,), 'menuTextTH': 'การศึกษา', 'menuTextEN': 'study'},
    {'menuIcon': Image.asset('assets/images/types/tax.png', width: 25.0, height: 25.0,), 'menuTextTH': 'ภาษี', 'menuTextEN': 'tax'},
    {'menuIcon': Image.asset('assets/images/types/teeth.png', width: 25.0, height: 25.0,), 'menuTextTH': 'ทำฟัน', 'menuTextEN': 'teeth'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FontAwesomeIcons.times,
                    size: 20.0,
                    color: Colors.pink[400],
                  ),
                  Icon(
                    FontAwesomeIcons.check,
                    size: 20.0,
                    color: Colors.pink[400],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              height: MediaQuery.of(context).size.height * 0.55,
              child: generateMenu(),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.black
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                color: Colors.pink
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget generateMenu() {
    int item_per_row = 4;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: item_per_row,
        childAspectRatio: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: options.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              active = index; // อัพเดท active เมื่อมีการกด
            });
            print(index);
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.0,
                color: (active == index) ? Colors.pink : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: active == index ? Colors.pink.withOpacity(0.3) : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                options[index]['menuIcon'], // แสดงไอคอน
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    options[index]['menuTextTH'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10.0, fontFamily: 'thaifont', fontWeight: FontWeight.bold), 
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget generateBtn (text, background_color) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: background_color
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: background_color
      ),
      child: text,
      height: 20.0,
    );
  }
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/_AddExpense/expense_types.dart';
import 'package:srvc/Services/AppPallete.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/_Expense/numpad.dart';
import 'package:srvc/Services/numberFormat.dart';
import 'package:srvc/Widgets/CPointer.dart';
import '_Datepicker.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  ApiService apiService = ApiService(serverURL);
  late final AuthProvider authProvider;
  Map<String, dynamic> srvc_transaction = {
    'type_id' : null,
    'record_type' : null,
    'amount' : null,
    'is_stable' : null,
    'date' : null,
    'time' : null,
    'create_by' : null
  };

  Map<String, dynamic> defaultValue = {
    'type_id' : null,
    'record_type' : 'e',
    'amount' : null,
    'is_stable' : '0',
    'date' : DateTime.now(),
    'time' : DateTime.now(),
    'create_by' : null
  };

  // variable hold models
  List<ExpenseTypesModel>? expense;
  List<ExpenseTypesModel>? income;
  ExpenseTypesModel? currentType;

  // area for basic function 
  void changeTransaction (String key, dynamic value) {
    setState(() {
      srvc_transaction[key] = value;
      
      switch (key) {
        case "type_id" :
          if (srvc_transaction['record_type'] == 'e') {
            currentType = expense!.firstWhere((expense) => expense.id == value);
          } else {
            currentType = income!.firstWhere((income) => income.id == value);
          }
          break;
        case "record_type" :
          currentType = srvc_transaction['record_type'] == 'e' ? expense!.first : income!.first;
          srvc_transaction['type_id'] = currentType!.id;
          break;
        default:
          break;
      }
    });
  }

  void getDatePicked (DateTime selected) {
    changeTransaction("date", selected);
    changeTransaction("time", selected);
  }

  void getTimeSelected (String selected) {
    changeTransaction("time", selected);
  }

  void confirmState (BuildContext context){
    if (Numpad.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("กรุณากรอกจำนวนเงิน")));
    } else {
      changeTransaction('amount', double.parse(Numpad.value));
      String total = srvc_transaction['amount'] > 999999 ? "${formatNumber((srvc_transaction['amount']/1000000).toString(), withCommas: true, removeDecimal: false)}M฿" : "${formatNumber(Numpad.value, withCommas: true, removeDecimal: false)}฿";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${currentType!.name}: ", style: TextStyle(fontFamily: 'thaifont', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.indigo),),
                SizedBox(
                  width: 80,
                  child: AutoSizeText(
                    total,
                    minFontSize: 8,
                    maxFontSize: 14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'thaifont',
                      fontWeight: FontWeight.bold,
                      color: srvc_transaction['record_type'] == 'e' ? AppPallete.red : AppPallete.green
                    ),
                  ),
                )
              ],
            ),
            content: 
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("รายการนี้เป็น", style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: Colors.grey),),
                    Text(srvc_transaction['record_type'] == 'e'? 'ค่าใช้จ่ายจำเป็น' : 'รายได้ประจำ', style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: Colors.indigo),),
                  ],
                ),
                Text("หรือไม่?", style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: Colors.grey),),
              ],
            ),
            actions: [
              TextButton(
                onPressed: ()=>Navigator.of(context).pop(true), 
                child: Text('ใช่')
              ),
              TextButton(
                onPressed: ()=>Navigator.of(context).pop(false), 
                child: Text('ไม่')
              )
            ],
          );
        }
      ).then((result){
        if (result != null && result) {
          changeTransaction('is_stable', 1);
          print(srvc_transaction);
          saveRecord();
        } else if (result != null && !result) {
          changeTransaction('is_stable', 0);
          print(srvc_transaction);
          saveRecord();
        }
      });
    }
  }

  // area for load model data
  void loadExpenseTypes () async{
    List<ExpenseTypesModel> expenseTypesModel = await ExpenseTypes().getExpenseTypes();
    setState(() {
      expense = expenseTypesModel.where((expense) => expense.type == "expense").toList();
      income = expenseTypesModel.where((expense) => expense.type == "income").toList();
      currentType = srvc_transaction['record_type'] == 'e' ? expense!.first : income!.first;
      changeTransaction("type_id", currentType!.id);
    });
  }

  // area for query function 
  Future<void> saveRecord () async{
    Map<String, dynamic> copyTransaction = Map.from(srvc_transaction);
    copyTransaction['act'] = "saveRecord";
    copyTransaction['date'] = copyTransaction['date'].toString();
    copyTransaction['time'] = copyTransaction['time'].toString();
    final response = await apiService.post("/SRVC/ExpenseController.php", copyTransaction);
    bool fetchStatus = response['status'];
    if (fetchStatus == true) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด")));
    }

  }

  @override
  void initState() {
    super.initState();
    Numpad().clearValue();
    srvc_transaction.addAll(defaultValue);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    srvc_transaction['create_by'] = authProvider.id;
    loadExpenseTypes();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigoAccent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CPointer(
                      onTap: () => Navigator.pop(context),
                      child: Icon(FontAwesomeIcons.arrowLeft, size: 20, color: AppPallete.white,)
                    ),
                    dateTimePicker(),
                    SizedBox(width: 20,)
                  ],
                ),
              ),
              recordPart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateTimePicker () {
    String showText = "เลือกวัน/เดือน/ปี";
    if (srvc_transaction['date'] != null) showText = "${srvc_transaction['date'].day}/${srvc_transaction['date'].month}/${srvc_transaction['date'].year + 543}";
    return CPointer(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DatePicker(selectedDate: srvc_transaction['date'] ?? DateTime.now(), getDatePicker: getDatePicked))
        ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(75, 255, 255, 255)
        ),
        child: Text(showText, style: TextStyle(fontFamily: 'thaifont', fontSize: 14, color: AppPallete.white),),
      ),
    );
  }

  Widget recordPart () {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(srvc_transaction['record_type'] == 'e' ? "ค่าใช้จ่าย" : "รายได้", style: TextStyle(fontFamily: 'thaifont', fontSize: 16, color: AppPallete.white),),
              SizedBox(width: 5,),
              CPointer(
                onTap: () => changeTransaction("record_type", srvc_transaction['record_type'] == 'e' ? 'i' : 'e'),
                child: Icon(FontAwesomeIcons.sync, size: 16, color: AppPallete.gradient3,)
              ),
            ],
          ),
          previewType(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.arrowLeft, size: 15, color: const Color.fromARGB(125, 255, 255, 255),),
                Icon(FontAwesomeIcons.arrowRight, size: 15, color: const Color.fromARGB(125, 255, 255, 255),),
              ],
            ),
          ),
          showTypesOptions(srvc_transaction['record_type'] == 'e' ? expense : income),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppPallete.white
                    ),
                    child: Center(
                      child: Text(Numpad.value.isEmpty ? Numpad.value : formatNumber(Numpad.value, withCommas: true, removeDecimal: false)),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CPointer(
                    onTap: ()=> confirmState(context),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppPallete.white
                      ),
                      child: Center(
                        child: Icon(FontAwesomeIcons.solidCheckCircle, color: AppPallete.green,),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          numpad()
        ],
      ),
    );
  }

  Widget previewType () {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: AppPallete.gradient3
            ),
            borderRadius: BorderRadius.circular(1000),
            color: AppPallete.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/${currentType != null ? "images/types/${currentType!.img}" : "loader/loading1.gif"}", width: 75, height: 75,),
              AutoSizeText(
                currentType != null ? currentType!.name : "กำลังโหลด...",
                minFontSize: 10,
                maxFontSize: 14,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'thaifont', fontWeight: FontWeight.bold, color: Colors.indigo,),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showTypesOptions (List<ExpenseTypesModel>? typeList) {
    if (typeList != null) {
      return SizedBox(
        height: 100,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(typeList.length, (index){
              return Padding(
                padding: EdgeInsets.all(5),
                child: CPointer(
                  onTap: () => changeTransaction("type_id", typeList[index].id),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: currentType!.id == typeList[index].id? AppPallete.gradient3 : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(1000),
                          color: AppPallete.white
                        ),
                        child: Center(child: Image.asset("assets/images/types/${typeList[index].img}", width: 35,)),
                      ),
                      SizedBox(height: 5,),
                      AutoSizeText(
                        minFontSize: 8.0,
                        maxFontSize: 12.0,
                        maxLines: 2,
                        typeList[index].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'thaifont',
                          fontWeight: FontWeight.bold,
                          color: currentType!.id == typeList[index].id ? AppPallete.gradient3 : AppPallete.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text('กำลังโหลด...', style: TextStyle(fontFamily: 'thaifont', fontSize: 14, color: AppPallete.white),),
        ),
      );
    }
  }

  Widget numpad () {
    List<Map<String, dynamic>> numpadKeys = Numpad.numpadKeys;
    int maxKeysPerRow = 3;
    List<Widget> currentRowItems = [];
    List<Widget> rows = [];
    for (var item in numpadKeys) {
      Widget key = Expanded(
        flex: item['flex'],
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CPointer(
            onTap: () {
              setState(() {
                item['ontap']();
              });
            },
            child: Container(
              width: 65,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppPallete.white
              ),
              child: Center(child: item['key'],),
            ),
          ),
        ),
      );

      currentRowItems.add(key);

      if (currentRowItems.length >= maxKeysPerRow) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: currentRowItems,
        ));
        currentRowItems = [];
      }
    }

    if (currentRowItems.isNotEmpty) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: currentRowItems,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rows,
    );
  }

}


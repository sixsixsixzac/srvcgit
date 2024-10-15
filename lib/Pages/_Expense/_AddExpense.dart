
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Models/_AddExpense/account_types.dart';
import 'package:srvc/Models/_AddExpense/expense_types.dart';
import 'package:srvc/Models/_AddExpense/member_types.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Pages/_Expense/_MemberTypes.dart';
import 'package:srvc/Services/APIService.dart';
import 'package:srvc/Services/_Expense/numpad.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import 'package:srvc/Services/numberFormat.dart';
import 'package:srvc/Widgets/CPointer.dart';
import '_AccountTypes.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  ApiService apiService = ApiService(serverURL);
  late final AuthProvider authProvider;
  List<AccountTypesModel>? accountTypesModel;
  AccountTypesModel? currentAccountType;
  
  List<ExpenseTypesModel>? expenseTypeModel;

  Map<String, dynamic> transaction = {
    'id' : null,
    'type_id' : null,
    'record_type' : 'e',
    'for_id' : null,
    'account_type' : null,
    'amount' : null,
    'date' : null,
    'time' : null,
    'create_by' : null
  };

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    transaction['create_by'] = int.parse(authProvider.id);

    loadAccountTypes();
    loadExpenseTypes();
    Numpad().clearValue();
  }


  void loadAccountTypes() async {
    accountTypesModel = await AccountTypes().getAccountTypes();
    setDefaultAccount();
  }

  void setDefaultAccount () {
      setState(() {
        currentAccountType = accountTypesModel![1];
        transaction['account_type'] = accountTypesModel![1].id;
      });
  }

  void setValueAccount (AccountTypesModel selected) {
    setState(() {
        transaction['account_type'] = selected.id;
        currentAccountType = selected;
    });
  }

  void setValueForId (int selected) {
    setState(() {
      transaction['for_id'] = selected;
    });
  }

  void setValueType (int selected) {
    setState(() {
      transaction['type_id'] = selected;
    });
  }

  void changeRecordType () {
    setState(() =>transaction['record_type'] = transaction['record_type'] == 'e' ? 'i' : 'e');
  }

  void loadExpenseTypes () async{
    expenseTypeModel = await ExpenseTypes().getExpenseTypes();
  }

  Future<void> saveRecord() async {
    setState(() {
      transaction['amount'] = double.parse(Numpad.value);
      transaction['act'] = "saveRecord";
    });
    final response = await apiService.post("/SRVC/ExpenseController.php", transaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigoAccent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CPointer(
                        onTap: (){
                          saveRecord();
                        },
                        child: Icon(
                          FontAwesomeIcons.check,
                          size: 20,
                          color: AppPallete.white,
                        ),
                      ),
                      accountTypesSelection(),
                      CPointer(
                        onTap: (){
                          Navigator.pop(context);
                        } ,
                        child: Icon(
                          FontAwesomeIcons.times,
                          size: 20,
                          color: AppPallete.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              waitIncomeExpense(),
            ],
          ),
        ),
      ),
    );
  }

  Widget accountTypesSelection() {
    if (accountTypesModel != null && accountTypesModel!.isNotEmpty){
      return CPointer(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountTypesOptions(accountTypesModel: accountTypesModel!, currentAccountType: currentAccountType!, setValueAccount: setValueAccount,))
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent
            ),
            color: const Color.fromARGB(25, 0, 0, 0),
            borderRadius: BorderRadius.circular(25)
          ),
          child: Center(
            child: Row(
              children: [
                Text(currentAccountType!.name, style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: AppPallete.white)),
                SizedBox(width: 5,),
                Icon(FontAwesomeIcons.chevronDown, size: 8, color: AppPallete.white,)
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent
          ),
          color: const Color.fromARGB(25, 0, 0, 0),
          borderRadius: BorderRadius.circular(25)
        ),
        child: Center(
          child: Row(
            children: [
              Text("กำลังโหลด...", style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: AppPallete.white)),
              SizedBox(width: 5,),
              Icon(FontAwesomeIcons.chevronDown, size: 8, color: AppPallete.white,)
            ],
          ),
        ),
      );
    }
  }

  Widget waitIncomeExpense() {
    if (expenseTypeModel != null) {
      return _Record(setValueForId: setValueForId, setValueType: setValueType ,changeRecordType: changeRecordType, expenseTypesmodel: expenseTypeModel!, record_type: transaction['record_type'], );
    } else {
      return Text("กำลังโหลด...", style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: AppPallete.white));

    }
  }
}

class _Record extends StatefulWidget {
  final Function(int) setValueForId;
  final Function(int) setValueType;
  final Function changeRecordType;
  final List<ExpenseTypesModel> expenseTypesmodel;
  final String record_type;
  const _Record(
    {
      super.key, 
      required this.setValueForId, 
      required this.setValueType, 
      required this.changeRecordType, 
      required this.expenseTypesmodel, 
      required this.record_type, 
    }
  );

  @override
  State<_Record> createState() => __RecordState();
}

class __RecordState extends State<_Record> {
  List<MemberTypesModel>? memberTypesModel;
  MemberTypesModel? currentMemberType;

  List<ExpenseTypesModel>? typeList;
  ExpenseTypesModel? currentType;

  @override
  void initState() {
    super.initState();
    loadMemberTypes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      prepareType();
    });
  }

  void loadMemberTypes() async{
    memberTypesModel = await MemberTypes().getMemberTypes();
    setDefaultMember();
  }

  void setDefaultMember() {
    setState(() {
      currentMemberType = memberTypesModel![0];
      widget.setValueForId(memberTypesModel![0].id);
    });
  }

  void setValueMember(MemberTypesModel selected){
    setState(() {
      currentMemberType = selected;
      widget.setValueForId(selected.id);
    });
  }

  void prepareType() {
    setState(() {
      typeList = widget.record_type == 'i' ? widget.expenseTypesmodel.where((item) => item.type == "income").toList() : widget.expenseTypesmodel.where((item) => item.type == "expense").toList();
      currentType = typeList![0];
      widget.setValueType(typeList![0].id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.record_type == "i" ? "รายรับ" : "รายจ่าย", style: TextStyle(fontFamily: 'thaifont', fontSize: 14, color: AppPallete.white),),
              SizedBox(width: 10,),
              CPointer(
                onTap: () => setState(() {
                   widget.changeRecordType();
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                    prepareType();
                  });
                }),
                child: Icon(FontAwesomeIcons.sync, size: 20, color: AppPallete.gradient3,)
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                previewType(),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.arrowLeft, size: 15, color: const Color.fromARGB(175, 255, 255, 255),),
                      Icon(FontAwesomeIcons.arrowRight, size: 15, color: const Color.fromARGB(175, 255, 255, 255),),
                    ],
                  ),
                ),
                showOptions(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
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
                    previewMemberType()
                  ],
                ),
                numpad()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget previewMemberType () {
    if (memberTypesModel != null) {
      return Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CPointer(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MemberTypesOptions(memberTypesModel: memberTypesModel!, currentMemberType: currentMemberType!, setValueMember: setValueMember,))
                    ),
                    child: Container(
                      width: 65,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppPallete.white
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<AuthProvider>(builder: (context, auth, child) {
                            return Image.asset(currentMemberType!.id == 1 ? "assets/images/profiles/${auth.data['profile']}" : "assets/images/member_types/${currentMemberType!.img}", width: 30);
                          },)
                        ],
                      ),
                    ),
                  ),
                ),
              );
    } else {
      return Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 65,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppPallete.white
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/loader/loading1.gif", width: 30,),
                      ],
                    ),
                  ),
                ),
              );
    }
  }

  Widget previewType () {
    return Container(
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
          Image.asset(
            currentType != null ? "assets/images/types/${currentType!.img}" : "assets/loader/loading1.gif",
            height: 50,
            width: 50,
          ),
          AutoSizeText(
            minFontSize: 12.0,
            maxFontSize: 16.0,
            maxLines: 2,
            currentType != null ? currentType!.name : "กำลังโหลด...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'thaifont',
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget showOptions () {
    if (typeList != null) {
      return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(typeList!.length, (index){
            return Padding(
              padding: EdgeInsets.all(5),
              child: CPointer(
                onTap: () => setState(() {
                  currentType = typeList![index];
                  widget.setValueType(typeList![index].id);
                }),
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
                          color: currentType!.id == typeList![index].id? AppPallete.gradient3 : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(1000),
                        color: AppPallete.white
                      ),
                      child: Center(child: Image.asset("assets/images/types/${typeList![index].img}", width: 35,)),
                    ),
                    SizedBox(height: 5,),
                    AutoSizeText(
                      minFontSize: 8.0,
                      maxFontSize: 12.0,
                      maxLines: 2,
                      typeList![index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'thaifont',
                        fontWeight: FontWeight.bold,
                        color: currentType!.id == typeList![index].id ? AppPallete.gradient3 : AppPallete.white,
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
      return Container(
      height: 100,
      child: Center(
        child: AutoSizeText(
            minFontSize: 12.0,
            maxFontSize: 16.0,
            maxLines: 2,
            "กำลังโหลด...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'thaifont',
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            overflow: TextOverflow.ellipsis,
          ),
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
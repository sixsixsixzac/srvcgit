import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/_AddExpense/account_types.dart';
import 'package:srvc/Models/_AddExpense/expense_types.dart';
import 'package:srvc/Models/_AddExpense/member_types.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Pages/_Expense/_MemberTypes.dart';
import 'package:srvc/Services/_Expense/numpad.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Providers/AuthProvider.dart';
import '_AccountTypes.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  late final AuthProvider authProvider;
  String recordType = 'expense';
  int? accountType;
  String? accountTypesText;

  int defaultAccountTypesIndex = 1;
  List<AccountTypesModel>? accountTypesModel;

  List<ExpenseTypesModel>? incomeTypes;
  List<ExpenseTypesModel>? expenseTypes;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    loadAccountTypes();
    loadExpenseTypes();
  }

  void loadAccountTypes() async {
    accountTypesModel = await AccountTypes().getAccountTypes();
    setDefaultAccount();
    setState(() {});
  }

  void setDefaultAccount () {
    if (accountTypesModel != null && accountTypesModel!.isNotEmpty) {
      setState(() {
        accountType = accountTypesModel![defaultAccountTypesIndex].id;
        accountTypesText = accountTypesModel![defaultAccountTypesIndex].name;
      });
    }
  }

  void setValueAccount (int selectAccountType, String selectAccountTypetext) {
    setState(() {
      accountType = selectAccountType;
      accountTypesText = selectAccountTypetext;
    });
  }

  void changeRecordType (newRecordType) {
    setState(() {
      recordType = newRecordType;
    });
  }

  void loadExpenseTypes () async{
    List<ExpenseTypesModel> expenseTypeModel = await ExpenseTypes().getExpenseTypes();
    incomeTypes = expenseTypeModel.where((item) => item.type == "income").toList();
    expenseTypes = expenseTypeModel.where((item) => item.type == "expense").toList();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Icon(
                      FontAwesomeIcons.check,
                      size: 20,
                      color: AppPallete.white,
                    ),
                    accountTypesSelection(),
                    InkWell(
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
            ),
            waitIncomeExpense(),
          ],
        ),
      ),
    );
  }

  Widget accountTypesSelection() {
    if (accountTypesModel != null && accountTypesModel!.isNotEmpty){
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountTypesOptions(accountTypesModel: accountTypesModel!, defaultAccountTypesIndex: defaultAccountTypesIndex, setValueAccount: setValueAccount, currentAccountType: accountType,))
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
                Text(accountTypesText!, style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: AppPallete.white)),
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
    if (incomeTypes != null && expenseTypes != null) {
      return _Record(changeRecordType: changeRecordType, recordType: recordType, typeList: recordType == "income" ? incomeTypes! : expenseTypes!,);
    } else {
      return Text("กำลังโหลด...", style: TextStyle(fontFamily: 'thaifont', fontSize: 12, color: AppPallete.white));

    }
  }
}

class _Record extends StatefulWidget {
  final Function(String) changeRecordType;
  final String recordType;
  final List<ExpenseTypesModel> typeList;
  const _Record({super.key, required this.changeRecordType, required this.typeList, required this.recordType});

  @override
  State<_Record> createState() => __RecordState();
}

class __RecordState extends State<_Record> {
  List<MemberTypesModel>? memberTypesModel;
  int defaultMemberTypesIndex = 0;
  int? memberTypes;
  String? memberTypesText;
  String? memberTypesImage;

  String? image_path;
  String? menu_text;
  int activeOption = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMemberTypes();
    
  }

  void loadMemberTypes() async{
    memberTypesModel = await MemberTypes().getMemberTypes();
    setDefaultMember();
    setState(() {
      
    });
  }

  void setDefaultMember() {
    memberTypes = memberTypesModel![defaultMemberTypesIndex].id;
    memberTypesText = memberTypesModel![defaultMemberTypesIndex].name;
    memberTypesImage = "assets/images/member_types/${memberTypesModel![defaultMemberTypesIndex].img}";
  }

  void setValueMember(int selectIndex){
    setState(() {
      memberTypes = memberTypesModel![selectIndex].id;
      memberTypesText = memberTypesModel![selectIndex].name;
      memberTypesImage = "assets/images/member_types/${memberTypesModel![selectIndex].img}";
    });
  }

  void returnToZero () {
    setState(() {
      image_path = null;
      menu_text = null;
      activeOption = 0;
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
              Text(widget.recordType == "income" ? "รายรับ" : "รายจ่าย", style: TextStyle(fontFamily: 'thaifont', fontSize: 14, color: AppPallete.white),),
              SizedBox(width: 10,),
              InkWell(
                onTap: () => setState(() {
                   widget.changeRecordType(widget.recordType == "income" ? "expense" : "income");
                   returnToZero();
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
                            borderRadius: BorderRadius.circular(25),
                            color: AppPallete.white
                          ),
                          child: Center(
                            child: Text(Numpad.value),
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
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MemberTypesOptions(memberTypesModel: memberTypesModel!, defaultMemberTypesIndex: defaultMemberTypesIndex, setValueMember: setValueMember, currentMemberTypes: memberTypes!))
                    ),
                    child: Container(
                      width: 65,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: AppPallete.white
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(memberTypesImage!, width: 30,),
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
                      borderRadius: BorderRadius.circular(1000),
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
            image_path ?? "assets/images/types/${widget.typeList[activeOption].img}",
            height: 50,
            width: 50,
          ),
          AutoSizeText(
            minFontSize: 12.0,
            maxFontSize: 16.0,
            maxLines: 2,
            menu_text ?? widget.typeList[activeOption].name,
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
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.typeList.length, (index){
            return Padding(
              padding: EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () => setState(() {
                  image_path = "assets/images/types/${widget.typeList[index].img}";
                  menu_text = widget.typeList[index].name;
                  activeOption = index;
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
                          color: activeOption == index? AppPallete.gradient3 : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(1000),
                        color: AppPallete.white
                      ),
                      child: Center(child: Image.asset("assets/images/types/${widget.typeList[index].img}", width: 35,)),
                    ),
                    SizedBox(height: 5,),
                    AutoSizeText(
                      minFontSize: 8.0,
                      maxFontSize: 12.0,
                      maxLines: 2,
                      widget.typeList[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'thaifont',
                        fontWeight: FontWeight.bold,
                        color: activeOption == index ? AppPallete.gradient3 : AppPallete.white,
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
          child: GestureDetector(
            onTap: () {
              setState(() {
                item['ontap']();
              });
            },
            child: Container(
              width: 65,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
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
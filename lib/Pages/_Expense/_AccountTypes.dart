import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Models/_AddExpense/account_types.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Widgets/CPointer.dart';

class AccountTypesOptions extends StatefulWidget {
  final List<AccountTypesModel> accountTypesModel;
  final AccountTypesModel currentAccountType;
  final Function setValueAccount;
  const AccountTypesOptions(
      {
        super.key,
        required this.accountTypesModel,
        required this.currentAccountType,
        required this.setValueAccount, 
      });

  @override
  State<AccountTypesOptions> createState() => _AccountTypesOptionsState();
}

class _AccountTypesOptionsState extends State<AccountTypesOptions> {
  AccountTypesModel? newAccountType;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.indigoAccent,
        body: SingleChildScrollView(
          child: Column(
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
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ประเภทบัญชี",
                    style: TextStyle(
                        fontFamily: 'thaifont',
                        fontSize: 16,
                        color: AppPallete.white),
                  ),
                  _PreviewAccountSelected(show: newAccountType ?? widget.currentAccountType,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.accountTypesModel.length} ตัวเลือก",
                          style: TextStyle(
                              fontFamily: 'thaifont',
                              fontSize: 10,
                              color: const Color.fromARGB(170, 255, 255, 255)),
                        ),
                        Text(
                          "สไลด์เพื่อดูเพิ่มเติม",
                          style: TextStyle(
                              fontFamily: 'thaifont',
                              fontSize: 10,
                              color: const Color.fromARGB(170, 255, 255, 255)),
                        )
                      ],
                    ),
                  ),
                  _AccountOptions(
                    accountTypesModel: widget.accountTypesModel,
                    selectedOption: newAccountType ?? widget.currentAccountType,
                    changeAccountType: (item) {
                      setState(() {
                        newAccountType = item;
                        widget.setValueAccount(item);
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewAccountSelected extends StatefulWidget {
  final AccountTypesModel show;
  const _PreviewAccountSelected(
      {
        super.key, 
        required this.show,
      });

  @override
  State<_PreviewAccountSelected> createState() =>
      __PreviewAccountSelectedState();
}

class __PreviewAccountSelectedState extends State<_PreviewAccountSelected> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
            border: Border.all(width: 5, color: AppPallete.gradient3),
            borderRadius: BorderRadius.circular(1000),
            color: AppPallete.backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/account_types/${widget.show.img}",
              width: 50,
              height: 50,
            ),
            AutoSizeText(
              minFontSize: 12.0,
              maxFontSize: 16.0,
              maxLines: 2,
              widget.show.name,
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
      ),
    );
  }
}

class _AccountOptions extends StatefulWidget {
  final List<AccountTypesModel> accountTypesModel;
  final AccountTypesModel selectedOption;
  final Function(AccountTypesModel item) changeAccountType;

  const _AccountOptions(
      {
        super.key, 
        required this.accountTypesModel, 
        required this.selectedOption, 
        required this.changeAccountType,
      });

  @override
  State<_AccountOptions> createState() => __AccountOptionsState();
}

class __AccountOptionsState extends State<_AccountOptions> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    int pageCount = (widget.accountTypesModel.length / 4).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 175,
          child: PageView(
            onPageChanged: (int value) {
              setState(() {
                currentPage = value + 1;
              });
            },
            children: buildMenu(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$currentPage / $pageCount",
            style: TextStyle(
                fontFamily: 'thaifont', fontSize: 12, color: AppPallete.white),
          ),
        )
      ],
    );
  }

  List<Widget> buildMenu() {
    int maxItemPerRow = 2;
    int maxRowPerPage = 2;

    List<Widget> currentRowItems = [];
    List<Widget> rows = [];
    List<Widget> columns = [];

    for (var item in widget.accountTypesModel) {
      Widget menu = CPointer(
        onTap: () => widget.changeAccountType(item),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 125,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppPallete.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/account_types/${item.img}",
                  width: 50,
                  height: 50,
                ),
                AutoSizeText(
                  minFontSize: 8.0,
                  maxFontSize: 12.0,
                  maxLines: 2,
                  item.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'thaifont',
                    fontWeight: FontWeight.bold,
                    color: widget.selectedOption.id == item.id
                        ? AppPallete.gradient3
                        : Colors.indigo,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      );

      currentRowItems.add(menu);

      if (currentRowItems.length >= maxItemPerRow) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: currentRowItems,
        ));
        currentRowItems = [];
      }

      if (rows.length >= maxRowPerPage) {
        columns.add(Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
        rows = [];
      }
    }

    if (currentRowItems.isNotEmpty) {
      rows.add(Row(
        children: currentRowItems,
      ));
    }

    if (rows.isNotEmpty) {
      columns.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      ));
    }

    return columns;
  }
}

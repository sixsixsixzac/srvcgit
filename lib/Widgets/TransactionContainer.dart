import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:srvc/Animation/Bounce.dart';
import 'package:srvc/Services/HexColor.dart';
import 'package:srvc/Services/dateformat.dart';
import 'package:srvc/Services/numberFormat.dart';

class Transactioncontainer extends StatefulWidget {
  final BuildContext context;
  final int index;
  final Map<String, dynamic> data;

  final void Function()? onTap;

  const Transactioncontainer(this.context, this.data, {super.key, this.onTap, required this.index});

  @override
  __TransactioncontainerState createState() => __TransactioncontainerState();
}

class __TransactioncontainerState extends State<Transactioncontainer> {
  bool state = true;
  List<Widget> expense_list = [];
  final formatter = ThaiDateFormatter();
  @override
  void initState() {
    super.initState();

    setState(() {
      expense_list = widget.data['data'].map<Widget>((item) {
        return ListTile(
          title: Text(item['id'].toString()),
          subtitle: Text(item['id'].toString()),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exp = widget.data;

    final int etotal = exp['etotal'];
    final int itotal = exp['itotal'];
    Color bgColor = HexColor("#6e77ca");

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 0,
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                state = !state;
              });
              if (widget.onTap != null) widget.onTap!();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: state == false ? const BorderRadius.all(Radius.circular(10)) : const BorderRadius.vertical(top: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(state == false ? 0 : 0.1),
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
                color: bgColor,
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatter.format(exp['date'], type: ""), style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
                    // if (!state) Text("฿${formatNumber(widget.data['total'].toString(), withCommas: true)}", style: const TextStyle(color: Colors.white, fontFamily: 'thaifont')),
                    if (state) Icon(FontAwesomeIcons.chevronUp, color: Colors.white, size: 16),
                    if (!state) Icon(FontAwesomeIcons.chevronDown, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ),
          if (state)
            BounceAnimation(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...expense_list.asMap().entries.map((entry) {
                      int index = entry.key;
                      return innerRow(index);
                    }),
                    Column(
                      children: [
                        Divider(color: Colors.grey.withOpacity(.2)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText("รายได้: ฿${formatNumber("$itotal", withCommas: true)}",
                                    style: TextStyle(color: Colors.green), maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,textAlign: TextAlign.start),
                              ),
                              Expanded(
                                child: AutoSizeText("ค่าใช้จ่าย: ฿${formatNumber("$etotal", withCommas: true)}",
                                    style: TextStyle(color: Colors.red), maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: AutoSizeText("คงเหลือ: ${itotal - etotal < 0 ? "฿0" : "฿${formatNumber("${itotal - etotal}", withCommas: true)}"}",
                                    style: TextStyle(color: Colors.grey), maxLines: 2, minFontSize: 12, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget innerRow(index) {
    final item = widget.data['data'][index];
    final itsIncome = item['record_type'] == "i";
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.indigo[100],
            ),
            height: 50,
            width: 50,
            child: Center(child: Image.asset('assets/images/types/${item['type_img']}')),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        item['type_name'],
                        minFontSize: 14,
                        maxFontSize: 14,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'thaifont'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        item['for_who'],
                        minFontSize: 12,
                        maxFontSize: 12,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.grey, fontFamily: 'thaifont'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      "${itsIncome ? "+" : "-"}฿${formatNumber(item['amount'].toString(), withCommas: true)}",
                      minFontSize: 12,
                      maxFontSize: 12,
                      maxLines: 1,
                      style: TextStyle(color: itsIncome ? Colors.green : Colors.red, fontFamily: 'thaifont', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      item['account_type_name'],
                      minFontSize: 12,
                      maxFontSize: 12,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.grey, fontFamily: 'thaifont'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TotalDisplay extends StatelessWidget {
  final double etotal;
  final double itotal;

  const TotalDisplay({super.key, required this.etotal, required this.itotal});

  @override
  Widget build(BuildContext context) {
    Color bgColor = etotal > itotal ? Colors.red : Colors.green;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Expenses Total: \$${etotal.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            'Income Total: \$${itotal.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

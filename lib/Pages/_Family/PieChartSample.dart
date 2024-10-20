import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:srvc/Services/HexColor.dart';

class PieChartSample2 extends StatefulWidget {
  final List<Map<String, double>> PieData;
  final List data;

  const PieChartSample2({super.key, required this.data, required this.PieData});

  @override
  State<StatefulWidget> createState() => PieChartSample2State();
}

class PieChartSample2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            if (event.isInterestedForInteractions && pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
              setState(() {
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            } else {
              setState(() {
                touchedIndex = -1;
              });
            }
          },
        ),
        borderData: FlBorderData(show: false),
        sections: showingSections(pieData: widget.PieData),
      ),
    );
  }

  List<PieChartSectionData> showingSections({required List<Map<String, double>> pieData}) {
    return List.generate(pieData.length, (i) {
      final itemValue = pieData[i]['value'] ?? 0;
      final isTouched = i == touchedIndex;

      return createSectionData(color: getColorForIndex(i), value: itemValue, isTouched: isTouched, data: widget.data[i]);
    });
  }

  Color getColorForIndex(int index) {
    switch (index) {
      case 0:
        return HexColor("#9c62ff");
      case 1:
        return HexColor("#ff8b61");
      case 2:
        return HexColor('#556fff');
      case 3:
        return HexColor('#2de1aa');
      default:
        return Colors.grey;
    }
  }

  PieChartSectionData createSectionData({required Color color, required double value, required bool isTouched, required Map<String, dynamic> data}) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: "${value.toStringAsFixed(1)}%",
      radius: 100,
      titleStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
      ),
      badgeWidget: _img(path: "assets/images/types/${data['type_img']}"),
      badgePositionPercentageOffset: .98,
    );
  }

  Widget _img({required String path}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Colors.black),
        color: Colors.white,
      ),
      child: Image.asset(
        path,
        width: MediaQuery.of(context).size.width * 0.1,
      ),
    );
  }
}

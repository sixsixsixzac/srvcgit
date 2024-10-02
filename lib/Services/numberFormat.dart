import 'package:intl/intl.dart';

String formatNumber(String input, {bool removeDecimal = false, bool withCommas = false}) {
  String sanitizedInput = input.replaceAll(RegExp(r'[^0-9.]'), '');

  double number = double.tryParse(sanitizedInput) ?? 0.0;

  if (removeDecimal) {
    int intValue = number.toInt();
    return withCommas ? NumberFormat('#,###').format(intValue) : intValue.toString();
  } else {
    return withCommas ? NumberFormat('#,###.##').format(number) : number.toString();
  }
}

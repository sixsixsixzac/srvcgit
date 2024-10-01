String formatThaiDate(String inputDate) {
  final List<String> parts = inputDate.split('-');
  final DateTime date = DateTime(
    int.parse(parts[2]), 
    int.parse(parts[1]),
    int.parse(parts[0]), 
  );

  final List<String> thaiDayNames = [
    'อาทิตย์',
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
  ];


  final List<String> thaiMonthNames = [
    'ม.ค.',
    'ก.พ.',
    'มี.ค.',
    'เม.ย.',
    'พ.ค.',
    'มิ.ย.',
    'ก.ค.',
    'ส.ค.',
    'ก.ย.',
    'ต.ค.',
    'พ.ย.',
    'ธ.ค.',
  ];


  final String dayName = thaiDayNames[date.weekday % 7];
  final String monthName = thaiMonthNames[date.month - 1];
  // final String year = date.year.toString();


  return '$dayName ${date.day} - $monthName';
}

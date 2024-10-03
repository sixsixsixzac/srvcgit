class ThaiDateFormatter {
  String _returnString = "";

  static final List<String> _thaiFullMonthNames = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];

  static final List<String> _thaiShortMonthNames = [
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

  static final List<String> _thaiDayNames = [
    'อาทิตย์',
    'จันทร์',
    'อังคาร',
    'พุธ',
    'พฤหัสบดี',
    'ศุกร์',
    'เสาร์',
  ];

  String format(String inputDate, {String type = ""}) {
    final DateTime date = _parseDate(inputDate);

    final String dayName = _thaiDayNames[date.weekday % 7];
    // final String shortMonth = _thaiShortMonthNames[date.month - 1];
    final String fullMonth = _thaiFullMonthNames[date.month - 1];
    final String thaiYear = (date.year + 543).toString();

    switch (type) {
      case "day":
        _returnString = '$dayName ${date.day} - $fullMonth $thaiYear';
      case "month":
        _returnString = '$fullMonth $thaiYear';
      case "year":
        _returnString = thaiYear;
      default:
        _returnString = '$dayName ${date.day} $fullMonth ';
    }
    return _returnString;
  }

  DateTime _parseDate(String inputDate) {
    final List<String> parts = inputDate.split('-');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  String back(String inputDate, String type) {
    final DateTime date = _parseDate(inputDate);
    DateTime newDate;

    switch (type) {
      case "day":
        newDate = date.subtract(const Duration(days: 1));
        break;
      case "month":
        newDate = DateTime(date.year, date.month - 1, date.day);
        break;
      case "year":
        newDate = DateTime(date.year - 1, date.month, date.day);
        break;
      default:
        throw ArgumentError('Invalid type: $type');
    }

    String formattedDate = '${newDate.day.toString().padLeft(2, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.year}';
    return formattedDate;
  }

  String forward(String inputDate, String type) {
    final DateTime date = _parseDate(inputDate);
    DateTime newDate;

    switch (type) {
      case "day":
        newDate = date.add(const Duration(days: 1));
        break;
      case "month":
        newDate = DateTime(date.year, date.month + 1, date.day);
        break;
      case "year":
        newDate = DateTime(date.year + 1, date.month, date.day);
        break;
      default:
        throw ArgumentError('Invalid type: $type');
    }

    String formattedDate = '${newDate.day.toString().padLeft(2, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.year}';
    return formattedDate;
  }

  int getDaysInMonth(String inputDate) {
    final DateTime date = _parseDate(inputDate);
    int daysInMonth = DateTime(date.year, date.month + 1, 0).day; 
    return daysInMonth;
  }
}

class Topexpense {
  final String type_name;
  final String type_img;
  final String total_expense;
  final String percentage;
  final double grand_total;

  Topexpense({
    required this.type_name,
    required this.type_img,
    required this.total_expense,
    required this.percentage,
    required this.grand_total,
  });

  factory Topexpense.fromJson(Map<String, dynamic> json) {
    return Topexpense(
      type_name: json['type_name'],
      type_img: json['type_img'],
      total_expense: json['total_expense'].toString(),
      percentage: json['percentage'].toString(),
      grand_total: (json['grand_total'] is String) ? double.tryParse(json['grand_total']) ?? 0.0 : json['grand_total'].toDouble(),
    );
  }
}

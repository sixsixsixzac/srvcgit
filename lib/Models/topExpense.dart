class Topexpense {
  final String type_name;
  final String type_img;
  final String total_expense;
  final String percentage;

  Topexpense({
    required this.type_name,
    required this.type_img,
    required this.total_expense,
    required this.percentage,
  });

  factory Topexpense.fromJson(Map<String, dynamic> json) {
    return Topexpense(
      type_name: json['type_name'],
      type_img: json['type_img'],
      total_expense: json['total_expense'],
      percentage: json['percentage'],
    );
  }
}

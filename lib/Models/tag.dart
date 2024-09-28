class TagsModel {
  final int id;
  final String name;
  final String status;

  TagsModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory TagsModel.fromJson(Map<String, dynamic> json) {
    return TagsModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}

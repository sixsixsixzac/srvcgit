class UserModel {
  final int id;
  final String name;
  final String phone;
  final String password;
  final DateTime updateAt;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.updateAt,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
      updateAt: DateTime.parse(json['update_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
      'update_at': updateAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

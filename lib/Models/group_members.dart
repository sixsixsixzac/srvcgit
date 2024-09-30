class GroupMembersModel {
  final int id;
  final String name;
  final String phone;
  final String level;

  GroupMembersModel(this.level,
      {required this.id, required this.name, required this.phone});

  factory GroupMembersModel.fromJson(Map<String, dynamic> json) {
    return GroupMembersModel(
      json['level'],
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  @override
  String toString() {
    return 'GroupMembersModel{id: $id, name: $name, phone: $phone, level: $level}';
  }
}

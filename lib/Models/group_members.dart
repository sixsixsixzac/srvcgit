class GroupMembersModel {
  final int id;
  final String name;
  final String profile;
  final String phone;
  final String level;

  GroupMembersModel({
    required this.id,
    required this.name,
    required this.profile,
    required this.phone,
    required this.level,
  });

  factory GroupMembersModel.fromJson(Map<String, dynamic> json) {
    return GroupMembersModel(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
      phone: json['phone'],
      level: json['level'],
    );
  }

  @override
  String toString() {
    return 'GroupMembersModel{id: $id, name: $name, phone: $phone, level: $level, profile : $profile}';
  }
}

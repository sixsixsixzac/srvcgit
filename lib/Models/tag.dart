class Tag {
  final int id;
  final String name;
  final String status;

  Tag({required this.id, required this.name, required this.status});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
  @override
  String toString() {
    return 'Tag{id: $id, name: $name, status: $status}';
  }
}

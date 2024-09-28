class VideoModel {
  final int id;
  final String thumbnail;
  final String title;
  final String? desc; // Optional field
  final String src;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  VideoModel({
    required this.id,
    required this.thumbnail,
    required this.title,
    this.desc,
    required this.src,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return VideoModel(
      id: json['id'],
      thumbnail: json['thumbnail'],
      title: json['title'],
      desc: json['desc'] ?? "",
      src: json['src'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: json['status'] ?? "on",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'title': title,
      'desc': desc,
      'src': src,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Video{id: $id, thumbnail: $thumbnail, title: $title, desc: $desc, src: $src, createdAt: $createdAt, updatedAt: $updatedAt, status: $status}';
  }
}

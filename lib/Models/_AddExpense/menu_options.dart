class MenuItems {
  final MenuIcons menuIcons;
  final Texts text;

  MenuItems({required this.menuIcons, required this.text});

  factory MenuItems.fromJson(Map<String, dynamic> json) {
    return MenuItems (
      menuIcons: MenuIcons.fromJson(json['menuIcons']),
      text: Texts.fromJson(json['text']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuIcons' : menuIcons.toJson(),
      'text' : text.toJson()
    };
  }
  
}

class MenuIcons {
  final String path;
  final double height;
  final double width;

  MenuIcons({required this.path, required this.height, required this.width});

  factory MenuIcons.fromJson(Map<String, dynamic> json) {
    return MenuIcons (
      path: json['path'],
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path' : path,
      'height' : height,
      'width' : width
    };
  }
}

class Texts {
  final String th;
  final String en;

  Texts({required this.th, required this.en});

  factory Texts.fromJson(Map<String, dynamic> json) {
    return Texts(
      th: json['TH'],
      en: json['EN']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'th': th,
      'en': en
    };
  }
}
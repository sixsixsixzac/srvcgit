class Numpad {
  static List<Map<String, dynamic>> numpadKeys = [
    {'flex': 1, 'key': '7', 'type': 'number'},
    {'flex': 1, 'key': '8', 'type': 'number'},
    {'flex': 1, 'key': '9', 'type': 'number'},
    {'flex': 1, 'key': '4', 'type': 'number'},
    {'flex': 1, 'key': '5', 'type': 'number'},
    {'flex': 1, 'key': '6', 'type': 'number'},
    {'flex': 1, 'key': '1', 'type': 'number'},
    {'flex': 1, 'key': '2', 'type': 'number'},
    {'flex': 1, 'key': '3', 'type': 'number'},
    {'flex': 1, 'key': '.', 'type': 'number'},
    {'flex': 1, 'key': '0', 'type': 'number'},
    {'flex': 1, 'key': '<-', 'type': 'functional', 'ontap': () => Numpad().erasePress()}
  ];

  void erasePress() {

  }
}
class Numpad {
  static String display = '';
  static List<Map<String, dynamic>> numpadKeys = [
    {'flex': 1, 'key': '7', 'type': 'number', 'ontap': () => Numpad().keyPress('7')},
    {'flex': 1, 'key': '8', 'type': 'number', 'ontap': () => Numpad().keyPress('8')},
    {'flex': 1, 'key': '9', 'type': 'number', 'ontap': () => Numpad().keyPress('9')},
    {'flex': 1, 'key': '4', 'type': 'number', 'ontap': () => Numpad().keyPress('4')},
    {'flex': 1, 'key': '5', 'type': 'number', 'ontap': () => Numpad().keyPress('5')},
    {'flex': 1, 'key': '6', 'type': 'number', 'ontap': () => Numpad().keyPress('6')},
    {'flex': 1, 'key': '1', 'type': 'number', 'ontap': () => Numpad().keyPress('1')},
    {'flex': 1, 'key': '2', 'type': 'number', 'ontap': () => Numpad().keyPress('2')},
    {'flex': 1, 'key': '3', 'type': 'number', 'ontap': () => Numpad().keyPress('3')},
    {'flex': 1, 'key': '.', 'type': 'number', 'ontap': () => Numpad().keyPress('.')},
    {'flex': 1, 'key': '0', 'type': 'number', 'ontap': () => Numpad().keyPress('0')},
    {'flex': 1, 'key': '<-', 'type': 'functional', 'ontap': () => Numpad().erasePress()}
  ];

  void keyPress(String text) {
    display += text;
  }

  void erasePress() {
    display.substring(0, display.length - 1);
  }

}
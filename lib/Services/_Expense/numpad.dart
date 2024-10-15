import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Numpad {
  static String value = "";
  static List<Map<String, dynamic>> numpadKeys = [
    {'flex': 1, 'key': Text('1'), 'type': 'number', 'ontap': () => Numpad().keyPress('1')},
    {'flex': 1, 'key': Text('2'), 'type': 'number', 'ontap': () => Numpad().keyPress('2')},
    {'flex': 1, 'key': Text('3'), 'type': 'number', 'ontap': () => Numpad().keyPress('3')},
    {'flex': 1, 'key': Text('4'), 'type': 'number', 'ontap': () => Numpad().keyPress('4')},
    {'flex': 1, 'key': Text('5'), 'type': 'number', 'ontap': () => Numpad().keyPress('5')},
    {'flex': 1, 'key': Text('6'), 'type': 'number', 'ontap': () => Numpad().keyPress('6')},
    {'flex': 1, 'key': Text('7'), 'type': 'number', 'ontap': () => Numpad().keyPress('7')},
    {'flex': 1, 'key': Text('8'), 'type': 'number', 'ontap': () => Numpad().keyPress('8')},
    {'flex': 1, 'key': Text('9'), 'type': 'number', 'ontap': () => Numpad().keyPress('9')},
    {'flex': 1, 'key': Text('.'), 'type': 'number', 'ontap': () => Numpad().keyPress('.')},
    {'flex': 1, 'key': Text('0'), 'type': 'number', 'ontap': () => Numpad().keyPress('0')},
    {'flex': 1, 'key': Icon(FontAwesomeIcons.backspace), 'type': 'functional', 'ontap': () => Numpad().erasePress()}
  ];

  void erasePress() {
    if(value.isEmpty) return;
    value = value.substring(0, value.length - 1);
  }

  void keyPress(String key) {
    print(key);
    if(value.length == 1 && value[0] == '0' && key == '0') return;
    if(key == '.' && value.isEmpty) return;
    if(key == '.' && value[value.length-1] == '.') return;

    int maximum = 12;
    int demical = value.indexOf('.');
    if(demical != -1) {
      maximum = 15;
      if(value.length >= demical + 1 + 2) return;
      if(value.length >= maximum) return;
      value += key;
    } else {
      if(value.length >= maximum && key != '.') return;
      value += key;
    }
    
  }
}
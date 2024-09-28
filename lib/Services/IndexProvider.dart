import 'package:flutter/material.dart';

class IndexProvider with ChangeNotifier {
  int _currentIndex = 2;

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}

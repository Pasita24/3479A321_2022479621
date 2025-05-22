import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  int _counter = 0;

  String _userName = "Invitado";
  bool _canReset = true;

  int get counter => _counter;
  String get userName => _userName;
  bool get canReset => _canReset;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }

  void reset() {
    if (_canReset) {
      _counter = 0;
      notifyListeners();
    }
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setCanReset(bool value) {
    _canReset = value;
    notifyListeners();
  }
}

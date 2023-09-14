import 'package:flutter/material.dart';

class ChangeScreens extends ChangeNotifier {
  late int selectedIndex = 0;

  int changeScreen(int index) {
    selectedIndex = index;
    notifyListeners();
    return selectedIndex;
  }
}

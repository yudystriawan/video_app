import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int currentIndex = 0;
  bool showBottomNav = true;

  bool get isBottomNavShowed => showBottomNav == true;

  void indexChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void toogleBottomNav() {
    showBottomNav = !showBottomNav;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../localization/app_strings.dart';

class GlobalState extends ChangeNotifier {
  AppLang _currentLang = AppLang.en;

  AppLang get currentLang => _currentLang;

  AppStrings get strings => kStrings[_currentLang] ?? kStrings[AppLang.en]!;

  void setLang(AppLang lang) {
    if (_currentLang == lang) return;
    _currentLang = lang;
    notifyListeners();
  }
}

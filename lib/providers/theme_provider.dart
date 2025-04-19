import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_share/constants.dart';
import 'package:wall_share/themes/app_themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _selectedTheme;
  bool _isDarkMode;

  // constructor
  ThemeProvider(this._isDarkMode)
    : _selectedTheme = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;

  // getter
  ThemeData get getTheme => _selectedTheme;

  bool get getIsDarkMode => _isDarkMode;

  // toggle theme
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _selectedTheme = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();

    // save theme to shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(Constants.isDarkMode, _isDarkMode);
  }

  // load theme from shared preferences
  Future<void> loadTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _isDarkMode = preferences.getBool(Constants.isDarkMode) ?? false;
    _selectedTheme = _isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }
}

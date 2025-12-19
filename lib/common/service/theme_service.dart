import 'package:flutter/material.dart';
import 'package:wal/global.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeService() {
    _loadTheme();
  }
  
  ThemeMode get themeMode => _themeMode;
  
  Future<void> _loadTheme() async {
    final themeString = Global.storageService.getString('theme_mode');
    if (themeString != null) {
      switch (themeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    }
    notifyListeners();
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
        modeString = 'system';
        break;
    }
    await Global.storageService.setString('theme_mode', modeString);
    notifyListeners();
  }
  
  ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF3375BB),
        secondary: Color(0xFF3375BB),
        surface: Color(0xFFFDFDFD),
        background: Color(0xFFFFFFFF),
        error: Color(0xFFB00020),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF000000),
        onBackground: Color(0xFF000000),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Color(0xFF000000)),
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        titleTextStyle: TextStyle(
          color: Color(0xFF000000),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFFF8F8F8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
    );
  }
  
  ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3375BB),
        secondary: Color(0xFF3375BB),
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF0F0F0F),
        error: Color(0xFFCF6679),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFFFFFFFF),
        onBackground: Color(0xFFFFFFFF),
        onError: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        elevation: 0,
        backgroundColor: Color(0xFF0F0F0F),
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A2A2A),
        thickness: 1,
      ),
    );
  }
  
  ThemeMode getEffectiveThemeMode(BuildContext? context) {
    if (_themeMode == ThemeMode.system && context != null) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    return _themeMode;
  }
}


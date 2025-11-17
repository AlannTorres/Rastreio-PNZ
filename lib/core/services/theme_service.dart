import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ========================================
/// THEME SERVICE - Serviço de Gerenciamento de Tema
class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// ========================================
  /// CONSTRUTOR
  ThemeService() {
    _loadThemeMode();
  }

  /// ========================================
  /// CARREGAR TEMA SALVO
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(_themeKey) ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar tema: $e');
    }
  }

  /// ========================================
  /// ALTERNAR TEMA
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    await _saveThemeMode();
    notifyListeners();
  }

  /// ========================================
  /// DEFINIR TEMA
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    await _saveThemeMode();
    notifyListeners();
  }

  /// ========================================
  /// SALVAR TEMA
  Future<void> _saveThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _themeMode == ThemeMode.dark);
    } catch (e) {
      print('Erro ao salvar tema: $e');
    }
  }
}

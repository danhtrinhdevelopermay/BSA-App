import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../services/localization_service.dart';

// App Provider for general app state management
class AppProvider with ChangeNotifier {
  String _currentLanguage = AppConstants.vietnamese;
  bool _isDarkMode = true;
  bool _isInitialized = false;
  int _selectedNavIndex = 0;
  bool _isLoading = false;
  String? _error;

  String get currentLanguage => _currentLanguage;
  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;
  int get selectedNavIndex => _selectedNavIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize app settings
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load language preference
      _currentLanguage = prefs.getString(AppConstants.languageKey) ?? AppConstants.vietnamese;
      await LocalizationService.setLanguage(_currentLanguage);
      
      // Load theme preference
      _isDarkMode = prefs.getBool(AppConstants.themeKey) ?? true;
      
      _isInitialized = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change language
  Future<void> changeLanguage(String language) async {
    if (_currentLanguage == language) return;
    
    _currentLanguage = language;
    await LocalizationService.setLanguage(language);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.languageKey, language);
    
    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.themeKey, _isDarkMode);
    
    notifyListeners();
  }

  // Set selected navigation index
  void setSelectedNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error
  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get localized string
  String t(String key, {String? fallback}) {
    return LocalizationService.translate(key, fallback: fallback);
  }

  // Get current locale
  Locale get locale => LocalizationService.locale;

  // Get supported locales
  List<Locale> get supportedLocales => LocalizationService.supportedLocales;
}
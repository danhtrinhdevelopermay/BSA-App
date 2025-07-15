import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/localization_service.dart';

// Auth Provider for user authentication management
class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize auth state
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.userTokenKey);
      
      if (token != null) {
        // Try to get current user
        _user = await ApiService.getCurrentUser();
        _isAuthenticated = true;
        _error = null;
      }
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _user = null;
      // Clear invalid token
      await _clearAuthData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await ApiService.login(email, password);
      _isAuthenticated = true;
      _error = null;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _user = null;
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register user
  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await ApiService.register(username, email, password);
      _isAuthenticated = true;
      _error = null;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      _user = null;
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.logout();
      await _clearAuthData();
      
      _user = null;
      _isAuthenticated = false;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await ApiService.updateUser(updates);
      _error = null;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear authentication data
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    await prefs.remove(AppConstants.userIdKey);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get user statistics
  Map<String, dynamic> getUserStats() {
    if (_user == null) return {};
    
    return {
      'level': _user!.level,
      'xp': _user!.xp,
      'xpToNextLevel': _calculateXpToNextLevel(_user!.level, _user!.xp),
      'progressToNextLevel': _calculateProgressToNextLevel(_user!.level, _user!.xp),
    };
  }

  // Calculate XP needed for next level
  int _calculateXpToNextLevel(int level, int currentXp) {
    final xpForNextLevel = level * 1000; // 1000 XP per level
    return xpForNextLevel - currentXp;
  }

  // Calculate progress to next level (0.0 to 1.0)
  double _calculateProgressToNextLevel(int level, int currentXp) {
    final xpForCurrentLevel = (level - 1) * 1000;
    final xpForNextLevel = level * 1000;
    final xpInCurrentLevel = currentXp - xpForCurrentLevel;
    final xpNeededForLevel = xpForNextLevel - xpForCurrentLevel;
    
    return xpInCurrentLevel / xpNeededForLevel;
  }
}
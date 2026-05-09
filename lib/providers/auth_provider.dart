import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepository();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Keys untuk SharedPreferences
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyNamaBisnis = 'nama_bisnis';
  static const String _keyIsLoggedIn = 'is_logged_in';
  
  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  
  // Load user from database by ID (untuk restore session)
  Future<UserModel?> loadUserFromId(int userId) async {
    try {
      final user = await _userRepository.getUserById(userId);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        debugPrint('User loaded from ID: ${user.username}');
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('Error loading user from ID: $e');
      return null;
    }
  }
  
  // Cek session saat aplikasi dimulai
  Future<bool> checkSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      
      if (isLoggedIn) {
        final userId = prefs.getInt(_keyUserId);
        if (userId != null) {
          final user = await loadUserFromId(userId);
          return user != null;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error checking session: $e');
      return false;
    }
  }
  
  // Login
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _userRepository.login(username, password);
      
      if (user != null) {
        _currentUser = user;
        
        // Simpan session ke SharedPreferences
        await _saveSession(user);
        
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Username atau password salah';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _setLoading(false);
      return false;
    }
  }
  
  // Register
  Future<bool> register(UserModel user) async {
    _setLoading(true);
    _clearError();
    
    try {
      final userId = await _userRepository.registerUser(user);
      
      if (userId > 0) {
        // Auto login setelah register
        return await login(user.username, user.password);
      } else {
        _errorMessage = 'Gagal mendaftar';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _setLoading(false);
      return false;
    }
  }
  
  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _clearError();
    
    // Hapus session dari SharedPreferences
    await _clearSession();
    
    notifyListeners();
    debugPrint('User logged out');
  }
  
  // Simpan session ke SharedPreferences
  Future<void> _saveSession(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyUserId, user.id!);
      await prefs.setString(_keyUsername, user.username);
      await prefs.setString(_keyNamaBisnis, user.namaBisnis);
      await prefs.setBool(_keyIsLoggedIn, true);
      debugPrint('Session saved for user: ${user.username}');
    } catch (e) {
      debugPrint('Error saving session: $e');
    }
  }
  
  // Hapus session dari SharedPreferences
  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUsername);
      await prefs.remove(_keyNamaBisnis);
      await prefs.setBool(_keyIsLoggedIn, false);
      debugPrint('Session cleared');
    } catch (e) {
      debugPrint('Error clearing session: $e');
    }
  }
  
  // Update profile
  Future<bool> updateProfile(UserModel updatedUser) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _userRepository.updateUser(updatedUser);
      
      if (success) {
        _currentUser = updatedUser;
        await _saveSession(updatedUser);
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Gagal update profile';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
      _setLoading(false);
      return false;
    }
  }
  
  // Update password
  Future<bool> updatePassword(int userId, String newPassword) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _userRepository.updatePassword(userId, newPassword);
      _setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = 'Gagal update password: $e';
      _setLoading(false);
      return false;
    }
  }
  
  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
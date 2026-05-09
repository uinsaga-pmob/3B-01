import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Register
  Future<int> registerUser(UserModel user) async {
    try {
      final db = await _dbHelper.database;
      final data = user.toMap();
      data.remove('id');
      
      final existingUser = await getUserByUsername(user.username);
      if (existingUser != null) {
        throw Exception('Username sudah digunakan');
      }
      
      final id = await db.insert('user', data);
      return id;
    } catch (e) {
      throw Exception('Gagal register: $e');
    }
  }

  // Login user
  Future<UserModel?> login(String username, String password) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );
      
      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }

  // Get user by username
  Future<UserModel?> getUserByUsername(String username) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'user',
        where: 'username = ?',
        whereArgs: [username],
      );
      
      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil user: $e');
    }
  }

  // Get user by id
  Future<UserModel?> getUserById(int id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'user',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil user: $e');
    }
  }

  // Update user profile
  Future<bool> updateUser(UserModel user) async {
    try {
      final db = await _dbHelper.database;
      final data = user.toMap();
      
      final rowsAffected = await db.update(
        'user',
        data,
        where: 'id = ?',
        whereArgs: [user.id],
      );
      
      return rowsAffected > 0;
    } catch (e) {
      throw Exception('Gagal update user: $e');
    }
  }

  // Update password
  Future<bool> updatePassword(int userId, String newPassword) async {
    try {
      final db = await _dbHelper.database;
      final rowsAffected = await db.update(
        'user',
        {'password': newPassword, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [userId],
      );
      
      return rowsAffected > 0;
    } catch (e) {
      throw Exception('Gagal update password: $e');
    }
  }

  // Delete user
  Future<bool> deleteUser(int id) async {
    try {
      final db = await _dbHelper.database;
      final rowsAffected = await db.delete(
        'user',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      return rowsAffected > 0;
    } catch (e) {
      throw Exception('Gagal hapus user: $e');
    }
  }
}
// lib/repositories/user_repository.dart
import '../database/database_helper.dart';
import '../models/user_model.dart';

/// Repository untuk operasi CRUD data user
class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Menyimpan user baru (insert)
  Future<int> saveUser(User user) async {
    final db = await _dbHelper.database;
    return await db.insert('users', user.toMap());
  }

  /// Update user
  Future<int> updateUser(User user) async {
    final db = await _dbHelper.database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Mendapatkan user (hanya 1 user karena single user)
  Future<User?> getUser() async {
    final db = await _dbHelper.database;
    final result = await db.query('users', limit: 1);
    
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  /// Cek apakah user sudah ada
  Future<bool> isUserExists() async {
    final user = await getUser();
    return user != null;
  }

  /// Hapus user (untuk reset)
  Future<int> deleteUser() async {
    final db = await _dbHelper.database;
    return await db.delete('users');
  }
}
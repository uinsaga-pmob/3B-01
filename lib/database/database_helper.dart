import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  
  static const int _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'umkm_digital_helper.db');
      
      debugPrint('Database path: $path');
      
      Database db = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
      );
      
      debugPrint('Database opened successfully');
      await _verifyTables(db);
      
      return db;
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    debugPrint('Foreign key constraints enabled');
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('Creating database tables for version $version');    
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        nama_bisnis TEXT NOT NULL,
        gambar_profil TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        updated_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    debugPrint('Table "user" created');
  }

  Future<void> _verifyTables(Database db) async {
    try {
      List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      );
      
      debugPrint('Existing tables: ${tables.map((t) => t['name']).join(', ')}');
      
      if (tables.any((t) => t['name'] == 'user')) {
        int count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM user')
        ) ?? 0;
        debugPrint('Table "user" exists with $count rows');
      } else {
        debugPrint('Warning: Table "user" not found!');
      }
    } catch (e) {
      debugPrint('Error verifying tables: $e');
    }
  }

  // METHOD CRUD DASAR

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    data['created_at'] = now;
    data['updated_at'] = now;
    return await db.insert(table, data);
  }

  Future<int> update(String table, Map<String, dynamic> data, int id) async {
    final db = await database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAll(String table) async {
    final db = await database;
    return await db.query(table, orderBy: 'id DESC');
  }

  Future<Map<String, dynamic>?> getById(String table, int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? args]) async {
    final db = await database;
    return await db.rawQuery(sql, args ?? []);
  }

  Future<int> rawInsert(String sql, [List<dynamic>? args]) async {
    final db = await database;
    return await db.rawInsert(sql, args ?? []);
  }

  Future<void> batch(List<Function(Batch batch)> operations) async {
    final db = await database;
    Batch batch = db.batch();
    for (var op in operations) {
      op(batch);
    }
    await batch.commit();
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    debugPrint('Database connection closed');
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('user');
    debugPrint('All data cleared from database');
  }

  /// Mengecek apakah sudah ada user di database
  Future<bool> hasUser() async {
    final db = await database;
    final result = await db.query('user', limit: 1);
    return result.isNotEmpty;
  }

  /// Mendapatkan jumlah user di database
  Future<int> getUserCount() async {
    final db = await database;
    final result = await db.query('user');
    return result.length;
  }

  /// Mengambil satu-satunya user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final users = await getAll('user');
    return users.isNotEmpty ? users.first : null;
  }
}
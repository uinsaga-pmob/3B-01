// lib/repositories/supplier_repository.dart
import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/supplier_model.dart';

/// Repository untuk operasi CRUD data supplier
class SupplierRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Mendapatkan semua supplier
  Future<List<Supplier>> getAllSuppliers() async {
    try {
      debugPrint('SupplierRepository: Getting all suppliers');
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('suppliers');
      debugPrint('SupplierRepository: Found ${maps.length} suppliers');
      return maps.map((x) => Supplier.fromMap(x)).toList();
    } catch (e, stackTrace) {
      debugPrint('SupplierRepository Error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Mendapatkan supplier berdasarkan ID
  Future<Supplier?> getSupplierById(int id) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'suppliers',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps.isNotEmpty) {
        return Supplier.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting supplier by id: $e');
      rethrow;
    }
  }

  /// Menambahkan supplier baru
  Future<int> addSupplier(Supplier supplier) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert('suppliers', supplier.toMap());
    } catch (e) {
      debugPrint('Error adding supplier: $e');
      rethrow;
    }
  }

  /// Update supplier
  Future<int> updateSupplier(Supplier supplier) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(
        'suppliers',
        supplier.toMap(),
        where: 'id = ?',
        whereArgs: [supplier.id],
      );
    } catch (e) {
      debugPrint('Error updating supplier: $e');
      rethrow;
    }
  }

  /// Hapus supplier (dengan pengecekan relasi produk)
  Future<int> deleteSupplier(int id) async {
    try {
      final db = await _dbHelper.database;
      
      // Cek apakah supplier masih memiliki produk
      final products = await db.query(
        'products',
        where: 'supplier_id = ?',
        whereArgs: [id],
      );
      
      if (products.isNotEmpty) {
        throw Exception('Tidak bisa menghapus supplier yang masih memiliki produk (${products.length} produk)');
      }
      
      final result = await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
      debugPrint('Delete supplier id $id result: $result rows affected');
      
      return result;
    } catch (e) {
      debugPrint('Error deleting supplier: $e');
      rethrow;
    }
  }

  /// Mendapatkan supplier berdasarkan keyword alamat
  Future<List<Supplier>> getSuppliersByAddress(String addressKeyword) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'suppliers',
        where: 'address LIKE ?',
        whereArgs: ['%$addressKeyword%'],
      );
      return maps.map((x) => Supplier.fromMap(x)).toList();
    } catch (e) {
      debugPrint('Error getting suppliers by address: $e');
      rethrow;
    }
  }
}
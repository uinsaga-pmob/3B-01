// lib/repositories/stock_repository.dart
import '../database/database_helper.dart';
import '../models/stock_history_model.dart';

/// Repository untuk operasi riwayat stok
class StockRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Menambahkan pergerakan stok (dengan referensi transaksi opsional)
  Future<int> addStockMovement(StockHistory movement) async {
    final db = await _dbHelper.database;
    return await db.insert('stock_history', movement.toMap());
  }

  /// Bulk insert multiple pergerakan stok
  Future<void> addMultipleStockMovements(List<StockHistory> movements) async {
    final db = await _dbHelper.database;
    await db.transaction((txn) async {
      for (var movement in movements) {
        await txn.insert('stock_history', movement.toMap());
      }
    });
  }

  /// Mendapatkan semua riwayat stok dengan nama produk
  Future<List<StockHistory>> getAllStockHistory() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT stock_history.*, products.name AS product_name 
      FROM stock_history 
      JOIN products ON stock_history.product_id = products.id
      ORDER BY stock_history.id DESC
    ''');
    return maps.map((x) => StockHistory.fromMap(x)).toList();
  }

  /// Mendapatkan riwayat stok berdasarkan ID produk
  Future<List<StockHistory>> getStockHistoryByProduct(int productId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT stock_history.*, products.name AS product_name 
      FROM stock_history 
      JOIN products ON stock_history.product_id = products.id
      WHERE stock_history.product_id = ?
      ORDER BY stock_history.id DESC
    ''', [productId]);
    return maps.map((x) => StockHistory.fromMap(x)).toList();
  }

  /// Mendapatkan riwayat stok berdasarkan referensi transaksi
  Future<List<StockHistory>> getStockHistoryByTransaction(int transactionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT stock_history.*, products.name AS product_name 
      FROM stock_history 
      JOIN products ON stock_history.product_id = products.id
      WHERE stock_history.reference_id = ? AND stock_history.reference_type = 'transaction'
      ORDER BY stock_history.id DESC
    ''', [transactionId]);
    return maps.map((x) => StockHistory.fromMap(x)).toList();
  }

  /// Mendapatkan total stok masuk hari ini
  Future<int> getStockInToday() async {
    final db = await _dbHelper.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(quantity), 0) as total 
      FROM stock_history 
      WHERE type = 'Masuk' AND date LIKE ?
    ''', ['$today%']);
    return result.first['total'] as int;
  }

  /// Mendapatkan total stok keluar hari ini
  Future<int> getStockOutToday() async {
    final db = await _dbHelper.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(quantity), 0) as total 
      FROM stock_history 
      WHERE type = 'Keluar' AND date LIKE ?
    ''', ['$today%']);
    return result.first['total'] as int;
  }

  /// Mendapatkan riwayat stok berdasarkan rentang tanggal
  Future<List<StockHistory>> getStockHistoryByDateRange(
    String startDate, 
    String endDate
  ) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT stock_history.*, products.name AS product_name 
      FROM stock_history 
      JOIN products ON stock_history.product_id = products.id
      WHERE date BETWEEN ? AND ?
      ORDER BY stock_history.id DESC
    ''', [startDate, endDate]);
    return maps.map((x) => StockHistory.fromMap(x)).toList();
  }

  /// Mendapatkan riwayat stok berdasarkan tipe (Masuk/Keluar/Rusak/Expired)
  Future<List<StockHistory>> getStockHistoryByType(String type) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT stock_history.*, products.name AS product_name 
      FROM stock_history 
      JOIN products ON stock_history.product_id = products.id
      WHERE stock_history.type = ?
      ORDER BY stock_history.id DESC
    ''', [type]);
    return maps.map((x) => StockHistory.fromMap(x)).toList();
  }

  /// Mendapatkan total kerugian dari barang rusak dan kadaluarsa
  Future<double> getTotalLossFromDamageAndExpired() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(sh.quantity * p.cost_price) as total_loss
      FROM stock_history sh
      JOIN products p ON sh.product_id = p.id
      WHERE sh.type IN ('Rusak', 'Expired')
    ''');
    return (result.first['total_loss'] ?? 0) as double;
  }

  /// Hapus riwayat stok (untuk cleanup)
  Future<int> deleteStockHistory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('stock_history', where: 'id = ?', whereArgs: [id]);
  }
}
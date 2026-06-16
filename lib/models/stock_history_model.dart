// lib/models/stock_history_model.dart
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

/// Model untuk riwayat perubahan stok produk
class StockHistory {
  final int? id;
  final int productId;
  final String productName;
  final String type; // 'Masuk', 'Keluar', 'Rusak', 'Expired'
  final int quantity;
  final String date;
  final int? referenceId; // ID dari transaksi (jika berasal dari jual/beli)
  final String? referenceType; // 'transaction' atau 'adjustment'
  final String notes;
  final String? createdBy;

  StockHistory({
    this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    required this.date,
    this.referenceId,
    this.referenceType,
    required this.notes,
    this.createdBy,
  });

  /// Konversi ke Map untuk penyimpanan database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'type': type,
      'quantity': quantity,
      'date': date,
      'reference_id': referenceId,
      'reference_type': referenceType,
      'notes': notes,
      'created_by': createdBy,
    };
  }

  /// Factory untuk membuat StockHistory dari Map database
  factory StockHistory.fromMap(Map<String, dynamic> map) {
    return StockHistory(
      id: map['id'],
      productId: map['product_id'],
      productName: map['product_name'] ?? 'Produk Tidak Dikenal',
      type: map['type'],
      quantity: map['quantity'],
      date: map['date'],
      referenceId: map['reference_id'],
      referenceType: map['reference_type'],
      notes: map['notes'] ?? '',
      createdBy: map['created_by'],
    );
  }

  // ==================== HELPER PROPERTIES ====================
  
  /// Cek apakah dari transaksi
  bool get isFromTransaction => referenceId != null && referenceType == 'transaction';
  
  /// Cek apakah adjustment manual
  bool get isAdjustment => referenceType == 'adjustment';
  
  /// Mendapatkan IconData berdasarkan tipe
  IconData get typeIconData {
    switch (type) {
      case 'Masuk':
        return Icons.arrow_downward;
      case 'Keluar':
        return Icons.arrow_upward;
      case 'Rusak':
        return Icons.warning_amber_rounded;
      case 'Expired':
        return Icons.hourglass_empty;
      default:
        return Icons.inventory;
    }
  }
  
  /// Mendapatkan warna icon berdasarkan tipe
  Color get typeIconColor {
    switch (type) {
      case 'Masuk':
        return Colors.green;
      case 'Keluar':
        return Colors.blue;
      case 'Rusak':
        return Colors.orange;
      case 'Expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  /// Mendapatkan background color berdasarkan tipe
  Color get typeBackgroundColor {
    switch (type) {
      case 'Masuk':
        return AppColors.success;
      case 'Keluar':
        return AppColors.info;
      case 'Rusak':
        return AppColors.warning;
      case 'Expired':
        return AppColors.danger;
      default:
        return Colors.grey;
    }
  }
  
  /// Mendapatkan teks status berdasarkan tipe
  String get typeText {
    switch (type) {
      case 'Masuk':
        return 'Barang Masuk';
      case 'Keluar':
        return 'Barang Keluar';
      case 'Rusak':
        return 'Barang Rusak';
      case 'Expired':
        return 'Barang Kadaluarsa';
      default:
        return 'Tidak Diketahui';
    }
  }
  
  /// Mendapatkan string icon (untuk fallback)
  String get typeIconString {
    switch (type) {
      case 'Masuk':
        return '📥';
      case 'Keluar':
        return '📤';
      case 'Rusak':
        return '⚠️';
      case 'Expired':
        return '⏰';
      default:
        return '📦';
    }
  }
  
  /// Format quantity dengan tanda +/- 
  String get formattedQuantity {
    switch (type) {
      case 'Masuk':
        return '+$quantity';
      case 'Keluar':
        return '-$quantity';
      case 'Rusak':
        return '-$quantity';
      case 'Expired':
        return '-$quantity';
      default:
        return '$quantity';
    }
  }
  
  /// Mendapatkan warna quantity berdasarkan tipe
  Color get quantityColor {
    switch (type) {
      case 'Masuk':
        return Colors.green;
      case 'Keluar':
        return Colors.blue;
      case 'Rusak':
        return Colors.orange;
      case 'Expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
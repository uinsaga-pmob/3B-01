// lib/models/transaction_item_model.dart

/// Model untuk item detail transaksi
class TransactionItem {
  final int? id;
  final int transactionId;
  final int productId;
  final String? productName; // Hasil join dari query
  final String? productCode; // Hasil join dari query
  final int quantity;
  final double unitPrice;
  final double subtotal;

  TransactionItem({
    this.id,
    required this.transactionId,
    required this.productId,
    this.productName,
    this.productCode,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  /// Konversi ke Map untuk penyimpanan database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
    };
  }

  /// Factory untuk membuat TransactionItem dari Map database
  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'],
      transactionId: map['transaction_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      productCode: map['product_code'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      subtotal: map['subtotal'],
    );
  }

  // ==================== HELPER PROPERTIES ====================
  
  /// Format harga satuan ke mata uang Rupiah
  String get formattedUnitPrice => 'Rp ${unitPrice.toStringAsFixed(0)}';
  
  /// Format subtotal ke mata uang Rupiah
  String get formattedSubtotal => 'Rp ${subtotal.toStringAsFixed(0)}';
  
  /// Menghitung keuntungan per item (perlu cost price dari product)
  double calculateProfit(double costPrice) {
    return (unitPrice - costPrice) * quantity;
  }
}
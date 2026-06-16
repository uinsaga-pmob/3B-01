// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

/// Provider untuk manajemen data produk
class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepo = ProductRepository();

  // State variables
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Statistics
  int get totalProducts => _products.length;
  int get totalStock => _products.fold(0, (sum, item) => sum + item.stock);
  int get lowStockCount =>
      _products.where((item) => item.stock <= item.minStock).length;

  /// Total nilai inventory berdasarkan harga modal
  double get totalInventoryValueByCost {
    return _products.fold(
      0.0,
      (sum, item) => sum + (item.stock * item.costPrice),
    );
  }

  /// Total nilai inventory berdasarkan harga jual
  double get totalInventoryValueBySell {
    return _products.fold(
      0.0,
      (sum, item) => sum + (item.stock * item.sellPrice),
    );
  }

  /// Potensi keuntungan dari semua stok
  double get potentialProfit {
    return totalInventoryValueBySell - totalInventoryValueByCost;
  }

  /// Rata-rata margin keuntungan
  double get averageProfitMargin {
    if (totalInventoryValueByCost == 0) return 0;
    return (potentialProfit / totalInventoryValueByCost) * 100;
  }

  /// Safe notify listeners
  void _safeNotifyListeners() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
        notifyListeners();
      }
    });
  }

  /// Memuat semua produk dari database
  Future<void> loadProducts() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    _safeNotifyListeners();
    try {
      debugPrint('ProductProvider: Loading products...');
      _products = await _productRepo.getAllProducts();
      debugPrint('ProductProvider: Loaded ${_products.length} products');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('ProductProvider Error: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Refresh data produk
  Future<void> refreshProducts() async {
    _isLoading = true;
    _safeNotifyListeners();
    try {
      debugPrint('ProductProvider: Refreshing products...');
      _products = await _productRepo.getAllProducts();
      await _productRepo.debugPrintAllProducts();
      debugPrint('ProductProvider: Refreshed ${_products.length} products');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('ProductProvider Refresh Error: $e');
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Mendapatkan produk berdasarkan ID
  Product? getProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Menambahkan produk baru
  Future<bool> addProduct(Product product) async {
    if (_isLoading) return false;
    _isLoading = true;
    _safeNotifyListeners();

    try {
      final id = await _productRepo.addProduct(product);
      debugPrint('Product added with ID: $id');
      await refreshProducts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Add product error: $e');
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Menambahkan produk langsung (tanpa refresh)
  Future<int> addProductDirect(Product product) async {
    if (_isLoading) return 0;
    _isLoading = true;
    _safeNotifyListeners();
    try {
      final id = await _productRepo.addProduct(product);
      debugPrint('Product direct added with ID: $id');
      return id;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Add product direct error: $e');
      return 0;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Update produk
  Future<bool> updateProduct(Product product) async {
    if (_isLoading) return false;
    _isLoading = true;
    _safeNotifyListeners();
    try {
      await _productRepo.updateProduct(product);
      await refreshProducts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Update stok produk secara lokal (tanpa query database)
  void updateProductStockLocally(int productId, int newStock) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      final updatedProduct = _products[index].copyWith(stock: newStock);
      _products[index] = updatedProduct;
      _safeNotifyListeners();
    }
  }

  /// Hapus produk
  Future<bool> deleteProduct(int id) async {
    if (_isLoading) return false;
    _isLoading = true;
    _safeNotifyListeners();
    try {
      await _productRepo.deleteProduct(id);
      await refreshProducts();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      _safeNotifyListeners();
    }
  }

  /// Mendapatkan produk dengan stok rendah
  Future<List<Product>> getLowStockProducts() async {
    return await _productRepo.getLowStockProducts();
  }

  /// Reset provider (untuk logout)
  void reset() {
    _products = [];
    _isLoading = false;
    _errorMessage = null;
    _safeNotifyListeners();
  }
}

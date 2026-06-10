// lib/screens/produk/produk_detail_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/glass_card.dart';
import 'add_edit_product_screen.dart';
import 'adjust_stock_screen.dart'; // Halaman penyesuaian stok (akan dibuat)

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = false;
  Product? _product;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    if (productProvider.products.isEmpty) {
      await productProvider.loadProducts();
    }

    final product = productProvider.getProductById(widget.productId);
    if (mounted) {
      setState(() {
        _product = product;
      });
    }
  }

  Future<void> _refreshProduct() async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    await productProvider.refreshProducts();
    final product = productProvider.getProductById(widget.productId);
    if (mounted) {
      setState(() {
        _product = product;
      });
    }
  }

  Future<void> _editProduct() async {
    if (_product == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: _product),
      ),
    );

    if (result == true && mounted) {
      await _refreshProduct();
    }
  }

  Future<void> _adjustStock() async {
    if (_product == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdjustStockScreen(product: _product!),
      ),
    );

    if (result == true && mounted) {
      await _refreshProduct();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stok berhasil disesuaikan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteProduct() async {
    if (_product == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk"),
        content: Text(
          "Apakah Anda yakin ingin menghapus produk '${_product!.name}'?",
          style: GoogleFonts.plusJakartaSans(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final success = await productProvider.deleteProduct(_product!.id!);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produk berhasil dihapus'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus produk'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final product = _product!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLowStock = product.stock <= product.minStock;
    final hasImagePath =
        product.imagePath != null && product.imagePath!.isNotEmpty;

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: product.name,
            showBackButton: true,
            menuItems: [
              AppBarMenuItem(
                value: 'adjust',
                label: 'Penyesuaian Stok',
                icon: Icons.swap_horiz_rounded,
                iconColor: AppColors.accentLight,
                onTap: _adjustStock,
              ),
              AppBarMenuItem(
                value: 'edit',
                label: 'Edit Produk',
                icon: Icons.edit_rounded,
                iconColor: AppColors.warning,
                onTap: _editProduct,
              ),
              AppBarMenuItem(
                value: 'delete',
                label: 'Hapus Produk',
                icon: Icons.delete_rounded,
                iconColor: AppColors.danger,
                onTap: _deleteProduct,
              ),
            ],
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image Section
                        Center(
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              gradient: hasImagePath
                                  ? null
                                  : (isLowStock
                                        ? AppColors.dangerGradient
                                        : AppColors.emeraldGradient),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (isLowStock
                                              ? AppColors.danger
                                              : AppColors.accentLight)
                                          .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              image: hasImagePath
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(product.imagePath!),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: !hasImagePath
                                ? Center(
                                    child: Text(
                                      product.name
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 56,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Product Code & Category
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                title: "Kode Produk",
                                value: product.code,
                                icon: Icons.barcode_reader,
                                color: AppColors.info,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                title: "Kategori",
                                value: product.category,
                                icon: Icons.category_rounded,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Stock Status Card
                        GlassCard(
                          gradientColors: isLowStock
                              ? [AppColors.danger, const Color(0xFFB91C1C)]
                              : [AppColors.success, const Color(0xFF047857)],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStockMetric(
                                "Stok Saat Ini",
                                "${product.stock} Unit",
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              _buildStockMetric(
                                "Batas Minimum",
                                "${product.minStock} Unit",
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              _buildStockMetric(
                                "Status",
                                isLowStock ? "Kritis" : "Aman",
                                valueColor: isLowStock
                                    ? AppColors.danger
                                    : AppColors.success,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Price Card
                        GlassCard(
                          gradientColors: const [
                            Color(0xFF0F172A),
                            Color(0xFF1E293B),
                          ],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildPriceMetric(
                                "Harga Beli",
                                product.costPrice,
                                Icons.shopping_cart_rounded,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              _buildPriceMetric(
                                "Harga Jual",
                                product.sellPrice,
                                Icons.price_change_rounded,
                                isSellingPrice: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Informasi Tambahan (Deskripsi)
                        if (product.description != null &&
                            product.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            "Deskripsi Produk",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.primaryLight,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? Colors.white24 : Colors.black12,
                              ),
                            ),
                            child: Text(
                              product.description!,
                              style: GoogleFonts.plusJakartaSans(
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textMuted,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : AppColors.primaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockMetric(String title, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            color: valueColor ?? Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceMetric(
    String title,
    double price,
    IconData icon, {
    bool isSellingPrice = false,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppFormatters.toRupiah(price),
          style: GoogleFonts.plusJakartaSans(
            color: isSellingPrice ? AppColors.accentLight : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

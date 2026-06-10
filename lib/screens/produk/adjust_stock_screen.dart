// lib/screens/produk/adjust_stock_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/snackbar_services.dart';
import '../../core/constants/colors.dart';
import '../../models/product_model.dart';
import '../../providers/stock_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/app_bar.dart';

class AdjustStockScreen extends StatefulWidget {
  final Product product;

  const AdjustStockScreen({super.key, required this.product});

  @override
  State<AdjustStockScreen> createState() => _AdjustStockScreenState();
}

class _AdjustStockScreenState extends State<AdjustStockScreen> {
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedAction = 'Masuk';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _actionTypes = [
    {
      'name': 'Masuk',
      'color': Colors.green,
      'icon': Icons.add_shopping_cart_rounded,
    },
    {
      'name': 'Keluar',
      'color': Colors.red,
      'icon': Icons.remove_shopping_cart_rounded,
    },
    {
      'name': 'Rusak',
      'color': Colors.orange,
      'icon': Icons.warning_amber_rounded,
    },
    {
      'name': 'Expired',
      'color': Colors.purple,
      'icon': Icons.hourglass_empty_rounded,
    },
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _recordStockMovement() async {
    final quantity = int.tryParse(_quantityController.text.trim());

    if (quantity == null || quantity <= 0) {
      SnackbarService.error(
        context: context,
        message: 'Masukkan jumlah yang valid (minimal 1)',
      );
      return;
    }

    // Validasi untuk stok keluar/rusak/expired tidak boleh melebihi stok yang ada
    if (_selectedAction != 'Masuk' && quantity > widget.product.stock) {
      SnackbarService.error(
        context: context,
        message:
            'Jumlah melebihi stok yang tersedia (${widget.product.stock} unit)',
      );
      return;
    }

    setState(() => _isLoading = true);

    final stockProvider = Provider.of<StockProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    final success = await stockProvider.recordStockMovement(
      productId: widget.product.id!,
      type: _selectedAction,
      quantity: quantity,
      notes: _notesController.text.trim().isEmpty
          ? "Tidak ada catatan"
          : _notesController.text.trim(),
      createdBy: 'user',
    );

    if (context.mounted) {
      if (success) {
        await productProvider.refreshProducts();
        SnackbarService.success(
          context: context,
          message:
              'Stok berhasil disesuaikan ($_selectedAction $quantity unit)',
        );

        Navigator.pop(context, true);
      } else {
        SnackbarService.error(
          context: context,
          message: 'Gagal mencatat $_selectedAction stok',
        );
      }
    }

    if (context.mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: CustomAppBar(title: 'Penyesuaian Stok', showBackButton: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Produk
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: AppColors.emeraldGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              widget.product.name.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.primaryLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Kode: ${widget.product.code}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Stok saat ini: ${widget.product.stock} unit',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      widget.product.stock <=
                                          widget.product.minStock
                                      ? AppColors.danger
                                      : (isDark
                                            ? AppColors.accentDark
                                            : AppColors.accentLight),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Judul
                  Text(
                    'Pilih Jenis Penyesuaian',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action Type Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _actionTypes.map((action) {
                      final isSelected = _selectedAction == action['name'];
                      return FilterChip(
                        selected: isSelected,
                        label: Text(action['name']),
                        avatar: Icon(
                          action['icon'],
                          size: 18,
                          color: isSelected ? Colors.white : action['color'],
                        ),
                        backgroundColor: isDark
                            ? AppColors.cardDark
                            : Colors.white,
                        selectedColor: action['color'],
                        labelStyle: GoogleFonts.plusJakartaSans(
                          color: isSelected ? Colors.white : action['color'],
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (_) {
                          setState(() {
                            _selectedAction = action['name'];
                          });
                        },
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : action['color'].withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Form Jumlah
                  Text(
                    'Jumlah',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? Colors.white : AppColors.primaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: "Masukkan jumlah stok",
                      prefixIcon: const Icon(Icons.numbers_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.accentLight,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.cardDark : Colors.white,
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Form Catatan
                  Text(
                    'Catatan (Opsional)',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppColors.primaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? Colors.white : AppColors.primaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: "Tambahkan catatan untuk mutasi stok ini",
                      prefixIcon: const Icon(Icons.note_add_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.accentLight,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.cardDark : Colors.white,
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _recordStockMovement,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _actionTypes.firstWhere(
                          (a) => a['name'] == _selectedAction,
                        )['color'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "${_selectedAction.toUpperCase()} STOK",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

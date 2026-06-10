// lib/screens/transaksi/add_transaction.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../widgets/snackbar_services.dart';
import '../../core/constants/colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/supplier_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/stock_provider.dart';
import '../../models/transaction_item_model.dart';
import '../../models/product_model.dart';
import '../../models/supplier_model.dart';
import '../../widgets/app_bar.dart';

class AddTransactionScreen extends StatefulWidget {
  final String transactionType;

  const AddTransactionScreen({super.key, required this.transactionType});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _customerNameController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected data
  Supplier? _selectedSupplier;
  String _paymentMethod = 'Tunai';
  List<TransactionItem> _items = [];

  // Product selection
  Product? _selectedProduct;

  // Form untuk produk baru (hanya untuk PEMBELIAN)
  bool _isAddingNewProduct = false;
  final _newProductCodeController = TextEditingController();
  final _newProductNameController = TextEditingController();
  final _newProductCategoryController = TextEditingController();
  final _newProductQuantityController = TextEditingController();
  final _newProductPriceController = TextEditingController();
  final _newProductSellPriceController = TextEditingController();

  // Listeners untuk real-time button state
  final _quantityFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  // UI state
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isFormValid = false;
  bool _isNewProductFormValid = false;

  final List<String> _paymentMethods = [
    'Tunai',
    'Transfer Bank',
    'QRIS',
    'Kartu Kredit',
  ];

  // Map untuk menyimpan produk baru sementara
  final Map<int, Map<String, dynamic>> _pendingNewProducts = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _updateFormValidState() {
    setState(() {
      _isFormValid = _selectedProduct != null &&
          _newProductQuantityController.text.isNotEmpty &&
          _newProductPriceController.text.isNotEmpty;
    });
  }

  void _updateNewProductFormValid() {
    setState(() {
      _isNewProductFormValid =
          _newProductCodeController.text.isNotEmpty &&
          _newProductNameController.text.isNotEmpty &&
          _newProductCategoryController.text.isNotEmpty &&
          _newProductQuantityController.text.isNotEmpty &&
          _newProductPriceController.text.isNotEmpty &&
          _newProductSellPriceController.text.isNotEmpty;
    });
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    try {
      final isPurchase = widget.transactionType == 'Pembelian';

      if (isPurchase) {
        final supplierProvider = Provider.of<SupplierProvider>(
          context,
          listen: false,
        );
        if (supplierProvider.suppliers.isEmpty) {
          await supplierProvider.loadSuppliers();
        }
      }

      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      await productProvider.loadProducts();
    } catch (e) {
      debugPrint('❌ Error loading initial data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _notesController.dispose();
    _newProductCodeController.dispose();
    _newProductNameController.dispose();
    _newProductCategoryController.dispose();
    _newProductQuantityController.dispose();
    _newProductPriceController.dispose();
    _newProductSellPriceController.dispose();
    _quantityFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPurchase = widget.transactionType == 'Pembelian';
    final title = isPurchase ? 'Tambah Pembelian' : 'Tambah Penjualan';

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: CustomAppBar(title: title, showBackButton: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final products = Provider.of<ProductProvider>(context).products;
    final suppliers = Provider.of<SupplierProvider>(context).suppliers;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: title,
        showBackButton: true,
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              onPressed: _clearAllItems,
              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
            ),
        ],
      ),
      body: _isSubmitting
          ? _buildLoadingIndicator(isDark)
          : _buildForm(isDark, products, suppliers, isPurchase),
    );
  }

  Widget _buildLoadingIndicator(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? AppColors.accentDark : AppColors.accentLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Memproses transaksi...',
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? AppColors.textLight : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(
    bool isDark,
    List<Product> products,
    List<Supplier> suppliers,
    bool isPurchase,
  ) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(isDark, isPurchase),
            const SizedBox(height: 16),

            if (isPurchase && suppliers.isNotEmpty)
              _buildSupplierSection(isDark, suppliers),

            if (!isPurchase) _buildCustomerSection(isDark),

            const SizedBox(height: 16),

            _buildProductsSection(isDark, products, isPurchase),
            const SizedBox(height: 16),

            if (_items.isNotEmpty) ...[
              _buildSelectedItemsList(isDark),
              const SizedBox(height: 16),
            ],

            _buildPaymentSection(isDark),
            const SizedBox(height: 16),
            _buildNotesSection(isDark),
            const SizedBox(height: 24),
            _buildSubmitButton(isDark, isPurchase),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark, bool isPurchase) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.glassGradient
            : AppColors.premiumGradientLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isPurchase
                  ? Icons.shopping_cart_rounded
                  : Icons.attach_money_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPurchase
                      ? 'Pembelian dari Supplier'
                      : 'Penjualan ke Customer',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Isi semua informasi dengan benar',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: 20,
                color: isDark ? AppColors.accentDark : AppColors.accentLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Informasi Customer',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _customerNameController,
            decoration: _buildInputDecoration(
              isDark,
              'Nama Customer',
              Icons.person_outline_rounded,
            ),
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama customer harus diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierSection(bool isDark, List<Supplier> suppliers) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.business_rounded,
                size: 20,
                color: isDark ? AppColors.accentDark : AppColors.accentLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Informasi Supplier',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Supplier>(
            value: _selectedSupplier,
            decoration: InputDecoration(
              labelText: 'Pilih Supplier',
              prefixIcon: const Icon(Icons.store_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accentLight),
              ),
              filled: true,
              fillColor: isDark ? AppColors.cardDark : Colors.white,
            ),
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            items: suppliers.map((supplier) {
              return DropdownMenuItem(
                value: supplier,
                child: Text(supplier.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSupplier = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Supplier harus dipilih';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(
    bool isDark,
    List<Product> products,
    bool isPurchase,
  ) {
    final availableProducts = isPurchase
        ? products
        : products.where((p) => p.stock > 0).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory_rounded,
                size: 20,
                color: isDark ? AppColors.accentDark : AppColors.accentLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Tambah Produk',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryLight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (isPurchase && products.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: _buildRadioOption(
                    isDark: isDark,
                    title: 'Pilih produk yang sudah ada',
                    isSelected: !_isAddingNewProduct,
                    onTap: () {
                      setState(() {
                        _isAddingNewProduct = false;
                        _selectedProduct = null;
                        _isFormValid = false;
                        _clearNewProductForm();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRadioOption(
                    isDark: isDark,
                    title: 'Tambah produk baru',
                    isSelected: _isAddingNewProduct,
                    onTap: () {
                      setState(() {
                        _isAddingNewProduct = true;
                        _selectedProduct = null;
                        _isFormValid = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Dropdown produk yang sudah ada
          if (!_isAddingNewProduct || !isPurchase)
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
              isExpanded: true,
              menuMaxHeight: 350,
              selectedItemBuilder: (BuildContext context) {
                return availableProducts.map((product) {
                  final price = isPurchase
                      ? product.costPrice
                      : product.sellPrice;

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${product.name} • Stok: ${product.stock} • ${_formatRupiah(price)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        color: isDark ? Colors.white : AppColors.primaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList();
              },
              items: availableProducts.map((product) {
                final price = isPurchase
                    ? product.costPrice
                    : product.sellPrice;

                return DropdownMenuItem<Product>(
                  value: product,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Stok: ${product.stock} • ${_formatRupiah(price)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textLight
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                  if (value != null) {
                    final price = isPurchase ? value.costPrice : value.sellPrice;
                    _newProductPriceController.text = price.toString();
                  }
                  _updateFormValidState();
                });
              },
            ),

          // Form untuk produk yang sudah dipilih (VERTICAL)
          if (!_isAddingNewProduct && _selectedProduct != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isDark ? AppColors.accentDark : AppColors.accentLight)
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isDark ? AppColors.accentDark : AppColors.accentLight)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    isPurchase ? 'Detail Pembelian' : 'Detail Penjualan',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark
                          ? AppColors.accentDark
                          : AppColors.accentLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _newProductQuantityController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? Colors.white : AppColors.primaryLight,
                    ),
                    decoration: _buildInputDecoration(
                      isDark,
                      'Jumlah *',
                      Icons.numbers,
                    ),
                    onChanged: (_) => _updateFormValidState(),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _newProductPriceController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.plusJakartaSans(
                      color: isDark ? Colors.white : AppColors.primaryLight,
                    ),
                    decoration: _buildInputDecoration(
                      isDark,
                      'Harga Satuan *',
                      Icons.price_change,
                    ),
                    onChanged: (_) => _updateFormValidState(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isFormValid && !_isSubmitting
                          ? _addExistingProduct
                          : null,
                      icon: const Icon(Icons.add_rounded, color: Colors.white),
                      label: const Text('TAMBAHKAN KE DAFTAR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentLight,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Form tambah produk baru
          if (isPurchase && _isAddingNewProduct) ...[
            const SizedBox(height: 12),
            _buildNewProductForm(isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required bool isDark,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? AppColors.accentDark : AppColors.accentLight)
                      : (isDark ? Colors.white54 : Colors.black54),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.accentDark
                              : AppColors.accentLight,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: isDark ? Colors.white : AppColors.primaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewProductForm(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.accentDark : AppColors.accentLight)
            .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isDark ? AppColors.accentDark : AppColors.accentLight)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Form Produk Baru',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark ? AppColors.accentDark : AppColors.accentLight,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _newProductCodeController,
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            decoration: _buildInputDecoration(
              isDark,
              'Kode Produk *',
              Icons.qr_code,
            ),
            onChanged: (_) => _updateNewProductFormValid(),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newProductNameController,
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            decoration: _buildInputDecoration(
              isDark,
              'Nama Produk *',
              Icons.inventory_2,
            ),
            onChanged: (_) => _updateNewProductFormValid(),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newProductCategoryController,
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            decoration: _buildInputDecoration(
              isDark,
              'Kategori *',
              Icons.category,
            ),
            onChanged: (_) => _updateNewProductFormValid(),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newProductQuantityController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            decoration: _buildInputDecoration(
              isDark,
              'Jumlah *',
              Icons.numbers,
            ),
            onChanged: (_) => _updateNewProductFormValid(),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newProductPriceController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            decoration: _buildInputDecoration(
              isDark,
              'Harga Beli *',
              Icons.price_change,
            ),
            onChanged: (_) => _updateNewProductFormValid(),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _newProductSellPriceController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            decoration: _buildInputDecoration(
              isDark,
              'Harga Jual *',
              Icons.sell_rounded,
            ),
            onChanged: (_) => _updateNewProductFormValid(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isNewProductFormValid && !_isSubmitting
                  ? _addNewProduct
                  : null,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text('TAMBAHKAN PRODUK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentLight,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedItemsList(bool isDark) {
    final subtotal = _getTotalAmount();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_basket_rounded,
                size: 20,
                color: isDark ? AppColors.accentDark : AppColors.accentLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Daftar Produk (${_items.length})',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const Divider(height: 8),
            itemBuilder: (context, index) {
              final item = _items[index];
              return _buildListItem(isDark, item, index);
            },
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.accentDark : AppColors.accentLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal:',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.primaryLight,
                  ),
                ),
                Text(
                  _formatRupiah(subtotal),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.accentDark
                        : AppColors.accentLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(bool isDark, TransactionItem item, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDark ? AppColors.accentDark : AppColors.accentLight)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${item.quantity}',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.accentDark : AppColors.accentLight,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? 'Produk',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.primaryLight,
                  ),
                ),
                Text(
                  '${item.quantity} x ${_formatRupiah(item.unitPrice)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: isDark ? AppColors.textLight : AppColors.textMuted,
                  ),
                ),
                if (item.productCode != null)
                  Text(
                    'Kode: ${item.productCode}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: isDark ? AppColors.textLight : AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            _formatRupiah(item.subtotal),
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.accentDark : AppColors.accentLight,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _removeItem(index),
            icon: Icon(
              Icons.close_rounded,
              color: Colors.red.shade400,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment_rounded,
                size: 20,
                color: isDark ? AppColors.accentDark : AppColors.accentLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Detail Pembayaran',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _paymentMethod,
            decoration: InputDecoration(
              labelText: 'Metode Pembayaran',
              prefixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.accentLight),
              ),
              filled: true,
              fillColor: isDark ? AppColors.cardDark : Colors.white,
            ),
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
            items: _paymentMethods.map((method) {
              return DropdownMenuItem(value: method, child: Text(method));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _paymentMethod = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildCardDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_rounded,
                size: 20,
                color: isDark ? AppColors.accentDark : AppColors.accentLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Catatan (Opsional)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.primaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: _buildInputDecoration(
              isDark,
              'Tambahkan catatan...',
              Icons.edit_note,
            ),
            style: GoogleFonts.plusJakartaSans(
              color: isDark ? Colors.white : AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark, bool isPurchase) {
    final isEnabled =
        _items.isNotEmpty &&
        (isPurchase
            ? _selectedSupplier != null
            : _customerNameController.text.isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled && !_isSubmitting ? _submitTransaction : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isEnabled
              ? Colors.green.shade600
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          isPurchase ? 'SELESAIKAN PEMBELIAN' : 'SELESAIKAN PENJUALAN',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(
    bool isDark,
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.plusJakartaSans(
        color: isDark ? AppColors.textLight : AppColors.textMuted,
      ),
      prefixIcon: Icon(
        icon,
        size: 20,
        color: isDark ? AppColors.accentDark : AppColors.accentLight,
      ),
      filled: true,
      fillColor: isDark ? Colors.transparent : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  void _addNewProduct() {
    final quantity = int.tryParse(_newProductQuantityController.text);
    final unitPrice = double.tryParse(_newProductPriceController.text);
    final sellPrice = double.tryParse(_newProductSellPriceController.text);

    // Validasi lengkap
    if (quantity == null || unitPrice == null || sellPrice == null) {
      SnackbarService.warning(
        context: context,
        message: 'Semua field harus diisi dengan angka yang valid',
      );
      return;
    }

    if (quantity <= 0) {
      SnackbarService.warning(context: context, message: 'Jumlah harus lebih dari 0');
      return;
    }

    if (unitPrice <= 0) {
      SnackbarService.warning(context: context, message: 'Harga beli harus lebih dari 0');
      return;
    }

    if (sellPrice <= 0) {
      SnackbarService.warning(context: context, message: 'Harga jual harus lebih dari 0');
      return;
    }

    final productId = -DateTime.now().millisecondsSinceEpoch;
    final productName = _newProductNameController.text.trim();
    final productCode = _newProductCodeController.text.trim();
    final category = _newProductCategoryController.text.trim();

    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId,
    );

    setState(() {
      if (existingIndex != -1) {
        final existingItem = _items[existingIndex];
        final newQuantity = existingItem.quantity + quantity;
        final newSubtotal = newQuantity * existingItem.unitPrice;

        _items[existingIndex] = TransactionItem(
          id: existingItem.id,
          transactionId: existingItem.transactionId,
          productId: existingItem.productId,
          productName: existingItem.productName,
          productCode: existingItem.productCode,
          quantity: newQuantity,
          unitPrice: existingItem.unitPrice,
          subtotal: newSubtotal,
        );
      } else {
        _items.add(
          TransactionItem(
            id: 0,
            transactionId: 0,
            productId: productId,
            productName: productName,
            productCode: productCode,
            quantity: quantity,
            unitPrice: unitPrice,
            subtotal: quantity * unitPrice,
          ),
        );
      }

      _pendingNewProducts[productId] = {
        'code': productCode,
        'name': productName,
        'category': category,
        'costPrice': unitPrice,
        'sellPrice': sellPrice,
        'stock': quantity,
      };

      _clearNewProductForm();
      _isAddingNewProduct = false;
      
      SnackbarService.success(
        context: context,
        message: 'Produk baru berhasil ditambahkan ke daftar',
      );
    });
  }

  void _addExistingProduct() {
    final quantity = int.tryParse(_newProductQuantityController.text);
    final unitPrice = double.tryParse(_newProductPriceController.text);

    if (quantity == null || unitPrice == null) {
      SnackbarService.warning(
        context: context,
        message: 'Jumlah dan harga harus diisi dengan angka valid',
      );
      return;
    }

    if (quantity <= 0) {
      SnackbarService.warning(context: context, message: 'Jumlah harus lebih dari 0');
      return;
    }

    if (unitPrice <= 0) {
      SnackbarService.warning(context: context, message: 'Harga satuan harus lebih dari 0');
      return;
    }

    if (_selectedProduct == null) {
      SnackbarService.warning(context: context, message: 'Pilih produk terlebih dahulu');
      return;
    }

    final isPurchase = widget.transactionType == 'Pembelian';
    
    // 🔥 Validasi stok untuk penjualan
    if (!isPurchase && quantity > _selectedProduct!.stock) {
      SnackbarService.warning(
        context: context,
        message: 'Stok tidak mencukupi. Stok saat ini: ${_selectedProduct!.stock} unit',
      );
      return;
    }

    final productId = _selectedProduct!.id!;
    final productName = _selectedProduct!.name;
    final productCode = _selectedProduct!.code;

    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId,
    );

    setState(() {
      if (existingIndex != -1) {
        final existingItem = _items[existingIndex];
        final newQuantity = existingItem.quantity + quantity;
        final newSubtotal = newQuantity * existingItem.unitPrice;

        _items[existingIndex] = TransactionItem(
          id: existingItem.id,
          transactionId: existingItem.transactionId,
          productId: existingItem.productId,
          productName: existingItem.productName,
          productCode: existingItem.productCode,
          quantity: newQuantity,
          unitPrice: existingItem.unitPrice,
          subtotal: newSubtotal,
        );
      } else {
        _items.add(
          TransactionItem(
            id: 0,
            transactionId: 0,
            productId: productId,
            productName: productName,
            productCode: productCode,
            quantity: quantity,
            unitPrice: unitPrice,
            subtotal: quantity * unitPrice,
          ),
        );
      }

      _newProductQuantityController.clear();
      _newProductPriceController.clear();
      _selectedProduct = null;
      _isFormValid = false;
    });
  }

  void _removeItem(int index) {
    final item = _items[index];
    setState(() {
      _items.removeAt(index);
      if (item.productId < 0) {
        _pendingNewProducts.remove(item.productId);
      }
    });
  }

  void _clearAllItems() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua'),
        content: const Text('Apakah Anda yakin ingin menghapus semua item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _items.clear();
                _pendingNewProducts.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _clearNewProductForm() {
    _newProductCodeController.clear();
    _newProductNameController.clear();
    _newProductCategoryController.clear();
    _newProductQuantityController.clear();
    _newProductPriceController.clear();
    _newProductSellPriceController.clear();
    _isNewProductFormValid = false;
  }

  double _getTotalAmount() {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  String _formatRupiah(double amount) {
    return 'Rp ${NumberFormat('#,###').format(amount)}';
  }

  Future<void> _submitTransaction() async {
    final isPurchase = widget.transactionType == 'Pembelian';

    if (isPurchase && _selectedSupplier == null) {
      SnackbarService.warning(
        context: context,
        message: 'Pilih supplier terlebih dahulu',
      );
      return;
    }

    if (!isPurchase && _customerNameController.text.isEmpty) {
      SnackbarService.warning(
        context: context,
        message: 'Masukkan nama customer',
      );
      return;
    }

    if (_items.isEmpty) {
      SnackbarService.warning(
        context: context,
        message: 'Tambahkan minimal 1 produk',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );
      final notes = _notesController.text;

      bool success;

      if (isPurchase) {
        final newProducts = _pendingNewProducts.values.toList();

        success = await transactionProvider
            .createPurchaseTransactionWithNewProducts(
              supplierId: _selectedSupplier!.id!,
              items: _items,
              newProducts: newProducts,
              paymentMethod: _paymentMethod,
              notes: notes,
              createdBy: 'user',
            );
      } else {
        success = await transactionProvider.createSaleTransaction(
          customerName: _customerNameController.text,
          items: _items,
          discount: 0,
          tax: 0,
          paymentMethod: _paymentMethod,
          notes: notes,
          createdBy: 'user',
        );
      }

      if (!mounted) return;

      if (success) {
        final productProvider = Provider.of<ProductProvider>(
          context,
          listen: false,
        );
        await productProvider.refreshProducts();

        final stockProvider = Provider.of<StockProvider>(
          context,
          listen: false,
        );
        await stockProvider.refreshStockHistory();

        if (mounted) {
          SnackbarService.success(
            context: context,
            message: isPurchase
                ? 'Pembelian berhasil disimpan'
                : 'Penjualan berhasil disimpan',
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception(
          transactionProvider.errorMessage ?? 'Gagal menyimpan transaksi',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackbarService.error(
          context: context,
          message: 'Error: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
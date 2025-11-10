import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'list_produk.dart'; // Import data produk

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedCategory = 'Semua'; // Kategori yang aktif
  final TextEditingController _searchController = TextEditingController(); // Controller untuk search field

  // Daftar kategori produk
  final List<String> _categories = [
    'Semua',
    'Kopi',
    'Non-Kopi',
    'Snack',
    'Minuman',
  ];

  // Getter untuk produk yang sudah difilter berdasarkan kategori dan pencarian
  List<Map<String, dynamic>> get _filteredProducts {
    var filtered = productList; // Data dari list_produk.dart
    
    // Filter by category 
    if (_selectedCategory != 'Semua') {
      filtered = filtered.where((product) => product['category'] == _selectedCategory).toList();
    }
    
    // Filter by search text 
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((product) => 
          product['name'].toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    
    return filtered;
  }

  // Method untuk menerapkan filter dan rebuild UI
  void _applyFilter() {
    setState(() {}); // Trigger rebuild dengan state baru
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan gradient
            _buildHeader(),
            const SizedBox(height: 16),

            // Search Section
            _buildSearchBar(),
            const SizedBox(height: 10),

            // Categories filter chips
            _buildCategoryFilter(),
            const SizedBox(height: 10),

            // Products count header
            _buildProductsHeader(),
            const SizedBox(height: 12),

            // Products List menggunakan widget terpisah
            Expanded(
              child: ProductList(products: _filteredProducts),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk header page
  Widget _buildHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600], 
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade800.withAlpha(76),
            blurRadius: 10,
            offset: const Offset(0, 4), 
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(right: -10, top: -10, child: _buildCircle(70, 51)),
          Positioned(right: 25, bottom: -15, child: _buildCircle(50, 38)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(64), 
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withAlpha(128), width: 1.5),
                  ),
                  child: const Icon(LucideIcons.coffee, color: Colors.white, size: 22), 
                ),
                
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Manajemen Produk", style: _titleStyle), 
                      const SizedBox(height: 6),
                      Text("Kelola menu dan stok produk", style: _subtitleStyle), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membuat circle background
  Widget _buildCircle(double size, int alpha) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(alpha), // White dengan opacity
      shape: BoxShape.circle,
    ),
  );

  // Text styles untuk header
  final _titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.1,
  );

  final _subtitleStyle = TextStyle(
    color: Colors.white.withAlpha(200), // White dengan opacity
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Widget untuk search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _applyFilter(), // Apply filter real-time saat typing
        decoration: InputDecoration(
          hintText: "Cari Produk...",
          prefixIcon: const Icon(Icons.search), // Search icon
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19), // Rounded border
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }

  // Widget untuk category filter chips
  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0, // Spasi horizontal antar chips
        runSpacing: 8.0, // Spasi vertical antar baris
        children: _categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return ChoiceChip(
            label: Text(
              cat,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black87, // White ketika selected
                fontWeight: FontWeight.w500,
              ),
            ),
            selected: isSelected,
            onSelected: (_) {
              setState(() => _selectedCategory = cat); // Update kategori selected
              _applyFilter();
            },
            selectedColor: Colors.blue.shade700, // Blue background ketika selected
            backgroundColor: Colors.white, // White background default
            side: BorderSide(
              color: Colors.grey.shade300, // Border color
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // Rounded chips
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          );
        }).toList(),
      ),
    );
  }

  // Widget untuk header jumlah produk
  Widget _buildProductsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredProducts.length} Produk Ditemukan', 
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
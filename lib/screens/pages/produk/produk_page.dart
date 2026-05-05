import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'list_produk.dart'; // import data produk dari list_produk

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedCategory = 'Semua'; 
  final TextEditingController _searchController = TextEditingController(); 
  final List<String> _categories = ['Semua', 'Kopi', 'Minuman', 'Makanan'];

  List<Map<String, dynamic>> get _filteredProducts {
    var filtered = productList; 
    
    // Filter by kategori jika bukan 'Semua'
    if (_selectedCategory != 'Semua') {
      filtered = filtered.where((product) => product['category'] == _selectedCategory).toList();
    }
    
    // Filter by teks pencarian jika tidak kosong
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((product) => 
          product['name'].toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    
    return filtered; 
  }

  /// BUILD METHOD 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD), 
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16), 
            _buildSearchBar(),
            const SizedBox(height: 10), 
            _buildCategoryFilter(),
            const SizedBox(height: 10),
            _buildProductsHeader(),
            const SizedBox(height: 12),
            
            Expanded(
              child: ProductList(products: _filteredProducts), 
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat header
  Widget _buildHeader() {
    return Container(
      height: 80, 
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600], 
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)), 
        boxShadow: [BoxShadow(
          color: Colors.blue.shade800.withAlpha(76), 
          blurRadius: 10, 
          offset: const Offset(0, 4), 
        )],
      ),
      child: Stack(
        children: [
          Positioned(right: -10, top: -10, child: _buildCircle(70)),
          Positioned(right: 25, bottom: -15, child: _buildCircle(50)),
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

  // Method untuk Membuat circle decoration untuk header
  Widget _buildCircle(double size) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(size == 70 ? 51 : 38), 
      shape: BoxShape.circle, 
    ),
  );

  final _titleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.1,
  );

  final _subtitleStyle = TextStyle(
    color: Colors.white.withAlpha(200),
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.2, 
  );

  /// Widget search bar
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13), 
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: "Cari Produk...", 
            prefixIcon: const Icon(Icons.search, color: Colors.blueGrey), 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(19),
              borderSide: BorderSide.none,
            ), 
            filled: true,
            fillColor: Colors.white, 
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      ),
    );
  }

  // Widget untuk filter kategori 
  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            final bool isFirst = category == _categories.first;
            final bool isLast = category == _categories.last;
            
            return Container(
              margin: EdgeInsets.only(
                right: isLast ? 0 : 8,
                left: isFirst ? 0 : 0,
              ),
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected 
                        ? LinearGradient(
                            colors: [Colors.blue.shade700, Colors.blue.shade600],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.blue.shade300.withAlpha(102), 
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      else
                        BoxShadow(
                          color: Colors.grey.shade300.withAlpha(204), 
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                    ],
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.grey.shade200, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Colors.white.withAlpha(229), 
                          ),
                        ),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.blueGrey.shade800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget untuk header produk
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_alt_rounded,
                  size: 16,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  _selectedCategory,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
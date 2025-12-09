import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// List data produk coffee shop yang mendukung 2 jenis gambar:
/// 1. Gambar LOKAL (assets) - menggunakan 'imageType': 'asset'
/// 2. Gambar INTERNET (network) - menggunakan 'imageType': 'network' atau tanpa imageType
final List<Map<String, dynamic>> productList = [
  {
    'id': '1',
    'name': 'Kopi Susu Gula Aren',
    'category': 'Kopi',
    'price': 15000,
    'stock': 45,
    'image': 'assets/produk/kopi_susu_gula_aren.jpg',
    'imageType': 'asset', // Menandakan gambar dari assets atau lokal
  },
  {
    'id': '2',
    'name': 'Americano',
    'category': 'Kopi',
    'price': 12000,
    'stock': 32,
    'image': 'assets/produk/kopi_americano.jpg',
    'imageType': 'asset', 
  },
  {
    'id': '3',
    'name': 'Matcha Latte',
    'category': 'Minuman',
    'price': 12000,
    'stock': 32,
    'image': 'assets/produk/matcha_latte.jpg',
    'imageType': 'asset', 
  },
  {
    'id': '4',
    'name': 'Latte Art',
    'category': 'Kopi',
    'price': 18000,
    'stock': 28,
    'image': 'https://images.unsplash.com/photo-1561047029-3000c68339ca?w=400&h=300&fit=crop',
    // Tidak ada imageType, default ke network atau dari internet
  },
  {
    'id': '5',
    'name': 'Cappuccino',
    'category': 'Kopi',
    'price': 16000,
    'stock': 36,
    'image': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=300&fit=crop',
  },
  {
    'id': '6',
    'name': 'Strawberry Smoothie',
    'category': 'Minuman',
    'price': 23000,
    'stock': 15,
    'image': 'https://images.pexels.com/photos/103566/pexels-photo-103566.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '7',
    'name': 'Roti',
    'category': 'Makanan',
    'price': 19000,
    'stock': 10,
    'image': 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=300&fit=crop',
  },
  {
    'id': '8',
    'name': 'Club Sandwich',
    'category': 'Makanan',
    'price': 32000,
    'stock': 14,
    'image': 'https://images.pexels.com/photos/1600711/pexels-photo-1600711.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '9',
    'name': 'Mi Goreng',
    'category': 'Makanan',
    'price': 12000,
    'stock': 22,
    'image': 'https://images.pexels.com/photos/2347311/pexels-photo-2347311.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '10',
    'name': 'Es Buah',
    'category': 'Minuman',
    'price': 15000,
    'stock': 16,
    'image': 'https://images.pexels.com/photos/1099680/pexels-photo-1099680.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '11',
    'name': 'Brownies Pack',
    'category': 'Makanan',
    'price': 25000,
    'stock': 13,
    'image': 'https://images.pexels.com/photos/45202/brownie-dessert-cake-sweet-45202.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '12',
    'name': 'Bakso',
    'category': 'Makanan',
    'price': 15000,
    'stock': 45,
    'image': 'assets/produk/bakso.jpeg',
    'imageType': 'asset', 
  },
  {
    'id': '13',
    'name': 'Es Teh',
    'category': 'Minuman',
    'price': 6000,
    'stock': 45,
    'image': 'assets/produk/es_teh.jpg',
    'imageType': 'asset', 
  },
  {
    'id': '14',
    'name': 'Sate',
    'category': 'Makanan',
    'price': 29000,
    'stock': 45,
    'image': 'assets/produk/sate.jpg',
    'imageType': 'asset', 
  },
  {
    'id': '15',
    'name': 'nugget',
    'category': 'Makanan',
    'price': 20000,
    'stock': 100,
    'image': 'assets/produk/nugget.jpg',
    'imageType': 'asset',
  },
  {
    'id': '16',
    'name': 'Club Coffee',
    'category': 'Kopi',
    'price': 22000,
    'stock': 25,
    'image': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w-400&h=300&fit=crop',
  },
  {
    'id': '17',
    'name': 'Kopi Ireng',
    'category': 'Kopi',
    'price': 18000,
    'stock': 30,
    'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=300&fit=crop',
  },
  {
    'id': '18',
    'name': 'Chocolate Frappe',
    'category': 'Minuman',
    'price': 25000,
    'stock': 20,
    'image': 'https://images.pexels.com/photos/3727250/pexels-photo-3727250.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '19',
    'name': 'Chocolate Chip Cookies',
    'category': 'Makanan',
    'price': 12000,
    'stock': 45,
    'image': 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400&h=300&fit=crop',
  },
  {
    'id': '20',
    'name': 'Cheesecake',
    'category': 'Makanan',
    'price': 35000,
    'stock': 12,
    'image': 'https://images.pexels.com/photos/132694/pexels-photo-132694.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '21',
    'name': 'Donut',
    'category': 'Makanan',
    'price': 10000,
    'stock': 60,
    'image': 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=400&h=300&fit=crop',
  },
  {
    'id': '22',
    'name': 'Pancake',
    'category': 'Makanan',
    'price': 28000,
    'stock': 18,
    'image': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=300&fit=crop',
  },
  {
    'id': '23',
    'name': 'French Fries',
    'category': 'Makanan',
    'price': 20000,
    'stock': 30,
    'image': 'https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '24',
    'name': 'Grilled Cheese Sandwich',
    'category': 'Makanan',
    'price': 32000,
    'stock': 20,
    'image': 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&h=300&fit=crop',
  },
  {
    'id': '25',
    'name': 'Caesar Salad',
    'category': 'Makanan',
    'price': 35000,
    'stock': 15,
    'image': 'https://images.pexels.com/photos/2097090/pexels-photo-2097090.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '26',
    'name': 'Tuna Sandwich',
    'category': 'Makanan',
    'price': 30000,
    'stock': 22,
    'image': 'https://images.unsplash.com/photo-1481070414801-51fd732d7184?w=400&h=300&fit=crop',
  },
  {
    'id': '27',
    'name': 'Beef Burger',
    'category': 'Makanan',
    'price': 45000,
    'stock': 18,
    'image': 'https://images.pexels.com/photos/1639562/pexels-photo-1639562.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },
  {
    'id': '28',
    'name': 'Pizza',
    'category': 'Makanan',
    'price': 32000,
    'stock': 20,
    'image': 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=300&fit=crop',
  },
  {
    'id': '29',
    'name': 'Spaghetti Carbonara',
    'category': 'Makanan',
    'price': 42000,
    'stock': 15,
    'image': 'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg?auto=compress&cs=tinysrgb&w=400&h=300&fit=crop',
  },

  {
    'id': '30',
    'name': 'v60 Coffee',
    'category': 'Kopi',
    'price': 20000,
    'stock': 100,
    'image': 'assets/produk/v60.jpg',
    'imageType': 'asset',
  },

  
];


/// Widget untuk menampilkan daftar produk dalam bentuk grid
class ProductList extends StatefulWidget {
  final List<Map<String, dynamic>> products; // Data produk yang akan ditampilkan

  const ProductList({super.key, required this.products});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool _isConnected = true; // Status koneksi internet, default true

  /// Method yang dipanggil saat widget pertama kali dibuat
  @override
  void initState() {
    super.initState();
    _checkConnectivity(); // Cek status koneksi saat pertama kali load
    _setupConnectivityListener(); // Setup listener untuk perubahan koneksi
  }

  /// Method untuk mengecek status koneksi internet
  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _isConnected = result != ConnectivityResult.none); // Update status koneksi
  }

  /// Method untuk setup listener yang mendeteksi perubahan koneksi
  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((result) {
      final connected = result != ConnectivityResult.none;
      if (connected != _isConnected) {
        setState(() => _isConnected = connected); // Update status koneksi
      }
    });
  }

  /// Build method utama widget
  @override
  Widget build(BuildContext context) {
    // Jika tidak ada produk, tampilkan empty state
    // Jika ada produk, tampilkan grid produk
    return widget.products.isEmpty ? _buildEmptyState() : _buildProductsGrid();
  }

  /// Widget untuk menampilkan state kosong ketika tidak ada produk
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada produk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ganti kata kunci pencarian',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan produk dalam bentuk grid 2 kolom
  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Jumlah kolom dalam grid
          crossAxisSpacing: 12, // Jarak horizontal antar item
          mainAxisSpacing: 12, // Jarak vertikal antar item
          childAspectRatio: 0.8, // Rasio tinggi/lebar item 
        ),
        itemCount: widget.products.length, // Jumlah total item
        itemBuilder: (context, index) => _buildProductCard(widget.products[index]), // Builder untuk setiap item
      ),
    );
  }

  /// Widget untuk menampilkan card produk individual
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container untuk gambar produk
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey.shade100, 
              child: _buildProductImage(product), // Widget gambar produk
            ),
          ),
          
          // Container untuk informasi produk (nama, kategori, harga, stok)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
                  maxLines: 2, // Maksimal 2 baris
                  overflow: TextOverflow.ellipsis, 
                ),
                const SizedBox(height: 4),                
                Text(
                  product['category'],
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp ${_formatCurrency(product['price'])}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue),
                    ),
                    
                    // Badge stok produk
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product['stock']} stok',
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Method untuk membangun widget gambar produk berdasarkan jenis gambar dan status koneksi
  Widget _buildProductImage(Map<String, dynamic> product) {
    final imageType = product['imageType'] ?? 'network'; // Default ke 'network' jika tidak ada imageType
    
    if (imageType == 'asset') {
      // Jika gambar lokal: Load dari assets folder
      return Image.asset(
        product['image'],
        fit: BoxFit.cover, // Sesuaikan gambar ke container
        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(Icons.coffee_outlined),
      );
    } else {
      // Jika gambar dari internet: 
      if (!_isConnected) {
        // Jika offline: Tampilkan placeholder offline
        return _buildOfflinePlaceholder();
      }
      
      // Jika online: Load gambar dari internet menggunakan CachedNetworkImage
      return CachedNetworkImage(
        imageUrl: product['image'],
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingPlaceholder(), // Tampilkan saat loading
        errorWidget: (context, url, error) => _buildImagePlaceholder(Icons.broken_image), // Tampilkan jika error
      );
    }
  }

  /// Placeholder default untuk gambar, digunakan untuk error loading gambar lokal/network
  Widget _buildImagePlaceholder(IconData icon) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(child: Icon(icon, color: Colors.grey, size: 40)),
    );
  }

  /// Placeholder khusus untuk status offline
  Widget _buildOfflinePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.grey, size: 30),
          const SizedBox(height: 4),
          Text('Offline', style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          Text('No Internet', style: TextStyle(fontSize: 8, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  /// Placeholder untuk loading gambar dari internet
  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400)),
          ),
          const SizedBox(height: 4),
          Text('Loading...', style: TextStyle(fontSize: 9, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  /// Method untuk format angka menjadi format mata uang Indonesia, ribuan dipisah titik
  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), // Regex untuk mencari setiap 3 digit
      (m) => '${m[1]}.', // Tambahkan titik sebagai pemisah ribuan
    );
  }
}
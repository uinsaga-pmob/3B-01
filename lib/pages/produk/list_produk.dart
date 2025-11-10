import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// =============================================================================
// DATA PRODUK COFFEE SHOP
// =============================================================================

/// List data produk yang mendukung 2 jenis gambar:
/// 1. Gambar LOKAL (assets) - menggunakan 'imageType': 'asset'
/// 2. Gambar INTERNET (network) - menggunakan 'imageType': 'network' atau tanpa imageType

/// Menggunakan cached_network_image untuk mengakses gambar gratis dari beberapa platform seperti:
/// Unsplash - https://images.unsplash.com/...
/// Pexels - https://images.pexels.com/...
/// Pixabay - https://cdn.pixabay.com/...

/// FITUR: Auto switch antara gambar internet dan placeholder saat offline
/// - Saat ONLINE: Gambar dari internet akan dimuat
/// - Saat OFFLINE: Langsung tampilkan placeholder (tidak loading muter)
/// - Real-time: Otomatis update ketika koneksi berubah

final List<Map<String, dynamic>> productList = [

  // ============================== PRODUK KOPI ==============================
  // PRODUK DENGAN GAMBAR LOKAL (ASSETS)
  {
    'id': '1',
    'name': 'Kopi Susu Gula Aren',
    'category': 'Kopi',
    'price': 15000,
    'stock': 45,
    'image': 'assets/produk/kopi_susu_gula_aren.jpg', // Path ke file lokal di assets
    'imageType': 'asset', // TANDAI SEBAGAI GAMBAR LOKAL
  },
  {
    'id': '2',
    'name': 'Americano',
    'category': 'Kopi',
    'price': 12000,
    'stock': 32,
    'image': 'assets/produk/kopi_americano.jpg', // Path ke file lokal di assets
    'imageType': 'asset', // TANDAI SEBAGAI GAMBAR LOKAL
  },

  // PRODUK DENGAN GAMBAR INTERNET (NETWORK) - TANPA imageType
  {
    'id': '3',
    'name': 'Latte Art',
    'category': 'Kopi',
    'price': 18000,
    'stock': 28,
    'image': 'https://images.unsplash.com/photo-1561047029-3000c68339ca?w=400&h=300&fit=crop',
    // Tidak ada imageType -> default ke 'network'
  },
  {
    'id': '4',
    'name': 'Cappuccino',
    'category': 'Kopi',
    'price': 16000,
    'stock': 36,
    'image': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=300&fit=crop',
    // Tidak ada imageType -> default ke 'network'
  },

  // PRODUK DENGAN GAMBAR INTERNET (NETWORK) - DENGAN imageType eksplisit
  {
    'id': '5',
    'name': 'Espresso',
    'category': 'Kopi',
    'price': 10000,
    'stock': 50,
    'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=300&fit=crop',
    'imageType': 'network', // TANDAI SEBAGAI GAMBAR INTERNET (opsional)
  },
  {
    'id': '6',
    'name': 'Vietnam Drip',
    'category': 'Kopi',
    'price': 22000,
    'stock': 20,
    'image': 'https://images.unsplash.com/photo-1587734195503-904fca47e0e9?w=400&h=300&fit=crop',
    'imageType': 'network', // TANDAI SEBAGAI GAMBAR INTERNET (opsional)
  },
  {
    'id': '7',
    'name': 'Mocha',
    'category': 'Kopi',
    'price': 19000,
    'stock': 25,
    'image': 'https://images.unsplash.com/photo-1561047029-3000c68339ca?w=400&h=300&fit=crop',
    'imageType': 'network', 
  },
  {
    'id': '8',
    'name': 'Macchiato',
    'category': 'Kopi',
    'price': 17000,
    'stock': 30,
    'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
    'imageType': 'network', 
  },
  {
    'id': '9',
    'name': 'Flat White',
    'category': 'Kopi',
    'price': 20000,
    'stock': 22,
    'image': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=300&fit=crop',
    'imageType': 'network', 
  },
  {
    'id': '10',
    'name': 'Turkish Coffee',
    'category': 'Kopi',
    'price': 25000,
    'stock': 15,
    'image': 'https://images.unsplash.com/photo-1587734195503-904fca47e0e9?w=400&h=300&fit=crop',
    'imageType': 'network', 
  },

  // PRODUK DENGAN GAMBAR LOKAL (ASSETS)
  {
    'id': '11',
    'name': 'Matcha Latte',
    'category': 'Non-Kopi',
    'price': 20000,
    'stock': 24,
    'image': 'assets/produk/matcha_latte.jpg', // Path ke file lokal di assets
    'imageType': 'asset', // TANDAI SEBAGAI GAMBAR LOKAL
  },

  // ============================ PRODUK NON-KOPI ============================
  // PRODUK DENGAN GAMBAR INTERNET (NETWORK)
  {
    'id': '12',
    'name': 'Chocolate Ice',
    'category': 'Non-Kopi',
    'price': 17000,
    'stock': 18,
    'image': 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400&h=300&fit=crop',
  },
  {
    'id': '13',
    'name': 'Thai Tea',
    'category': 'Non-Kopi',
    'price': 15000,
    'stock': 30,
    'image': 'https://images.unsplash.com/photo-1567095761054-7a02e69e5c43?w=400&h=300&fit=crop',
  },
  {
    'id': '14',
    'name': 'Lemon Tea',
    'category': 'Non-Kopi',
    'price': 12000,
    'stock': 40,
    'image': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&h=300&fit=crop',
  },
  {
    'id': '15',
    'name': 'Red Velvet Latte',
    'category': 'Non-Kopi',
    'price': 19000,
    'stock': 22,
    'image': 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=400&h=300&fit=crop',
  },
  {
    'id': '16',
    'name': 'Taro Latte',
    'category': 'Non-Kopi',
    'price': 18000,
    'stock': 20,
    'image': 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400&h=300&fit=crop',
  },
  {
    'id': '17',
    'name': 'Hazelnut Coffee',
    'category': 'Non-Kopi',
    'price': 16000,
    'stock': 28,
    'image': 'https://images.unsplash.com/photo-1561047029-3000c68339ca?w=400&h=300&fit=crop',
  },
  {
    'id': '18',
    'name': 'Vanilla Latte',
    'category': 'Non-Kopi',
    'price': 17000,
    'stock': 26,
    'image': 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400&h=300&fit=crop',
  },

  // ============================= PRODUK SNACK ==============================
  // PRODUK DENGAN GAMBAR INTERNET (NETWORK)
  {
    'id': '19',
    'name': 'Croissant',
    'category': 'Snack',
    'price': 12000,
    'stock': 52,
    'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
  },
  {
    'id': '20',
    'name': 'Sandwich',
    'category': 'Snack',
    'price': 22000,
    'stock': 15,
    'image': 'https://images.unsplash.com/photo-1567234669003-dce7a7a88821?w=400&h=300&fit=crop',
  },
  {
    'id': '21',
    'name': 'Muffin Coklat',
    'category': 'Snack',
    'price': 10000,
    'stock': 25,
    'image': 'https://images.unsplash.com/photo-1576618148400-f54bed99fcfd?w=400&h=300&fit=crop',
  },
  {
    'id': '22',
    'name': 'Cookies',
    'category': 'Snack',
    'price': 8000,
    'stock': 60,
    'image': 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&h=300&fit=crop',
  },
  {
    'id': '23',
    'name': 'Brownies',
    'category': 'Snack',
    'price': 15000,
    'stock': 35,
    'image': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=300&fit=crop',
  },
  {
    'id': '24',
    'name': 'Donat',
    'category': 'Snack',
    'price': 7000,
    'stock': 40,
    'image': 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&h=300&fit=crop',
  },
  {
    'id': '25',
    'name': 'Pancake',
    'category': 'Snack',
    'price': 18000,
    'stock': 20,
    'image': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=300&fit=crop',
  },
  {
    'id': '26',
    'name': 'Waffle',
    'category': 'Snack',
    'price': 16000,
    'stock': 18,
    'image': 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=400&h=300&fit=crop',
  },

  // ============================ PRODUK MINUMAN =============================
  
  // PRODUK DENGAN GAMBAR INTERNET (NETWORK)
  {
    'id': '28',
    'name': 'Jus Jeruk',
    'category': 'Minuman',
    'price': 15000,
    'stock': 35,
    'image': 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=400&h=300&fit=crop',
  },
  {
    'id': '29',
    'name': 'Soda Gembira',
    'category': 'Minuman',
    'price': 13000,
    'stock': 20,
    'image': 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&h=300&fit=crop',
  },
  {
    'id': '30',
    'name': 'Es Teh Manis',
    'category': 'Minuman',
    'price': 8000,
    'stock': 75,
    'image': 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400&h=300&fit=crop',
  },

  // ============================== PRODUK TAMBAHAN ==============================
  // PRODUK DENGAN GAMBAR INTERNET (NETWORK)
  {
    'id': '31',
    'name': 'Kopi Tubruk',
    'category': 'Kopi',
    'price': 8000,
    'stock': 60,
    'image': 'https://images.unsplash.com/photo-1587734195503-904fca47e0e9?w=400&h=300&fit=crop',
  },
  {
    'id': '32',
    'name': 'V60 Pour Over',
    'category': 'Kopi',
    'price': 25000,
    'stock': 18,
    'image': 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=300&fit=crop',
  },
  {
    'id': '33',
    'name': 'Cold Brew',
    'category': 'Kopi',
    'price': 18000,
    'stock': 25,
    'image': 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=300&fit=crop',
  },
  {
    'id': '34',
    'name': 'Affogato',
    'category': 'Kopi',
    'price': 22000,
    'stock': 20,
    'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=300&fit=crop',
  },
  {
    'id': '35',
    'name': 'Milkshake Coklat',
    'category': 'Non-Kopi',
    'price': 16000,
    'stock': 30,
    'image': 'https://images.unsplash.com/photo-1577803645773-f96470509666?w=400&h=300&fit=crop',
  },
  {
    'id': '37',
    'name': 'Hot Chocolate',
    'category': 'Non-Kopi',
    'price': 15000,
    'stock': 35,
    'image': 'https://images.unsplash.com/photo-1542995470-870e12e7e14f?w=400&h=300&fit=crop',
  },
  {
    'id': '38',
    'name': 'Es Kelapa Muda',
    'category': 'Non-Kopi',
    'price': 12000,
    'stock': 40,
    'image': 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&h=300&fit=crop',
  },
  {
    'id': '39',
    'name': 'Bagel',
    'category': 'Snack',
    'price': 14000,
    'stock': 28,
    'image': 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=300&fit=crop',
  },
  {
    'id': '40',
    'name': 'Cinnamon Roll',
    'category': 'Snack',
    'price': 13000,
    'stock': 32,
    'image': 'https://images.unsplash.com/photo-1556912167-f556f1f39fdf?w=400&h=300&fit=crop',
  },
  {
    'id': '41',
    'name': 'Banana Bread',
    'category': 'Snack',
    'price': 11000,
    'stock': 26,
    'image': 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=300&fit=crop',
  },
  {
    'id': '42',
    'name': 'Cheese Cake',
    'category': 'Snack',
    'price': 20000,
    'stock': 18,
    'image': 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400&h=300&fit=crop',
  },
  {
    'id': '43',
    'name': 'Es Cincau',
    'category': 'Minuman',
    'price': 10000,
    'stock': 45,
    'image': 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400&h=300&fit=crop',
  },
  {
    'id': '44',
    'name': 'Jus Alpukat',
    'category': 'Minuman',
    'price': 16000,
    'stock': 30,
    'image': 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&h=300&fit=crop',
  },
  {
    'id': '45',
    'name': 'Es Campur',
    'category': 'Minuman',
    'price': 15000,
    'stock': 25,
    'image': 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=400&h=300&fit=crop',
  },
  {
    'id': '46',
    'name': 'Milkshake Vanilla',
    'category': 'Minuman',
    'price': 17000,
    'stock': 28,
    'image': 'https://images.unsplash.com/photo-1577803645773-f96470509666?w=400&h=300&fit=crop',
  },
];

// WIDGET PRODUCT LIST - SUPPORT KEDUA JENIS GAMBAR + AUTO SWITCH OFFLINE/ONLINE
class ProductList extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const ProductList({
    super.key,
    required this.products,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool _isConnected = true; // Status koneksi internet, default true

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity(); // Cek koneksi saat pertama kali load
    _setupConnectivityListener(); // Setup listener untuk perubahan koneksi
  }

  /// Method untuk mengecek status koneksi internet saat pertama kali widget di load
  Future<void> _checkInitialConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
    debugPrint('Initial connection status: ${_isConnected ? 'ONLINE' : 'OFFLINE'}');
  }

  /// Method untuk setup listener yang akan mendeteksi perubahan koneksi internet
  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      final newConnectionStatus = result != ConnectivityResult.none;
      
      // Hanya update state jika status koneksi berubah
      if (newConnectionStatus != _isConnected) {
        setState(() {
          _isConnected = newConnectionStatus;
        });
        
        // Debug print untuk memantau perubahan koneksi
        debugPrint('Connection status changed: ${_isConnected ? 'ONLINE' : 'OFFLINE'}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada produk, tampilkan pesan kosong
    if (widget.products.isEmpty) {
      return _buildEmptyState();
    }

    // Tampilkan produk dalam grid layout
    return _buildProductsGrid();
  }

  /// Widget untuk menampilkan state ketika tidak ada produk yang sesuai filter
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada produk',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ganti kata kunci pencarian',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
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
          crossAxisCount: 2, // 2 kolom
          crossAxisSpacing: 12, // Jarak horizontal antar item
          mainAxisSpacing: 12, // Jarak vertikal antar item
          childAspectRatio: 0.8, // Rasio tinggi/lebar item
        ),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final product = widget.products[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  /// Widget untuk menampilkan card produk individual
  Widget _buildProductCard(Map<String, dynamic> product) {
    // Debug: print informasi gambar untuk troubleshooting
    debugPrint('Loading image: ${product['image']} (Type: ${product['imageType']})');
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk - Mendukung kedua jenis gambar + auto switch offline/online
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey.shade100, // Background default
              child: _buildProductImage(product), // Panggil method untuk build gambar
            ),
          ),
          
          // Informasi Produk (nama, kategori, harga, stok)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Produk
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                
                // Kategori Produk
                Text(
                  product['category'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Harga dan Stok
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Harga Produk
                    Text(
                      'Rp ${_formatCurrency(product['price'])}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                    
                    // Stok Produk
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${product['stock']} stok',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
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

  /// METHOD Auto switch antara gambar internet dan placeholder saat offline
  /// - Gambar LOKAL: Selalu tampil (offline/online)
  /// - Gambar INTERNET: 
  ///   - OFFLINE: Langsung tampilkan placeholder (tidak loading)
  ///   - ONLINE: Load gambar dari internet

  Widget _buildProductImage(Map<String, dynamic> product) {
    // Tentukan jenis gambar: default ke 'network' jika tidak ada imageType
    final imageType = product['imageType'] ?? 'network';
    if (imageType == 'asset') {
      return Image.asset(  // GAMBAR LOKAL (ASSETS) selalu bisa offline/online
        product['image'], // Path ke file di assets folder
        fit: BoxFit.cover, // Sesuaikan gambar ke container
        errorBuilder: (context, error, stackTrace) {
          // Jika error loading gambar lokal, tampilkan placeholder default
          debugPrint('Error loading asset image: $error');
          return _buildDefaultPlaceholder();
        },
      );
    } else {
      // JIKA OFFLINE: Langsung tampilkan placeholder offline
      if (!_isConnected) {
        return _buildOfflinePlaceholder();
      }
      
      // JIKA ONLINE: Load gambar dari internet menggunakan CachedNetworkImage
      return CachedNetworkImage(
        imageUrl: product['image'], // URL gambar dari internet
        fit: BoxFit.cover, // Sesuaikan gambar ke container
        placeholder: (context, url) {
          // Tampilkan loading placeholder saat gambar sedang dimuat
          return _buildLoadingPlaceholder();
        },
        errorWidget: (context, url, error) {
          // Jika error loading gambar internet (URL rusak, server down, dll)
          debugPrint('Error loading network image: $error');
          return _buildErrorPlaceholder();
        },
      );
    }
  }

  /// Placeholder DEFAULT - Digunakan untuk gambar lokal yang error
  Widget _buildDefaultPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.coffee_outlined, // Icon default untuk produk coffee shop
          color: Colors.grey,
          size: 40,
        ),
      ),
    );
  }

  /// Placeholder OFFLINE - Ditampilkan saat tidak ada koneksi internet
  Widget _buildOfflinePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off, // Icon wifi off untuk indikasi offline
            color: Colors.grey,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            'Offline', // Teks indikasi status
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'No Internet', // Teks tambahan
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  /// Placeholder LOADING - Ditampilkan saat gambar dari internet sedang dimuat
  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Loading...', // Teks indikasi loading
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Placeholder ERROR - Ditampilkan saat gagal load gambar dari internet
  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.broken_image, // Icon broken image untuk indikasi error
            color: Colors.grey,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            'Failed to load', // Teks indikasi gagal load
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Method untuk format mata uang 
  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.', // Tambahkan titik sebagai pemisah ribuan
    );
  }
}
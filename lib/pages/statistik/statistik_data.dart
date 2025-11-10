import 'package:flutter/material.dart';

// =============================================================================
// DATA MODELS UNTUK STATISTIK
// =============================================================================

/// Model data untuk penjualan per periode (hari/minggu/bulan)
/// Digunakan untuk chart data dengan label hari dan amount
class SalesData {
  final String day;    // Label hari/minggu/bulan (contoh: 'Sen', 'Minggu 1', 'Jan')
  final int amount;    // Jumlah nominal (pendapatan/pengeluaran/profit)

  SalesData(this.day, this.amount);
}

/// Model data untuk distribusi kategori produk
/// Menyimpan persentase dan warna untuk pie chart
class CategoryData {
  final String category;   // Nama kategori (contoh: 'Kopi', 'Snack')
  final double percentage; // Persentase distribusi (0-100)
  final Color color;       // Warna representasi untuk chart

  CategoryData(this.category, this.percentage, this.color);
}

/// Model data untuk produk terlaris
/// Berisi informasi penjualan dan pertumbuhan produk
class ProductData {
  final String name;    // Nama produk
  final int sales;      // Jumlah penjualan (unit)
  final int revenue;    // Total pendapatan dari produk
  final double growth;  // Persentase pertumbuhan (%)
  
  ProductData({
    required this.name,
    required this.sales,
    required this.revenue,
    required this.growth,
  });
}

// =============================================================================
// SUMBER DATA UNTUK ANALYTICS
// =============================================================================

class StatisticsRepository {
  // Daftar pilihan periode untuk filter
  static final List<String> periods = ['Minggu Ini', 'Bulan Ini', 'Tahun Ini'];
  
  // Daftar pilihan tipe chart untuk filter
  static final List<String> chartTypes = ['Pendapatan', 'Pengeluaran', 'Profit'];

  // =========================================================================
  // DATA SET UNTUK BERBAGAI PERIODE
  // =========================================================================

  /// Data untuk Minggu Ini - 7 hari (Senin hingga Minggu)
  /// Data pendapatan harian coffee shop
  static final List<SalesData> weeklyRevenue = [
    SalesData('Sen', 1200000),  // Senin: 1.2 juta
    SalesData('Sel', 1850000),  // Selasa: 1.85 juta  
    SalesData('Rab', 1500000),  // Rabu: 1.5 juta
    SalesData('Kam', 2200000),  // Kamis: 2.2 juta
    SalesData('Jum', 1950000),  // Jumat: 1.95 juta
    SalesData('Sab', 2800000),  // Sabtu: 2.8 juta (weekend peak)
    SalesData('Min', 3200000),  // Minggu: 3.2 juta (weekend peak)
  ];

  /// Data pengeluaran untuk Minggu Ini
  /// Biaya operasional harian
  static final List<SalesData> weeklyExpense = [
    SalesData('Sen', 450000),  // Senin: 450 ribu
    SalesData('Sel', 620000),  // Selasa: 620 ribu
    SalesData('Rab', 380000),  // Rabu: 380 ribu
    SalesData('Kam', 750000),  // Kamis: 750 ribu
    SalesData('Jum', 520000),  // Jumat: 520 ribu
    SalesData('Sab', 680000),  // Sabtu: 680 ribu
    SalesData('Min', 890000),  // Minggu: 890 ribu
  ];

  /// Data untuk Bulan Ini - 4 minggu
  /// Data pendapatan mingguan
  static final List<SalesData> monthlyRevenue = [
    SalesData('Minggu 1', 8500000),   // Week 1: 8.5 juta
    SalesData('Minggu 2', 9200000),   // Week 2: 9.2 juta
    SalesData('Minggu 3', 7800000),   // Week 3: 7.8 juta
    SalesData('Minggu 4', 10500000),  // Week 4: 10.5 juta
  ];

  /// Data pengeluaran untuk Bulan Ini
  static final List<SalesData> monthlyExpense = [
    SalesData('Minggu 1', 3200000),  // Week 1: 3.2 juta
    SalesData('Minggu 2', 2800000),  // Week 2: 2.8 juta
    SalesData('Minggu 3', 3500000),  // Week 3: 3.5 juta
    SalesData('Minggu 4', 4100000),  // Week 4: 4.1 juta
  ];

  /// Data untuk Tahun Ini - 12 bulan (Januari hingga Desember)
  /// Data pendapatan bulanan dengan trend pertumbuhan
  static final List<SalesData> yearlyRevenue = [
    SalesData('Jan', 35000000),  // Januari: 35 juta
    SalesData('Feb', 42000000),  // Februari: 42 juta
    SalesData('Mar', 38000000),  // Maret: 38 juta
    SalesData('Apr', 45000000),  // April: 45 juta
    SalesData('Mei', 52000000),  // Mei: 52 juta
    SalesData('Jun', 48000000),  // Juni: 48 juta
    SalesData('Jul', 55000000),  // Juli: 55 juta
    SalesData('Agu', 60000000),  // Agustus: 60 juta
    SalesData('Sep', 58000000),  // September: 58 juta
    SalesData('Okt', 65000000),  // Oktober: 65 juta
    SalesData('Nov', 70000000),  // November: 70 juta
    SalesData('Des', 75000000),  // Desember: 75 juta 
  ];

  /// Data pengeluaran untuk Tahun Ini
  static final List<SalesData> yearlyExpense = [
    SalesData('Jan', 12000000),  // Januari: 12 juta
    SalesData('Feb', 15000000),  // Februari: 15 juta
    SalesData('Mar', 13000000),  // Maret: 13 juta
    SalesData('Apr', 16000000),  // April: 16 juta
    SalesData('Mei', 18000000),  // Mei: 18 juta
    SalesData('Jun', 17000000),  // Juni: 17 juta
    SalesData('Jul', 19000000),  // Juli: 19 juta
    SalesData('Agu', 21000000),  // Agustus: 21 juta
    SalesData('Sep', 20000000),  // September: 20 juta
    SalesData('Okt', 22000000),  // Oktober: 22 juta
    SalesData('Nov', 24000000),  // November: 24 juta
    SalesData('Des', 25000000),  // Desember: 25 juta
  ];

  // =========================================================================
  // DATA DISTRIBUSI KATEGORI DAN PRODUK TERLARIS
  // =========================================================================

  /// Data distribusi kategori produk untuk pie chart
  /// Menunjukkan persentase penjualan per kategori
  static final List<CategoryData> categoryData = [
    CategoryData('Kopi', 45, Colors.blue),      // Kopi: 45% - Warna biru
    CategoryData('Snack', 25, Colors.green),    // Snack: 25% - Warna hijau
    CategoryData('Non-Kopi', 18, Colors.orange), // Non-Kopi: 18% - Warna orange
    CategoryData('Lainnya', 12, Colors.purple), // Lainnya: 12% - Warna ungu
  ];

  /// Data produk terlaris dengan metrik penjualan
  /// Diurutkan berdasarkan performance terbaik
  static final List<ProductData> topProducts = [
    ProductData(
      name: 'Kopi Susu Gula Aren', 
      sales: 156,                   // 156 penjualan
      revenue: 2340000,             // 2.34 juta revenue
      growth: 12.5                  // Growth 12.5%
    ),
    ProductData(
      name: 'Americano', 
      sales: 128, 
      revenue: 1920000, 
      growth: 8.3
    ),
    ProductData(
      name: 'Latte', 
      sales: 95, 
      revenue: 1710000, 
      growth: 15.2
    ),
    ProductData(
      name: 'Matcha Late', 
      sales: 87, 
      revenue: 1590000, 
      growth: 5.2
    ),
  ];

  // =========================================================================
  // HELPER METHODS UNTUK DATA RETRIEVAL DAN PROCESSING
  // =========================================================================

  /// Fungsi untuk mendapatkan data chart berdasarkan periode dan tipe
  /// Mengembalikan list SalesData yang sesuai dengan filter yang dipilih
  static List<SalesData> getCurrentData(String selectedPeriod, String selectedChartType) {
    if (selectedChartType == 'Pendapatan') {
      switch (selectedPeriod) {
        case 'Minggu Ini':
          return weeklyRevenue;
        case 'Bulan Ini':
          return monthlyRevenue;
        case 'Tahun Ini':
          return yearlyRevenue;
        default:
          return weeklyRevenue; // Fallback default
      }
    } else if (selectedChartType == 'Pengeluaran') {
      switch (selectedPeriod) {
        case 'Minggu Ini':
          return weeklyExpense;
        case 'Bulan Ini':
          return monthlyExpense;
        case 'Tahun Ini':
          return yearlyExpense;
        default:
          return weeklyExpense; // Fallback default
      }
    } else {
      // Profit = Revenue - Expense (dihitung secara real-time)
      switch (selectedPeriod) {
        case 'Minggu Ini':
          return _calculateProfit(weeklyRevenue, weeklyExpense);
        case 'Bulan Ini':
          return _calculateProfit(monthlyRevenue, monthlyExpense);
        case 'Tahun Ini':
          return _calculateProfit(yearlyRevenue, yearlyExpense);
        default:
          return _calculateProfit(weeklyRevenue, weeklyExpense); // Fallback default
      }
    }
  }

  /// Fungsi unttuk menghitung profit dari revenue dan expense
  /// Profit = Revenue - Expense untuk setiap periode
  static List<SalesData> _calculateProfit(List<SalesData> revenue, List<SalesData> expense) {
    return revenue.asMap().entries.map((entry) {
      final index = entry.key;
      final rev = entry.value;
      final exp = expense[index];
      return SalesData(rev.day, rev.amount - exp.amount); // Profit calculation
    }).toList();
  }

  /// Fungsi untuk menghitung total revenue berdasarkan periode
  /// Menggunakan reduce untuk menjumlahkan semua amount dalam list
  static double getTotalRevenue(String selectedPeriod) {
    switch (selectedPeriod) {
      case 'Minggu Ini':
        return weeklyRevenue.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
      case 'Bulan Ini':
        return monthlyRevenue.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
      case 'Tahun Ini':
        return yearlyRevenue.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
      default:
        return weeklyRevenue.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
    }
  }

  /// Menghitung total expense berdasarkan periode
  static double getTotalExpense(String selectedPeriod) {
    switch (selectedPeriod) {
      case 'Minggu Ini':
        return weeklyExpense.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
      case 'Bulan Ini':
        return monthlyExpense.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
      case 'Tahun Ini':
        return yearlyExpense.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
      default:
        return weeklyExpense.map((e) => e.amount).reduce((a, b) => a + b).toDouble();
    }
  }

  /// Menghitung total profit berdasarkan periode
  /// Profit = Total Revenue - Total Expense
  static double getTotalProfit(String selectedPeriod) {
    return getTotalRevenue(selectedPeriod) - getTotalExpense(selectedPeriod);
  }

  /// Mendapatkan nilai maksimum Y untuk chart scaling
  /// Digunakan untuk menentukan batas atas chart
  static double getMaxY(List<SalesData> data) {
    return data.map((e) => e.amount.toDouble()).reduce((a, b) => a > b ? a : b);
  }

  // =========================================================================
  // FORMATTING METHODS UNTUK TAMPILAN UI
  // =========================================================================

  /// Format currency untuk tampilan compact
  /// Contoh: 
  /// - 1,200,000 → "Rp 1.2 JT"
  /// - 15,000 → "Rp 15.0 RB"  
  /// - 500 → "Rp 500"
  static String formatCurrency(int amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)} JT'; // Jutaan
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(1)} RB'; // Ribuan
    }
    return 'Rp $amount'; // Satuan
  }

  /// Format currency untuk tooltip chart
  /// Menampilkan format angka dengan pemisah ribuan
  /// Contoh: 1200000 → "1.200.000"
  static String formatTooltipCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.', // Tambahkan titik sebagai pemisah ribuan
    );
  }

  /// Format nilai Y-axis untuk chart
  /// Menyederhanakan tampilan angka besar di axis
  /// Contoh:
  /// - 1000000 → "1JT"
  /// - 1500 → "1K"  
  /// - 500 → "500"
  static String formatYAxis(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}JT'; // Jutaan
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K'; // Ribuan
    }
    return value.toStringAsFixed(0); // Satuan
  }
}
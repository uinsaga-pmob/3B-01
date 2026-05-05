/// Model data untuk penjualan dengan periode tertentu (harian/mingguan/bulanan)
class SalesData {
  final String day;  // Periode: 'Sen', 'Minggu 1', 'Jan', dll
  final int amount; // Jumlah nominal dalam Rupiah

  SalesData(this.day, this.amount);
}

// Model product data untuk data produk terlaris
class ProductData {
  final String name;
  final int sales;
  final int revenue;
  final double growth;
  final int unitPrice;

  ProductData({
    required this.name,
    required this.sales,
    required this.revenue,
    required this.growth,
    required this.unitPrice,
  });
}

// Repository statistik bisnis, digunakan untuk data dummy dan method helper
class StatisticsRepository {
  // Daftar pilihan untuk dropdown filter
  static final List<String> periods = ['Minggu Ini', 'Bulan Ini', 'Tahun Ini'];
  
  // List tipe data yang tersedia untuk chart
  static final List<String> chartTypes = [
    'Pendapatan',
    'Pengeluaran',
    'Profit',
  ];
  
  // Data pendapatan harian selama 1 minggu 
  static final List<SalesData> weeklyRevenue = [
    SalesData('Sen', 1200000),  
    SalesData('Sel', 1850000),  
    SalesData('Rab', 1500000),  
    SalesData('Kam', 2200000),  
    SalesData('Jum', 1950000),  
    SalesData('Sab', 2800000),  
    SalesData('Min', 3200000),   
  ];

  // Data pendapatan mingguan selama 1 bulan 
  static final List<SalesData> monthlyRevenue = [
    SalesData('Minggu 1', 8500000),   
    SalesData('Minggu 2', 9200000),   
    SalesData('Minggu 3', 7800000),   
    SalesData('Minggu 4', 10500000),  
  ];

  // Data pendapatan bulanan selama 1 tahun 
  static final List<SalesData> yearlyRevenue = [
    SalesData('Jan', 35000000),  
    SalesData('Feb', 42000000),  
    SalesData('Mar', 38000000),  
    SalesData('Apr', 45000000),  
    SalesData('Mei', 52000000),  
    SalesData('Jun', 48000000),  
    SalesData('Jul', 55000000),  
    SalesData('Agu', 60000000),  
    SalesData('Sep', 58000000),  
    SalesData('Okt', 65000000),  
    SalesData('Nov', 70000000),  
    SalesData('Des', 75000000),
  ];

  // Data pengeluaran harian selama 1 minggu
  static final List<SalesData> weeklyExpense = [
    SalesData('Sen', 450000),   
    SalesData('Sel', 620000),   
    SalesData('Rab', 380000),   
    SalesData('Kam', 750000),   
    SalesData('Jum', 520000),   
    SalesData('Sab', 680000),   
    SalesData('Min', 890000),   
  ];

  // Data pengeluaran mingguan selama 1 bulan
  static final List<SalesData> monthlyExpense = [
    SalesData('Minggu 1', 3200000),
    SalesData('Minggu 2', 2800000),
    SalesData('Minggu 3', 3500000),
    SalesData('Minggu 4', 4100000),
  ];

  // Data pengeluaran bulanan selama 1 tahun
  static final List<SalesData> yearlyExpense = [
    SalesData('Jan', 12000000),
    SalesData('Feb', 15000000),
    SalesData('Mar', 13000000),
    SalesData('Apr', 16000000),
    SalesData('Mei', 18000000),
    SalesData('Jun', 17000000),
    SalesData('Jul', 19000000),
    SalesData('Agu', 21000000),
    SalesData('Sep', 20000000),
    SalesData('Okt', 22000000),
    SalesData('Nov', 24000000),
    SalesData('Des', 25000000),
  ];

  // List data produk terlaris
  static final List<ProductData> topProducts = [
    ProductData(
      name: 'Kopi Susu Gula Aren Signature',
      sales: 156,
      revenue: 2340000,
      growth: 12.5,
      unitPrice: 15000,
    ),
    ProductData(
      name: 'Americano Double Shot',
      sales: 128,
      revenue: 1920000,
      growth: 8.3,
      unitPrice: 15000,
    ),
    ProductData(
      name: 'Caramel Latte Premium',
      sales: 95,
      revenue: 1710000,
      growth: 15.2,
      unitPrice: 18000,
    ),
    ProductData(
      name: 'Matcha Latte Japanese Style',
      sales: 87,
      revenue: 1590000,
      growth: 5.2,
      unitPrice: 18000,
    ),
  ];

  // Method untuk mengambil data berdasarkan filter  
  // Mengambil data chart berdasarkan periode dan tipe yang dipilih
  static List<SalesData> getCurrentData(
    String selectedPeriod,
    String selectedChartType,
  ) {
    if (selectedChartType == 'Pendapatan') {
      switch (selectedPeriod) {
        case 'Minggu Ini':
          return weeklyRevenue;
        case 'Bulan Ini':
          return monthlyRevenue;
        case 'Tahun Ini':
          return yearlyRevenue;
        default:
          return weeklyRevenue; 
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
          return weeklyExpense;
      }
    } else {
      switch (selectedPeriod) {
        case 'Minggu Ini':
          return _calculateProfit(weeklyRevenue, weeklyExpense);
        case 'Bulan Ini':
          return _calculateProfit(monthlyRevenue, monthlyExpense);
        case 'Tahun Ini':
          return _calculateProfit(yearlyRevenue, yearlyExpense);
        default:
          return _calculateProfit(weeklyRevenue, weeklyExpense);
      }
    }
  }

  // Calculation Method, untuk perhitungan data  
  // Menghitung profit dari revenue dan expense
  static List<SalesData> _calculateProfit(
    List<SalesData> revenue,
    List<SalesData> expense,
  ) {
    return revenue.asMap().entries.map((entry) {
      final index = entry.key;
      final rev = entry.value;
      final exp = expense[index];
      return SalesData(rev.day, rev.amount - exp.amount);
    }).toList();
  }

  // Menghitung total revenue berdasarkan periode
  static double getTotalRevenue(String selectedPeriod) {
    switch (selectedPeriod) {
      case 'Minggu Ini':
        return weeklyRevenue
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
      case 'Bulan Ini':
        return monthlyRevenue
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
      case 'Tahun Ini':
        return yearlyRevenue
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
      default:
        return weeklyRevenue
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
    }
  }

  // Menghitung total expense berdasarkan periode
  static double getTotalExpense(String selectedPeriod) {
    switch (selectedPeriod) {
      case 'Minggu Ini':
        return weeklyExpense
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
      case 'Bulan Ini':
        return monthlyExpense
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
      case 'Tahun Ini':
        return yearlyExpense
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
      default:
        return weeklyExpense
            .map((e) => e.amount)
            .reduce((a, b) => a + b)
            .toDouble();
    }
  }

  // Menghitung total profit berdasarkan periode
  static double getTotalProfit(String selectedPeriod) {
    return getTotalRevenue(selectedPeriod) - getTotalExpense(selectedPeriod);
  }

  // Mendapatkan nilai maksimum Y untuk chart scaling
  // Digunakan untuk menentukan batas atas chart
  static double getMaxY(List<SalesData> data) {
    return data.map((e) => e.amount.toDouble()).reduce((a, b) => a > b ? a : b);
  }

  // Formatting Method untuk formatting tampilan UI  
  // Format currency untuk tampilan compact
  // Contoh: 1,200,000 → "Rp 1.2 JT"
  //          15,000 → "Rp 15.0 RB"
  static String formatCurrency(int amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)} JT';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(1)} RB';
    }
    return 'Rp $amount';
  }

  // Format currency untuk tooltip chart
  // Menampilkan format angka dengan pemisah ribuan
  // Contoh: 1200000 → "1.200.000"
  static String formatTooltipCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  // Format untuk menyederhanakan tampilan angka besar di axis
  // Contoh: 1000000 → "1JT", 1500 → "1K"
  static String formatYAxis(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)}JT';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
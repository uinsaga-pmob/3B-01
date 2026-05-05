import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'statistik_data.dart'; // Import data dari statistik_data

// Halaman statistik menampilkan dashboard analitik dengan visualisasi data
// menggunakan package fl_chart untuk chart rendering
class StatistikPage extends StatefulWidget {
  const StatistikPage({super.key});

  @override
  State<StatistikPage> createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> {
  // State untuk menyimpan filter periode dan tipe chart yang aktif
  // Nilai default: 'Minggu Ini' dan 'Pendapatan'
  String _selectedPeriod = 'Minggu Ini';
  String _selectedChartType = 'Pendapatan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildFilterSection(), // Section dropdown filter
            const SizedBox(height: 16),
            _buildStatsCards(), // Card statistik ringkasan
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildChartSection(), // Chart batang interaktif
                    const SizedBox(height: 20),
                    _buildTopProductsSection(), // List produk terlaris
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menampilkan judul halaman dengan gradient background
  // dan decorative circles untuk visual enhancement
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
          // Decorative circle 1 
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative circle 2 
          Positioned(
            right: 25,
            bottom: -15,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Konten header: icon, title, dan subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
            child: Row(
              children: [
                // Icon container dengan border dan background transparan
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(64),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withAlpha(128),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    LucideIcons.barChart3,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Analitik Bisnis",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Statistik & Laporan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
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

  // Menampilkan dua dropdown untuk filter data:
  // 1. Periode waktu (Minggu/Bulan/Tahun)
  // 2. Tipe data (Pendapatan/Pengeluaran/Profit)
  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Dropdown filter periode
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  icon: const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                  ),
                  isExpanded: true,
                  items: StatisticsRepository.periods.map((period) {
                    return DropdownMenuItem<String>(
                      value: period,
                      child: Text(period, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPeriod = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Dropdown filter tipe chart
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedChartType,
                  icon: const Icon(LucideIcons.chevronDown, size: 16),
                  isExpanded: true,
                  items: StatisticsRepository.chartTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedChartType = newValue!;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan 3 card ringkasan statistik:
  // 1. Total Pendapatan
  // 2. Total Pengeluaran
  // 3. Total Profit
  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Pendapatan',
              StatisticsRepository.formatCurrency(
                StatisticsRepository.getTotalRevenue(_selectedPeriod).toInt(),
              ),
              LucideIcons.trendingUp,
              Colors.green,
              12.5, 
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total Pengeluaran',
              StatisticsRepository.formatCurrency(
                StatisticsRepository.getTotalExpense(_selectedPeriod).toInt(),
              ),
              LucideIcons.trendingDown,
              Colors.red,
              -5.2, 
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total Profit',
              StatisticsRepository.formatCurrency(
                StatisticsRepository.getTotalProfit(_selectedPeriod).toInt(),
              ),
              LucideIcons.dollarSign,
              Colors.blue,
              8.3, 
            ),
          ),
        ],
      ),
    );
  }

  // Widget reusable untuk menampilkan satu card statistik
  // Berisi icon, title, value, dan growth indicator
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    double growth,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          // Baris pertama: icon dan growth indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              // Growth indicator dengan warna conditional
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: growth >= 0
                      ? Colors.green.withAlpha(25)
                      : Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      growth >= 0 ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                      size: 12,
                      color: growth >= 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: growth >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Title dan value
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan bar chart interaktif berdasarkan
  // filter periode dan tipe data yang dipilih
  Widget _buildChartSection() {
    // Ambil data berdasarkan filter
    final data = StatisticsRepository.getCurrentData(
      _selectedPeriod,
      _selectedChartType,
    );
    // Tentukan warna berdasarkan tipe chart
    final color = _selectedChartType == 'Pendapatan'
        ? Colors.green
        : _selectedChartType == 'Pengeluaran'
            ? Colors.red
            : Colors.blue;

    return Container(
      padding: const EdgeInsets.all(16),
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
          // Header chart dengan title dan badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grafik $_selectedChartType - $_selectedPeriod',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // Badge tipe chart
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color.withAlpha(50)),
                ),
                child: Text(
                  _selectedChartType,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bar chart container
          SizedBox(
            height: 200,
            child: BarChart(_buildBarChartData(data, color)),
          ),
        ],
      ),
    );
  }

  // BAR CHART DATA BUILDER
  // Konfigurasi data dan styling untuk BarChart
  // Menggunakan fl_chart package
  BarChartData _buildBarChartData(List<SalesData> data, Color color) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: StatisticsRepository.getMaxY(data) * 1.1,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${data[groupIndex].day}\n',
              const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              children: [
                TextSpan(
                  text:
                      'Rp ${StatisticsRepository.formatTooltipCurrency(rod.toY)}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < data.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    data[index].day,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const Text('');
            },
            reservedSize: 32,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  StatisticsRepository.formatYAxis(value),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              );
            },
            reservedSize: 40,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: data.asMap().entries.map((entry) {
        final index = entry.key;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: entry.value.amount.toDouble(),
              color: color,
              width: _selectedPeriod == 'Tahun Ini' ? 8 : 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }).toList(),
      gridData: const FlGridData(show: false),
    );
  }

  // TOP PRODUCTS SECTION
  // Menampilkan list produk terlaris berdasarkan
  // jumlah penjualan dan revenue
  Widget _buildTopProductsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            'Produk Terlaris',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          // List produk menggunakan .asMap() untuk mendapatkan index
          ...StatisticsRepository.topProducts.asMap().entries.map(
            (entry) => _buildProductItem(entry.value, entry.key + 1),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan satu item produk dalam list
  // Menampilkan ranking, nama, sales, revenue, dan growth
  Widget _buildProductItem(ProductData product, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Ranking badge (top 3 dapat warna khusus)
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rank <= 3 ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: rank <= 3 ? Colors.blue.shade700 : Colors.grey.shade600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Informasi produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${product.sales} penjualan • ${StatisticsRepository.formatCurrency(product.revenue)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                // Tambahan informasi: Harga per unit dan margin
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Harga: ${StatisticsRepository.formatCurrency(product.unitPrice)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: product.growth >= 0
                            ? Colors.green.withAlpha(15)
                            : Colors.red.withAlpha(15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${product.growth >= 0 ? '+' : ''}${product.growth.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: product.growth >= 0
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontWeight: FontWeight.w600,
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
}
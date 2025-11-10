import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'statistik_data.dart'; // Import data statistik

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = 'Minggu Ini'; // Periode filter default
  String _selectedChartType = 'Pendapatan'; // Tipe chart default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD), 
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(), 
            const SizedBox(height: 16),
            _buildFilterSection(), // Section filter periode dan chart type
            const SizedBox(height: 16),
            _buildStatsCards(), // Cards statistik (pendapatan, pengeluaran, profit)
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildChartSection(), // Section chart utama
                    const SizedBox(height: 20),
                    _buildTopProductsSection(), // Section produk terlaris
                    const SizedBox(height: 20),
                    _buildCategoryDistribution(), // Section distribusi kategori
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
          Positioned(right: -10, top: -10, child: Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.white.withAlpha(51), shape: BoxShape.circle))),
          Positioned(right: 25, bottom: -15, child: Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withAlpha(38), shape: BoxShape.circle))),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(64), 
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withAlpha(128), width: 1.5),
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
  
  /// Fungsi Section filter untuk periode dan tipe chart
  /// Menyediakan dropdown untuk mengubah periode waktu dan jenis data yang ditampilkan
  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Dropdown filter periode (Minggu Ini, Bulan Ini, Tahun Ini)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200), // Border subtle
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  icon: const Icon(LucideIcons.chevronDown, size: 16), // Dropdown icon
                  isExpanded: true, // Menggunakan lebar penuh
                  items: StatisticsRepository.periods.map((period) {
                    return DropdownMenuItem<String>(
                      value: period,
                      child: Text(period, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _selectedPeriod = newValue!); // Update state saat nilai berubah
                  },
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Dropdown filter tipe chart (Pendapatan, Pengeluaran, Profit)
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
                    setState(() => _selectedChartType = newValue!); // Update state saat nilai berubah
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Menampilkan 3 card: Total Pendapatan, Total Pengeluaran, dan Total Profit
  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Total Pendapatan', StatisticsRepository.formatCurrency(StatisticsRepository.getTotalRevenue(_selectedPeriod).toInt()), LucideIcons.trendingUp, Colors.green, 12.5)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Total Pengeluaran', StatisticsRepository.formatCurrency(StatisticsRepository.getTotalExpense(_selectedPeriod).toInt()), LucideIcons.trendingDown, Colors.red, -5.2)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Total Profit', StatisticsRepository.formatCurrency(StatisticsRepository.getTotalProfit(_selectedPeriod).toInt()), LucideIcons.dollarSign, Colors.blue, 8.3)),
        ],
      ),
    );
  }

  /// Menampilkan: icon, title, value, dan persentase growth
  Widget _buildStatCard(String title, String value, IconData icon, Color color, double growth) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 2))], 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon container dengan background color
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 16),
              ),
              // Growth indicator dengan warna conditional (hijau/merah)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: growth >= 0 ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(growth >= 0 ? LucideIcons.arrowUp : LucideIcons.arrowDown, size: 12, color: growth >= 0 ? Colors.green : Colors.red),
                    const SizedBox(width: 2),
                    Text('${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: growth >= 0 ? Colors.green : Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)), // Value dengan color sesuai konteks
        ],
      ),
    );
  }

  /// Menampilkan grafik batang berdasarkan periode dan tipe chart yang dipilih
  Widget _buildChartSection() {
    final data = StatisticsRepository.getCurrentData(_selectedPeriod, _selectedChartType);
    final color = _selectedChartType == 'Pendapatan' ? Colors.green : _selectedChartType == 'Pengeluaran' ? Colors.red : Colors.blue;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grafik $_selectedChartType - $_selectedPeriod', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              // Badge untuk tipe chart
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(6), border: Border.all(color: color.withAlpha(50))),
                child: Text(_selectedChartType, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // BarChart container
          SizedBox(
            height: 200,
            child: BarChart(_buildBarChartData(data, color)),
          ),
        ],
      ),
    );
  }

  /// Mengatur: tooltip, titles, colors, dan bar groups
  BarChartData _buildBarChartData(List<SalesData> data, Color color) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround, // Spasi merata antar bar
      maxY: StatisticsRepository.getMaxY(data) * 1.1, // Max Y dengan margin 10%
      barTouchData: BarTouchData(
        enabled: true, // Enable touch interaction
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.white,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${data[groupIndex].day}\n', // Day label
              const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
              children: [
                TextSpan(
                  text: 'Rp ${StatisticsRepository.formatTooltipCurrency(rod.toY)}', // Value formatted
                  style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
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
                  child: Text(data[index].day, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)), // Day labels
                );
              }
              return const Text('');
            },
            reservedSize: 32, // Space untuk bottom titles
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(StatisticsRepository.formatYAxis(value), style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500), textAlign: TextAlign.right), 
              );
            },
            reservedSize: 40, // Space untuk left titles
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false), // No border
      barGroups: data.asMap().entries.map((entry) {
        final index = entry.key;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: entry.value.amount.toDouble(), // Bar height berdasarkan amount
              color: color,
              width: _selectedPeriod == 'Tahun Ini' ? 8 : 16, // Lebar bar berbeda berdasarkan periode
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }).toList(),
      gridData: const FlGridData(show: false), // No grid lines
    );
  }

  /// Menampilkan ranking produk berdasarkan penjualan
  Widget _buildTopProductsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Produk Terlaris', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 12),
          // List produk terlaris
          ...StatisticsRepository.topProducts.asMap().entries.map((entry) => _buildProductItem(entry.value, entry.key + 1)),
        ],
      ),
    );
  }

  /// Menampilkan: ranking, nama produk, jumlah penjualan, revenue, dan growth
  Widget _buildProductItem(ProductData product, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          // Ranking badge dengan warna conditional untuk top 3
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(color: rank <= 3 ? Colors.blue.shade100 : Colors.grey.shade200, borderRadius: BorderRadius.circular(6)),
            child: Center(
              child: Text(rank.toString(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: rank <= 3 ? Colors.blue.shade700 : Colors.grey.shade600)),
            ),
          ),
          const SizedBox(width: 12),
          // Product information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 2),
                Text('${product.sales} penjualan • ${StatisticsRepository.formatCurrency(product.revenue)}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          // Growth indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: product.growth >= 0 ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(product.growth >= 0 ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 12, color: product.growth >= 0 ? Colors.green : Colors.red),
                const SizedBox(width: 2),
                Text('${product.growth.toStringAsFixed(1)}%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: product.growth >= 0 ? Colors.green : Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Menampilkan pie chart dan legend untuk persentase kategori
  Widget _buildCategoryDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Distribusi Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(flex: 3, child: PieChart(_buildPieChartData())), // Pie chart
                Expanded(flex: 2, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: StatisticsRepository.categoryData.map(_buildCategoryLegend).toList())), // Legend
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Mengatur sections, colors, dan labels untuk pie chart
  PieChartData _buildPieChartData() {
    return PieChartData(
      sections: StatisticsRepository.categoryData.map((data) {
        return PieChartSectionData(
          color: data.color, // Warna dari data kategori
          value: data.percentage, // Nilai persentase
          title: '${data.percentage}%', // Label persentase
          radius: 40, // Radius section
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), // Style label
        );
      }).toList(),
      sectionsSpace: 2, // Spasi antar section
      centerSpaceRadius: 40, // Radius center hole
      startDegreeOffset: -90, // Rotasi mulai dari atas
    );
  }

  /// Menampilkan color indicator, nama kategori, dan persentase
  Widget _buildCategoryLegend(CategoryData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: data.color, shape: BoxShape.circle)), // Color indicator
          const SizedBox(width: 8),
          Expanded(child: Text(data.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))), // Category name
          Text('${data.percentage}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), 
        ],
      ),
    );
  }
}
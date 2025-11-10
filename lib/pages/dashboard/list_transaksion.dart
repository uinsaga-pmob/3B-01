import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Data transaksi untuk hari ini
final List<Map<String, dynamic>> todayTransactions = [
  {
    'title': 'Penjualan Kopi Susu',
    'date': '13 Oktober 2025, 10.30',
    'amount': 120000,
    'isIncome': true, // Flag untuk pemasukan
  },
  {
    'title': 'Penjualan Americano',
    'date': '13 Oktober 2025, 10.30',
    'amount': 125000,
    'isIncome': true,
  },
  {
    'title': 'Beli Stok Bensin',
    'date': '13 Oktober 2025, 07.00',
    'amount': 650000,
    'isIncome': false, // Flag untuk pengeluaran
  },
];

// Data semua transaksi (histori lengkap)
final List<Map<String, dynamic>> allTransactions = [
  {
    'title': 'Penjualan Latte',
    'date': '10 Oktober 2025, 09.15',
    'amount': 84000,
    'isIncome': true,
  },
  {
    'title': 'Beli Token Listrik',
    'date': '7 Oktober 2025, 08.30',
    'amount': 340000,
    'isIncome': false,
  },
  {
    'title': 'Bayar Gaji Karyawan',
    'date': '3 Oktober 2025, 08.30',
    'amount': 480000,
    'isIncome': false,
  },
  {
    'title': 'Penjualan Latte',
    'date': '10 Oktober 2025, 09.15',
    'amount': 84000,
    'isIncome': true,
  },
];

// Widget untuk menampilkan list transaksi
class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final bool showToday;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.showToday,
  });

  @override
  Widget build(BuildContext context) {
    // Conditional rendering: tampilkan empty state atau list transaksi
    return transactions.isEmpty
        ? _buildEmptyState(showToday)
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final trx = transactions[index];
              return _buildTransactionCard(
                trx['title'],
                trx['date'],
                trx['amount'],
                trx['isIncome'],
              );
            },
          );
  }

  // Method untuk membangun card transaksi individual
  Widget _buildTransactionCard(String title, String date, int amount, bool isIncome) {
    final color = isIncome ? Colors.green : Colors.red; // Warna hijau/merah
    final icon = isIncome ? LucideIcons.arrowUpRight : LucideIcons.arrowDownLeft;
    final category = isIncome ? 'Pemasukan' : 'Pengeluaran';

    return Container(
      margin: const EdgeInsets.only(bottom: 12), // Spasi antar card
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100, // Shadow subtle
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100), // Border subtle
      ),
      child: Row(
        children: [
          // Icon container dengan background color
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(25), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Content area (title, date, category)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        category,
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
          // Amount dan status section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'} ${_formatCurrency(amount)}', // Symbol +/-
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isIncome ? 'Berhasil' : 'Dibayar', // Status text
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk state kosong (empty state)
  Widget _buildEmptyState(bool showToday) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.fileText,
            size: 64,
            color: Colors.grey.shade300, // Icon color subtle
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada transaksi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          // Pesan kontekstual berdasarkan filter
          Text(
            showToday ? 'Tidak ada transaksi hari ini' : 'Belum ada transaksi',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // Method untuk format currency Rupiah
  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.', // Tambahkan titik sebagai separator ribuan
    )}';
  }
}
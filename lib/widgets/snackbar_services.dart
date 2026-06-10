// lib/services/snackbar_service.dart (Versi Alternatif - Tidak perlu ubah main.dart)
import 'package:flutter/material.dart';

class SnackbarService {
  /// Menampilkan SnackBar di bawah AppBar
  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    IconData? icon,
    int durationInSeconds = 3,
    SnackBarAction? action,
  }) {
    // Hilangkan SnackBar yang sedang tampil
    ScaffoldMessenger.of(context).clearSnackBars();

    // Dapatkan tinggi AppBar
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final topOffset = appBarHeight + statusBarHeight;

    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(top: topOffset + 8, left: 16, right: 16),
      duration: Duration(seconds: durationInSeconds),
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void success({
    required BuildContext context,
    required String message,
    int durationInSeconds = 2,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_rounded,
      durationInSeconds: durationInSeconds,
    );
  }

  static void error({
    required BuildContext context,
    required String message,
    int durationInSeconds = 3,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_rounded,
      durationInSeconds: durationInSeconds,
    );
  }

  static void warning({
    required BuildContext context,
    required String message,
    int durationInSeconds = 3,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.orange.shade600,
      icon: Icons.warning_rounded,
      durationInSeconds: durationInSeconds,
    );
  }

  static void info({
    required BuildContext context,
    required String message,
    int durationInSeconds = 2,
  }) {
    show(
      context: context,
      message: message,
      backgroundColor: Colors.blue.shade600,
      icon: Icons.info_rounded,
      durationInSeconds: durationInSeconds,
    );
  }
}

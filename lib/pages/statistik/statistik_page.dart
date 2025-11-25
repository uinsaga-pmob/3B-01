import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class StatistikPage extends StatelessWidget{
  const StatistikPage ({super.key});

  final _titleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.1, 
  );

  final _subtitleStyle = const TextStyle(
    color: Color(0xC8FFFFFF), 
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.2, 
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
          child:Column(
            children: [
            
            _buildHeader(),

            const SizedBox(height: 20),

            const Expanded(
              child: Center(
                child: Text('Halaman Statistik'),
              ),
            ),
          ],
        ),
      )
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
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(right: -10, top: -10, child: _buildCircle(70)),
          Positioned(right: 25, bottom: -15, child: _buildCircle(50)),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Row(
              children: [
                // Icon box
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
                  child: const Icon(LucideIcons.barChart, color: Colors.white),
                ),

                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Halaman Statistik", style: _titleStyle),
                      const SizedBox(height: 6),
                      Text("Pantau data dan grafik statistik", style: _subtitleStyle),
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

  Widget _buildCircle(double size) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: Colors.white.withAlpha(size == 70 ? 51 : 38), 
      shape: BoxShape.circle, 
    ),
  );
}

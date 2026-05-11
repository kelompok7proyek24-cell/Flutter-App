// lib/features/profile/presentation/widgets/order_status_card.dart

import 'package:flutter/material.dart';

class OrderStatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  
  // --- 1. BARU: Tambahkan Callback untuk Navigasi ---
  final VoidCallback? onTap;

  const OrderStatusCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap, // Tambahkan di constructor
  });

  @override
  Widget build(BuildContext context) {
    // --- 2. BARU: Bungkus dengan InkWell untuk Interaksi ---
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // Agar efek ripple rapi
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
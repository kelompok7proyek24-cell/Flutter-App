// order_status_card.dart

import 'package:flutter/material.dart';

class OrderStatusCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const OrderStatusCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
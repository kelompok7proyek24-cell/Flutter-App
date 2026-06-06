// Path: lib/features/seller/presentation/widgets/inventory_item_tile.dart

import 'package:flutter/material.dart';

class InventoryItemTile extends StatelessWidget {
  final String productName;
  final String price;
  final String stockText;
  final String imagePath;
  final String status;

  const InventoryItemTile({
    super.key,
    required this.productName,
    required this.price,
    required this.stockText,
    required this.imagePath,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor = Colors.green;
    if (status == "danger") badgeColor = Colors.red;
    if (status == "warning") badgeColor = Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: const Color(0xffF7F9FC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 50,
                height: 50,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 20),
              );
            },
          ),
        ),
        title: Text(
          productName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            Text(
              price,
              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                stockText,
                style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        trailing: const Icon(Icons.more_vert, size: 18),
      ),
    );
  }
}
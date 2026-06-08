class CartItemModel {
  final String id;
  final String name;
  final int price;
  final String imagePath;
  int quantity; // Tidak final karena nilainya akan berubah (tambah/kurang)

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    this.quantity = 1, // Default awal ditambahkan adalah 1
  });
}
// Path: lib/features/cart/data/models/cart_item_model.dart

class CartItemModel {
  final String id;
  final String name;
  final String variant;      // Menyimpan informasi varian produk (misal: "Jantan", "Betina", "Normal")
  final int price;
  final String imagePath;
  final String shopName;     // Nama toko/seller untuk keperluan pengelompokan di keranjang
  int quantity;              // Tidak final karena nilainya akan berubah (tambah/kurang) via UI
  bool isChecked;            // Menyimpan status seleksi checkbox di halaman keranjang

  CartItemModel({
    required this.id,
    required this.name,
    required this.variant,
    required this.price,
    required this.imagePath,
    required this.shopName,
    this.quantity = 1,       // Default kuantitas awal saat produk masuk keranjang
    this.isChecked = true,   // Default awal otomatis tercentang (aktif) saat dimuat
  });
}
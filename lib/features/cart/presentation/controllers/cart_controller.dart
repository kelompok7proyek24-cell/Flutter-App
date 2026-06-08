// features/cart/presentation/controllers/cart_controller.dart
import 'package:ikanku/features/cart/data/models/cart_item_model.dart'; 

class CartController {
  // Pola Singleton agar instance-nya tunggal di seluruh aplikasi
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  // List untuk menampung item di keranjang
  final List<CartItemModel> _cartItems = [];

  // Getter untuk mengambil seluruh item di keranjang
  List<CartItemModel> get items => _cartItems;

  /// Fungsi untuk menambahkan produk ke dalam keranjang belanja
  void addToCart({
    required String id, 
    required String name, 
    required int price, 
    required String image,
  }) {
    // Cek apakah produk tersebut sudah ada di keranjang atau belum
    int index = _cartItems.indexWhere((item) => item.id == id);

    if (index != -1) {
      // Jika sudah ada, cukup tambahkan kuantitasnya
      _cartItems[index].quantity++;
    } else {
      // Jika belum ada, masukkan sebagai item baru
      _cartItems.add(CartItemModel(
        id: id, 
        name: name, 
        price: price, 
        imagePath: image, 
        quantity: 1, 
        variant: 'Normal', 
        shopName: 'Arwana Shop',
        isChecked: true, // Otomatis tercentang saat pertama kali masuk keranjang
      ));
    }
  }

  /// REKAYASA SISTEM: Menghapus item yang sudah berhasil di-checkout (yang dicentang)
  void clearCheckedItems() {
    _cartItems.removeWhere((item) => item.isChecked);
  }

  /// REKAYASA SISTEM: Kalkulasi otomatis total harga HANYA untuk item yang dicentang pengguna
  int get totalPrice {
    return _cartItems
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// Optional Helper: Menghitung total barang yang dicentang saja untuk info di bottom bar UI
  int get totalCheckedItems {
    return _cartItems
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + item.quantity);
  }
}
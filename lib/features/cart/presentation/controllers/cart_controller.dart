// features/cart/presentation/controllers/cart_controller.dart
import 'package:ikanku/features/cart/data/models/cart_item_model.dart'; // Jalur relatif harus tepat ke lokasi file model Anda

class CartController {
  // Pola Singleton agar instance-nya tunggal di seluruh aplikasi
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  // List untuk menampung item di keranjang
  final List<CartItemModel> _cartItems = [];

  List<CartItemModel> get items => _cartItems;

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
      // Jika belum ada, masukkan sebagai item baru (Pastikan parameter konstruktor CartItemModel sesuai)
      _cartItems.add(CartItemModel(
        id: id, 
        name: name, 
        price: price, 
        imagePath: image, // Sesuaikan dengan nama variabel di konstruktor CartItemModel Anda (misal: imagePath atau image)
        quantity: 1,      // Inisialisasi kuantitas pertama kali masuk keranjang
      ));
    }
  }

  int get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Fungsi Simpan
  static Future<void> saveCart(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cart_count', count);
  }

  // Fungsi Ambil
  static Future<int> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('cart_count') ?? 0;
  }
}
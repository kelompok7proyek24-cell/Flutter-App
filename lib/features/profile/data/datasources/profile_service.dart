import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileService {
  static const String _userKey = 'user_profile_data';

  // FUNGSI MENYIMPAN DATA (WRITE)
  static Future<void> saveProfile(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // Mengubah Map menjadi String JSON tebal
    String jsonString = jsonEncode(user.toMap());
    await prefs.setString(_userKey, jsonString);
  }

  // FUNGSI MENGAMBIL DATA (READ)
  static Future<UserModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_userKey);

    if (jsonString != null) {
      Map<String, dynamic> map = jsonDecode(jsonString);
      return UserModel.fromMap(map);
    }

    // Data Fallback awal jika database lokal masih kosong
    return UserModel(
      name: "Azani Sakti Sya'Ban Rifa'I",
      email: "azani.sak@email.com",
      phone: "081234567890",
      address: "Jl. Raya Lohbener Blok Remis, No. 15, Kec. Lohbener, Kabupaten Indramayu, Jawa Barat 45252",
      profileImagePath: null, // Default kosong (akan menampilkan ikon/gambar aset bawaan)
      paymentMethod: "Transfer Bank (VA)",
    );
  }
}
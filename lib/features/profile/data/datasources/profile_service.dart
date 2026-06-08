// profile_service.dart

import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileService {
  static const String _userKey = 'user_profile_data';

  // FUNGSI MENYIMPAN DATA (WRITE)
  static Future<void> saveProfile(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // PERBAIKAN: Menggunakan .toJson() sesuai dengan struktur model baru
    String jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
  }

  // FUNGSI MENGAMBIL DATA (READ)
  static Future<UserModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_userKey);

    if (jsonString != null) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      // PERBAIKAN: Menggunakan .fromJson() sesuai dengan struktur model baru
      return UserModel.fromJson(json);
    }

    // --- DATA FALLBACK UTAMA (Jika Penyimpanan Lokal Masih Kosong) ---
    return UserModel(
      name: "Azani Sakti Sya'Ban Rifa'I",
      email: "azanisaktisr@email.com",
      password: "", // Mengantisipasi pengecekan di awal pada LoginPage
      phone: "081224324812",
      profileImagePath: "", // Diubah ke String kosong (bukan null) agar aman di model
      paymentMethod: "Transfer Bank (VA)",
      // PERBAIKAN: Data alamat lama dikoversikan ke format komponen AddressModel baru
      addresses: [
        AddressModel(
          id: "default-alamat-1",
          label: "Rumah",
          receiverName: "Azani Sakti Sya'Ban Rifa'I",
          phone: "+62 812-2432-4812",
          cityAndSubdistrict: "Lohbener, Indramayu",
          postalCode: "45252",
          detailAddress: "Jl. Raya Lohbener Blok Remis, No. 15, Kec. Lohbener, Kabupaten Indramayu, Jawa Barat",
          notesForCourier: "Titip di security jika tidak ada orang",
          isMain: true, // Otomatis menjadi alamat utama default di sistem
        ),
      ],
    );
  }

  static Future<void> becomeSeller({required storeName, required category}) async {}
}
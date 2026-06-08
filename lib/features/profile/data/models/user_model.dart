class UserModel {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? profileImagePath; // Menyimpan path internal dari file gambar yang diupload
  final String paymentMethod;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImagePath,
    required this.paymentMethod,
  });

  // MENGUBAH OBJEK KE MAP (JSON) agar bisa disimpan ke SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'profileImagePath': profileImagePath,
      'paymentMethod': paymentMethod,
    };
  }

  // MEMBACA MAP (JSON) DAN MENGUBAHNYA KEMBALI MENJADI OBJEK USERMODEL
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      profileImagePath: map['profileImagePath'],
      paymentMethod: map['paymentMethod'] ?? 'Belum Diatur',
    );
  }
}
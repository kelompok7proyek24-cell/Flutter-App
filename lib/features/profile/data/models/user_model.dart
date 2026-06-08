// user_model.dart

class AddressModel {
  final String id;
  final String label; // Rumah, Kantor, Apartemen
  final String receiverName;
  final String phone;
  final String cityAndSubdistrict;
  final String postalCode;
  final String detailAddress;
  final String notesForCourier;
  final bool isMain;

  AddressModel({
    required this.id,
    required this.label,
    required this.receiverName,
    required this.phone,
    required this.cityAndSubdistrict,
    required this.postalCode,
    required this.detailAddress,
    this.notesForCourier = "",
    this.isMain = false,
  });

  // Konversi dari Objek ke Map JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'receiverName': receiverName,
        'phone': phone,
        'cityAndSubdistrict': cityAndSubdistrict,
        'postalCode': postalCode,
        'detailAddress': detailAddress,
        'notesForCourier': notesForCourier,
        'isMain': isMain,
      };

  // Konversi Balik dari Map JSON ke Objek
  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'] ?? '',
        label: json['label'] ?? 'Rumah',
        receiverName: json['receiverName'] ?? '',
        phone: json['phone'] ?? '',
        cityAndSubdistrict: json['cityAndSubdistrict'] ?? '',
        postalCode: json['postalCode'] ?? '',
        detailAddress: json['detailAddress'] ?? '',
        notesForCourier: json['notesForCourier'] ?? '',
        isMain: json['isMain'] ?? false,
      );
}

class UserModel {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String? profileImagePath; // Diperbolehkan null jika belum upload foto
  final String paymentMethod;
  final List<AddressModel> addresses;

  // --- TAMBAHAN PROPERTI FITUR SELLER ---
  final bool isSeller;
  final String? shopName;
  final String? shopCity;
  final String? shopAddress;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.profileImagePath,
    required this.paymentMethod,
    required this.addresses,
    this.isSeller = false, // Default awal akun baru adalah false
    this.shopName,
    this.shopCity,
    this.shopAddress,
  });

  // Pembaruan Method Serialisasi menggunakan nama toJson()
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'profileImagePath': profileImagePath,
        'paymentMethod': paymentMethod,
        'addresses': addresses.map((e) => e.toJson()).toList(),
        // Mapping Field Baru
        'isSeller': isSeller,
        'shopName': shopName,
        'shopCity': shopCity,
        'shopAddress': shopAddress,
      };

  // Pembaruan Method Deserialisasi menggunakan nama fromJson()
  factory UserModel.fromJson(Map<String, dynamic> json) {
    var addressList = json['addresses'] as List? ?? [];
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      profileImagePath: json['profileImagePath'],
      paymentMethod: json['paymentMethod'] ?? '',
      addresses: addressList.map((e) => AddressModel.fromJson(e)).toList(),
      // Deserialisasi Field Baru dengan Fallback Value yang aman
      isSeller: json['isSeller'] ?? false,
      shopName: json['shopName'],
      shopCity: json['shopCity'],
      shopAddress: json['shopAddress'],
    );
  }

  // Method duplikasi objek untuk mempermudah mutasi data secara parsial
  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? profileImagePath,
    String? paymentMethod,
    List<AddressModel>? addresses,
    bool? isSeller,
    String? shopName,
    String? shopCity,
    String? shopAddress,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      addresses: addresses ?? this.addresses,
      isSeller: isSeller ?? this.isSeller,
      shopName: shopName ?? this.shopName,
      shopCity: shopCity ?? this.shopCity,
      shopAddress: shopAddress ?? this.shopAddress,
    );
  }
}
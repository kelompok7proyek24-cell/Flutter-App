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
  final List<AddressModel> addresses; // <-- INI DIA YANG MEMBUAT ERROR JIKA HILANG

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.profileImagePath,
    required this.paymentMethod,
    required this.addresses,
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
    );
  }
}
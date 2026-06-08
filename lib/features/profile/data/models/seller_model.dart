// lib/features/seller/data/models/seller_model.dart

class SellerModel {
  String storeName;
  String username;
  String description;
  String phoneNumber;
  String profileImageUrl;
  String bannerImageUrl;

  SellerModel({
    required this.storeName,
    required this.username,
    required this.description,
    required this.phoneNumber,
    required this.profileImageUrl,
    required this.bannerImageUrl,
  });
}

// Data Dummy sesuai screenshot
SellerModel dummySeller = SellerModel(
  storeName: "Aquatic Premium Jakarta",
  username: "@aquatic.premium",
  description: "Spesialis ikan hias premium dan aksesoris aquarium terlengkap sejak 2018...",
  phoneNumber: "+62 812-3456-7890",
  profileImageUrl: "assets/images/seller_profile.png",
  bannerImageUrl: "assets/images/seller_banner.png",
);
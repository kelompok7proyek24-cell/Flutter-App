// lib/features/seller/data/models/store_model.dart

class StoreModel {
  final String storeName;
  final String description;
  final String bankName;
  final String bankAccountNumber;
  final String bankAccountName;
  final String pickupAddress;

  StoreModel({
    required this.storeName,
    required this.description,
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.pickupAddress,
  });

  // Salin data lama dengan perubahan spesifik
  StoreModel copyWith({
    String? storeName,
    String? description,
    String? bankName,
    String? bankAccountNumber,
    String? bankAccountName,
    String? pickupAddress,
  }) {
    return StoreModel(
      storeName: storeName ?? this.storeName,
      description: description ?? this.description,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      pickupAddress: pickupAddress ?? this.pickupAddress,
    );
  }
}
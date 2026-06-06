// Path: lib/features/seller/data/models/product_model.dart

class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String imagePath;
  final String description;
  final double rating;
  final int reviewCount;
  final String status; // 'normal', 'warning', 'danger' (low stock)

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.imagePath,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.status,
  });
}

// =========================================================================
// DATA DUMMY FULL AKSES (Daftar Produk Ikan Sesuai Direktori Aset)
// =========================================================================
List<ProductModel> dummyProducts = [
  // -----------------------------------------------------------------------
  // KATEGORI: ARWANA
  // -----------------------------------------------------------------------
  ProductModel(
    id: "PROD-ARW-001",
    name: "Arwana Super Red Exotic",
    category: "Arwana",
    price: 4500000,
    stock: 3,
    imagePath: "assets/images/categories/arwana/arwana_super_red.jpg",
    description: "Arwana Super Red kualitas kontes, ring warna merah pekat menyala. Sehat, aktif, mental berani.",
    rating: 4.9,
    reviewCount: 12,
    status: "warning",
  ),
  ProductModel(
    id: "PROD-ARW-002",
    name: "Arwana Silver Platinum",
    category: "Arwana",
    price: 350000,
    stock: 12,
    imagePath: "assets/images/categories/arwana/arwana_silver.jpg",
    description: "Arwana Silver dengan sisik mengkilap bersih. Makan lahap (jangkrik/ulat jerman), ukuran sekitar 20cm.",
    rating: 4.7,
    reviewCount: 24,
    status: "normal",
  ),

  // -----------------------------------------------------------------------
  // KATEGORI: GUPPY
  // -----------------------------------------------------------------------
  ProductModel(
    id: "PROD-GUP-001",
    name: "Guppy Albino Full Red (AFR)",
    category: "Guppy",
    price: 35000,
    stock: 150,
    imagePath: "assets/images/categories/guppy/guppy_albino_full_red.jpg",
    description: "Sepasang Guppy AFR usia mapan. Ekor lebar, warna merah solid merata dari kepala hingga ujung sirip.",
    rating: 4.8,
    reviewCount: 110,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-GUP-002",
    name: "Guppy Blue Sky Grade A",
    category: "Guppy",
    price: 40000,
    stock: 2,
    imagePath: "assets/images/categories/guppy/guppy_blue_sky.jpg",
    description: "Guppy Blue Sky dengan warna biru langit transparan yang anggun. Stok sangat terbatas (Low Stock).",
    rating: 4.9,
    reviewCount: 8,
    status: "danger",
  ),
  ProductModel(
    id: "PROD-GUP-003",
    name: "Guppy Green Moscow Pair",
    category: "Guppy",
    price: 30000,
    stock: 45,
    imagePath: "assets/images/categories/guppy/guppy_green_moscow.jpg",
    description: "Guppy Green Moscow original breed. Memancarkan warna hijau metalik saat terkena pencahayaan aquarium.",
    rating: 4.6,
    reviewCount: 35,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-GUP-004",
    name: "Guppy Half Black (HB) White",
    category: "Guppy",
    price: 25000,
    stock: 60,
    imagePath: "assets/images/categories/guppy/guppy_hb_white.jpg",
    description: "Guppy HB White per pasang. Kombinasi kontras warna hitam di setengah badan belakang dan ekor putih bersih.",
    rating: 4.5,
    reviewCount: 42,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-GUP-005",
    name: "Guppy Red Dragon High Quality",
    category: "Guppy",
    price: 50000,
    stock: 18,
    imagePath: "assets/images/categories/guppy/guppy_red_dragon.jpg",
    description: "Guppy Red Dragon dengan corak sisik naga yang tegas dan ekor lebar bertipe big ear.",
    rating: 4.9,
    reviewCount: 19,
    status: "normal",
  ),

  // -----------------------------------------------------------------------
  // KATEGORI: KOKI
  // -----------------------------------------------------------------------
  ProductModel(
    id: "PROD-KOK-001",
    name: "Ikan Koki Oranda Red White",
    category: "Koki",
    price: 75000,
    stock: 25,
    imagePath: "assets/images/categories/koki/koki_oranda.jpg",
    description: "Koki Oranda jambul mekar proporsional. Pola warna merah-putih seimbang, bentuk tubuh bulat sehat.",
    rating: 4.8,
    reviewCount: 54,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-KOK-002",
    name: "Ikan Koki Kaliko/General Premium",
    category: "Koki",
    price: 60000,
    stock: 1,
    imagePath: "assets/images/categories/koki/koki_general.jpg",
    description: "Ikan Mas Koki variasi umum dengan corak panca warna (kaliko). Tersisa 1 ekor display utama.",
    rating: 4.7,
    reviewCount: 30,
    status: "danger",
  ),

  // -----------------------------------------------------------------------
  // KATEGORI: MOLLY
  // -----------------------------------------------------------------------
  ProductModel(
    id: "PROD-MOL-001",
    name: "Molly Balon Black Lyretail",
    category: "Molly",
    price: 6000,
    stock: 200,
    imagePath: "assets/images/categories/molly/molly_balon_black_lyretail.jpg",
    description: "Molly balon hitam pekat (Jet Black) dengan ekor menyerupai kecapi (Lyretail). Sangat adaptif.",
    rating: 4.6,
    reviewCount: 150,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-MOL-002",
    name: "Molly Balon Calico Roundtail",
    category: "Molly",
    price: 7000,
    stock: 85,
    imagePath: "assets/images/categories/molly/molly_balon_calico_round_tail.jpg",
    description: "Molly balon bermotif macan/kaliko bintik hitam orange. Ekor bulat rapi, cocok untuk kolam maupun tank.",
    rating: 4.7,
    reviewCount: 64,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-MOL-003",
    name: "Molly Balon Merpati Thailand Lyretail",
    category: "Molly",
    price: 12000,
    stock: 40,
    imagePath: "assets/images/categories/molly/molly_balon_merpati_thailand_lyretail.jpg",
    description: "Molly impor jenis Merpati Thailand, warna dasar putih silver lembut dengan ekor cagak panjang.",
    rating: 4.9,
    reviewCount: 22,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-MOL-004",
    name: "Molly Balon Platinum Roundtail",
    category: "Molly",
    price: 8000,
    stock: 110,
    imagePath: "assets/images/categories/molly/molly_balon_platinum_round_tail.jpg",
    description: "Molly balon warna putih susu mengkilap mutiara (Platinum). Menambah cerah susunan isi aquarium.",
    rating: 4.5,
    reviewCount: 95,
    status: "normal",
  ),
  ProductModel(
    id: "PROD-MOL-005",
    name: "Molly Balon Sunkist Lyretail",
    category: "Molly",
    price: 6000,
    stock: 5,
    imagePath: "assets/images/categories/molly/molly_balon_sunkist_lyretail.jpg",
    description: "Molly balon warna oranye cerah seperti buah jeruk sunkist. Menghidupkan suasana tank.",
    rating: 4.8,
    reviewCount: 102,
    status: "warning",
  ),
];
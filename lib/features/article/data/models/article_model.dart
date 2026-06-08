class ArticleModel {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String imagePath;

  ArticleModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.imagePath,
  });
}

// DATA DUMMY GLOBAL: Siap dipanggil di Home maupun Halaman Artikel
final List<ArticleModel> dummyArticles = [
  ArticleModel(
    id: "a1",
    title: "Menjaga Ekosistem Akuarium",
    subtitle: "Cara mudah mengatur pH air untuk ikan hias.",
    imagePath: "", // Kosong agar otomatis beralih ke icon eco bawaan
    content: """Derajat keasaman (pH) air adalah indikator krusial dalam ekosistem akuarium yang sering diabaikan oleh pemula. Sebagian besar ikan hias air tawar tumbuh optimal pada kisaran pH 6,5 hingga 7,5. Perubahan pH yang mendadak dapat menghancurkan lapisan lendir pelindung pada kulit ikan, memicu stres, hingga menyebabkan kematian massal.

Cara Mengukur dan Menjaga Stabilitas pH:
1. Pengujian Berkala: Gunakan pH meter digital atau cairan indikator (drop test kit) minimal satu minggu sekali.
2. Menurunkan pH secara Alami: Jika air keran terlalu basa (pH > 8), gunakan daun ketapang kering atau batang kayu rasamala. Senyawa tanin yang dilepaskan secara perlahan akan menurunkan pH dengan aman.
3. Menaikkan pH secara Aman: Untuk air yang terlalu asam (pH < 6), tambahkan substrat pecahan karang jahe (coral chip) di dalam filter.

Blind Spot Filterisasi: Jangan mengandalkan obat kimia pH Up atau pH Down instan dalam jangka panjang jika sistem biologis filtermu belum matang.""",
  ),
  ArticleModel(
    id: "a2",
    title: "Nutrisi Tepat Ikan Arwana",
    subtitle: "Jenis pakan alami untuk mempercepat mutasi warna merah.",
    imagePath: "",
    content: """Mencapai warna merah menyala (Super Red) pada ikan Arwana tidak hanya bergantung pada genetik tulen dan kualitas lampu, melainkan sangat dipengaruhi oleh zat kromatofor yang diserap dari nutrisi pakan sehari-hari. Zat pemicu warna merah ini dikenal sebagai Astaxanthin.

Variasi Komponen Pakan Terbaik:
1. Udang Segar: Sumber alami Astaxanthin tertinggi. Kulit udang mengandung kitin dan pigmen merah yang sangat baik untuk mempertegas ring warna pada sisik.
2. Kelabang: Dipercaya sebagai stimulan yang mempercepat keluarnya warna merah berkat kandungan racun dosis rendah yang memicu metabolisme ikan.
3. Katak Sawah Kecil: Sangat baik untuk mengejar pertumbuhan fisik (growth) dan mempertebal volume badan Arwana.

Manajemen Nutrisi: Selalu lakukan variasi pakan. Mengandalkan satu jenis pakan saja akan membuat Arwana kekurangan vitamin esensial tertentu.""",
  ),
  ArticleModel(
    id: "a3",
    title: "Budidaya Cepat Ikan Guppy",
    subtitle: "Panduan dasar mengawinkan indukan guppy strain murni.",
    imagePath: "",
    content: """Ikan Guppy (Poecilia reticulata) terkenal sangat mudah berkembang biak. Namun, membudidayakan guppy strain murni (Pure Strain) seperti Albino Full Red (AFR) membutuhkan ketelitian sistematis agar kualitas ekor dan warna anakan tidak mengalami degradasi genetik.

Tahapan Sistem Budidaya:
1. Seleksi Indukan: Pilih pejantan berusia 3-4 bulan yang memiliki gaya renang stabil. Untuk betina, pilih yang berbadan tebal dan dipastikan masih perawan dari lubuk pemisahan sebelumnya.
2. Rasio Perkawinan: Gunakan sistem mass breeding terkontrol dengan rasio 1 Jantan : 2 Betina di dalam wadah berukuran minimal 20 liter air.
3. Proses Kelahiran: Guppy adalah hewan ovovivipar (bertelur-melahirkan). Begitu perut betina terlihat sangat buncit membulat, segera pindahkan ke wadah sekat melahirkan (breeding box).

Penyelamatan Burayak: Segera pisahkan induk betina setelah melahirkan, lalu beri makan burayak menggunakan Artemia salina segar.""",
  ),
];
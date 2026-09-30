import 'package:flutter/material.dart';

import 'food_item.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'detail_page.dart';

// StatefulWidget dipakai karena tab dan jumlah pesanan dapat berubah selama aplikasi berjalan.

class MainPage extends StatefulWidget {
  // Wadah navigasi utama yang menyimpan pilihan menu dan tab aktif aplikasi.
  final String userName;
  final Set<String> favoriteNames;
  final ValueChanged<FoodItem> onToggleFavorite;
  final VoidCallback onLogout;

  const MainPage({
    super.key,
    required this.userName,
    required this.favoriteNames,
    required this.onToggleFavorite,
    required this.onLogout,
  });
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Nama berawalan garis bawah privat di file ini; _index menyimpan tab yang sedang aktif.
  int _index = 0;
  final List<FoodItem> _items = FoodItem.sampleData;
  // `final` mengunci referensi daftar, tetapi field quantity pada setiap item tetap bisa berubah.

  // Future menandai proses asynchronous; await menunggu halaman detail mengembalikan hasil.
  Future<void> _openDetail(FoodItem item) async {
    // Buka detail menu lalu simpan jumlah yang dikembalikan saat tombol Simpan ditekan.
    final result = await Navigator.push<int>(
      // `<int>` menyatakan tipe nilai yang bisa dikirim kembali oleh halaman detail.
      context,
      MaterialPageRoute(builder: (_) => DetailPage(item: item)),
    );
    if (result != null) {
      // setState meminta Flutter memanggil build lagi setelah jumlah menu berubah.
      setState(() => item.quantity = result); // beranda ikut update
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      // Urutan halaman harus sama dengan urutan pilihan pada NavigationBar.
      // Kedua halaman ditaruh sesuai urutan destination pada NavigationBar di bawah.
      HomePage(
        items: _items,
        onTapItem: _openDetail,
        favoriteNames: widget.favoriteNames,
        onToggleFavorite: widget.onToggleFavorite,
      ),
      HomePage(
        items: _items,
        onTapItem: _openDetail,
        favoriteNames: widget.favoriteNames,
        onToggleFavorite: widget.onToggleFavorite,
        showFavorites: true,
      ),
      ProfilePage(userName: widget.userName, onLogout: widget.onLogout),
    ];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorit'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

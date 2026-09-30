import 'package:flutter/material.dart';

import 'food_item.dart';

// StatelessWidget cukup karena halaman ini hanya menampilkan data yang diterima dari MainPage.

class HomePage extends StatelessWidget {
  // items adalah sumber baris yang ditampilkan; onTapItem meminta MainPage membuka detail.
  final List<FoodItem> items;
  final void Function(FoodItem) onTapItem;
  final Set<String> favoriteNames;
  final ValueChanged<FoodItem> onToggleFavorite;
  final bool showFavorites;

  // Callback bertipe void Function(FoodItem) menerima satu menu dan tidak mengembalikan nilai.
  const HomePage({
    super.key,
    required this.items,
    required this.onTapItem,
    required this.favoriteNames,
    required this.onToggleFavorite,
    this.showFavorites = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayedItems = showFavorites
        ? items.where((item) => favoriteNames.contains(item.name)).toList()
        : items;

    return Scaffold(
      appBar: AppBar(
        title: Text(showFavorites ? 'Menu Favorit' : 'Menu Resto'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: displayedItems.isEmpty
          ? Center(
              child: Text(
                showFavorites
                    ? 'Belum ada menu favorit.'
                    : 'Menu belum tersedia.',
              ),
            )
          : ListView.builder(
              // itemCount menentukan jumlah baris; itemBuilder membentuk widget untuk tiap indeks.
              padding: const EdgeInsets.all(12),
              itemCount: displayedItems.length,
              itemBuilder: (context, i) {
                final item = displayedItems[i];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => onTapItem(item),
                    child: Row(
                      children: [
                        Image.network(
                          item.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox(
                                width: 100,
                                height: 100,
                                child: ColoredBox(
                                  color: Color(0x1F000000),
                                  child: Icon(Icons.restaurant),
                                ),
                              ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: favoriteNames.contains(item.name)
                                          ? 'Hapus dari favorit'
                                          : 'Tambahkan ke favorit',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => onToggleFavorite(item),
                                      icon: Icon(
                                        favoriteNames.contains(item.name)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: favoriteNames.contains(item.name)
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.quantity} porsi',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Rp ${item.formattedPrice} / porsi',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Rp ${item.formattedTotal}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

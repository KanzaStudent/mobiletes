import 'package:flutter/material.dart';

import 'food_item.dart';

// StatefulWidget diperlukan agar total pada layar dapat berubah saat jumlah diketik.

class DetailPage extends StatefulWidget {
  // Halaman informasi menu dan pengisian jumlah pesanan.
  final FoodItem item;
  // Menu dikirim oleh MainPage saat pengguna memilih salah satu baris di beranda.
  const DetailPage({super.key, required this.item});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Controller menghubungkan kode dengan teks di TextField dan dilepas di dispose().
  late final TextEditingController _controller;
  // `late` menunda pengisian sampai initState dijalankan.
  late int _qty;

  @override
  void initState() {
    // Lifecycle ini berjalan sekali saat State dibuat; nilai awal diambil dari menu.
    super.initState();
    _qty = widget.item.quantity;
    _controller = TextEditingController(text: _qty.toString());
  }

  @override
  void dispose() {
    // dispose dipanggil saat halaman dibuang; controller harus dilepas di sini.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              item.imageUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 200,
                child: ColoredBox(
                  color: Color(0x1F000000),
                  child: Center(child: Icon(Icons.restaurant, size: 40)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Rp ${item.formattedPrice} / porsi',
            style: const TextStyle(color: Colors.green),
          ),
          const SizedBox(height: 8),
          Text(item.description),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Jumlah (porsi)',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _qty = int.tryParse(v) ?? 0),
            // tryParse menghindari exception; `?? 0` memakai nol bila teks bukan angka.
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total'),
              Text(
                'Rp ${formatPrice(_qty * item.price)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            // Tutup halaman detail dan kirim jumlah pilihan kembali ke MainPage.
            onPressed: () => Navigator.pop(context, _qty),
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Simpan Pemesanan'),
          ),
        ],
      ),
    );
  }
}

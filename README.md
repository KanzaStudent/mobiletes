# latkuis

Aplikasi Flutter sederhana untuk melihat menu restoran, mengisi jumlah pesanan, dan menghitung total harga.

Login saat ini memakai kredensial demo statis: username `admin`, password `admin123`. Kredensial tersebut berada di kode sumber, sehingga hanya aman untuk latihan/demo dan tidak boleh dipakai untuk aplikasi produksi.

## Menjalankan Aplikasi

Pastikan Flutter SDK sudah terpasang dan perangkat Android, emulator, Windows, atau browser tersedia.

```bash
flutter pub get
flutter run
```

`flutter pub get` mengunduh dependency proyek. `flutter run` membangun dan menjalankan aplikasi pada perangkat yang dipilih.

## Cara Menggunakan

1. Tab **Menu** menampilkan nama, foto, deskripsi, jumlah, harga satuan, dan total setiap menu.
2. Ketuk menu untuk membuka halaman detail.
3. Isi kolom **Jumlah (porsi)**. Nilai total langsung berubah mengikuti input.
4. Tekan **Simpan Pemesanan** untuk mengirim jumlah pilihan kembali ke daftar menu.
5. Tekan ikon hati pada menu untuk menambah atau menghapus favorit. Buka tab **Favorit** untuk melihat menu pilihan.
6. Tab **Profil** menampilkan akun yang sedang masuk dan tombol **Keluar** untuk logout.

## Peta File

- `lib/main.dart`: titik masuk program dan widget akar aplikasi.
- `lib/login_page.dart`: formulir login demo dan pengecekan username/password statis.
- `lib/main_page.dart`: navigasi tab serta pengelolaan state dan data pesanan.
- `lib/food_item.dart`: model data menu, data awal, getter harga, dan format Rupiah.
- `lib/home_page.dart`: daftar menu dan callback ketika satu menu dipilih.
- `lib/detail_page.dart`: detail, input jumlah, perhitungan, dan pengembalian hasil pemesanan.
- `lib/profile_page.dart`: tampilan profil yang statis.

## Login dan Batas Keamanan

`AuthGate` di `main.dart` menjadi gerbang aplikasi: sebelum login ia menampilkan `LoginPage`, setelah username/password cocok ia menampilkan `MainPage`. Logout mengubah status tersebut kembali sehingga login muncul lagi. Tidak diperlukan package `root` atau route khusus; `AuthGate` mengatur status, sedangkan navigasi tab tetap dilakukan oleh `NavigationBar`.

Kredensial contoh berada pada konstanta `LoginPage.demoUsername` dan `LoginPage.demoPassword` di `lib/login_page.dart`. Pemeriksaan lokal seperti ini dapat dilewati dan password dapat dibaca dari aplikasi. Untuk akun pengguna sungguhan, pindahkan autentikasi ke Firebase Auth atau backend/API dan jangan menyimpan password di source code.

Favorit saat ini menggunakan `Set<String>` di `AuthGate`, dengan nama menu sebagai identitas. Data favorit tersedia selama aplikasi berjalan dan dipertahankan saat logout/login pada sesi aplikasi yang sama, tetapi belum disimpan setelah aplikasi ditutup.

## Penjelasan Kode

### `main.dart`: memulai aplikasi

```dart
void main() => runApp(const MyApp());
```

`main()` adalah fungsi yang pertama dijalankan. `=>` adalah bentuk singkat fungsi untuk satu ekspresi. `runApp` memasang `MyApp` sebagai widget akar. `const` membuat objek widget konstan karena parameternya tidak berubah.

`MyApp extends StatelessWidget` berarti widget ini tidak menyimpan state yang berubah. Flutter memanggil `build(BuildContext context)` untuk meminta susunan widget yang harus ditampilkan. `MaterialApp` menyediakan konfigurasi aplikasi bergaya Material; `theme` mengatur tampilan umum dan `home` menentukan halaman pertama.

### `main_page.dart`: state dan navigasi

`MainPage extends StatefulWidget` dipakai karena tab aktif dan jumlah pesanan berubah saat aplikasi digunakan. `createState()` memasangkan widget dengan `_MainPageState`. Awalan `_` menjadikan nama itu privat dalam file Dart. Variabel `_index` menentukan tab aktif, sedangkan `_items` menunjuk ke daftar menu yang dibagikan dengan halaman beranda.

Fungsi `_openDetail` menggunakan pola berikut untuk membuka detail dan menerima jumlah pesanan:

```dart
final result = await Navigator.push<int>(
  context,
  MaterialPageRoute(builder: (_) => DetailPage(item: item)),
);
if (result != null) {
  setState(() => item.quantity = result);
}
```

`Future<void>` menandakan fungsi asynchronous. `Navigator.push<int>` menumpuk halaman baru dan menetapkan bahwa hasil yang mungkin dikembalikan bertipe `int`. `MaterialPageRoute` membuat rute halaman; `builder` membuat widget detail. `await` menunggu sampai halaman detail ditutup. Jika hasilnya tidak `null`, `setState` menyimpan jumlah dan meminta Flutter membangun ulang tampilan. `setState(() => ...)` adalah bentuk singkat untuk callback satu ekspresi.

Di `detail_page.dart`, `Navigator.pop(context, _qty)` menutup halaman detail sambil mengirim `_qty` sebagai hasil `push`. Jika pengguna kembali tanpa menekan tombol simpan, hasilnya `null`.

### `food_item.dart`: model dan harga

`FoodItem` adalah kelas untuk mengelompokkan data satu menu. Parameter konstruktor seperti `{required this.name}` adalah parameter bernama yang wajib diberikan saat objek dibuat. `final` berarti nilai field tidak dapat diganti setelah objek dibuat; `quantity` sengaja tidak `final` karena jumlah pesanan diperbarui.

Getter seperti `totalPrice` menghitung nilai saat diminta, sehingga total selalu memakai harga dan jumlah terkini. `static final List<FoodItem> sampleData` menyediakan data contoh yang diakses langsung melalui `FoodItem.sampleData`, tanpa membuat instance lain.

`formatPrice` memakai `RegExp` dengan pola `r'(\d)(?=(\d{3})+$)'` untuk mencari digit yang diikuti kelompok ribuan. `replaceAllMapped` mengganti setiap kecocokan dengan digit tersebut ditambah titik. Karena itu `15000` ditampilkan sebagai `15.000`. `m[1]` mengambil isi kelompok pertama dari pola regex.

### `home_page.dart`: daftar dan callback

`HomePage` menerima `items` dan `onTapItem` dari halaman utama. Tipe `void Function(FoodItem)` berarti `onTapItem` adalah fungsi callback yang menerima satu objek menu dan tidak mengembalikan nilai.

`ListView.builder` membuat baris daftar berdasarkan data: `itemCount` menentukan jumlah baris, sedangkan `itemBuilder` dipanggil untuk setiap indeks. `items[i]` mengambil menu pada indeks tersebut. `InkWell` menangani sentuhan, lalu `onTap` memanggil callback agar `MainPage` yang membuka detail.

Widget layout menjelaskan bagaimana anak disusun: `Row` mendatar, `Column` vertikal, `Expanded` menggunakan ruang yang tersisa, dan `Padding` menambahkan jarak. `Image.network` memuat gambar dari URL. Interpolasi seperti `'${item.quantity} porsi'` menyisipkan nilai variabel ke dalam string.

### `detail_page.dart`: input dan siklus hidup

`DetailPage` adalah `StatefulWidget` karena jumlah yang diketik berubah. Data menu diterima melalui properti `item` dan dibaca dari state dengan `widget.item`.

`TextEditingController` menghubungkan kode dengan isi `TextField`. Controller dibuat di `initState()` saat state pertama kali dipasang, lalu dibersihkan di `dispose()` ketika halaman ditutup. Ini mencegah resource controller tertinggal.

```dart
onChanged: (v) => setState(() => _qty = int.tryParse(v) ?? 0),
```

`onChanged` dijalankan setiap kali teks berubah. `(v) => ...` adalah fungsi anonim yang menerima teks baru. `int.tryParse(v)` mencoba mengubah teks menjadi bilangan bulat, sedangkan `?? 0` memakai nol jika teks kosong atau tidak valid. `setState` membuat total yang menggunakan `_qty * item.price` dihitung dan ditampilkan ulang.

Tombol simpan menjalankan `Navigator.pop(context, _qty)`. `context` menunjukkan lokasi halaman pada widget tree, dan `_qty` menjadi hasil yang diterima `_openDetail`.

### `profile_page.dart`: widget statis

`ProfilePage extends StatelessWidget` karena isi profil tidak berubah selama aplikasi berjalan. `const ProfilePage()` memungkinkan Flutter menggunakan instance konstan. `Scaffold` memberi struktur halaman, `Center` menempatkan isi di tengah, dan `Column` menyusun avatar serta teks secara vertikal.

## Mengubah Data

Untuk menambah atau mengganti menu, ubah daftar `FoodItem.sampleData` di `lib/food_item.dart`. Setiap objek berisi `name`, `description`, `imageUrl`, `quantity` awal (biasanya `0`), dan `price` dalam Rupiah tanpa pemisah titik. Untuk mengubah nama atau label profil, edit teks pada `lib/profile_page.dart`.

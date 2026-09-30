import 'package:flutter/material.dart';

import 'food_item.dart';
import 'login_page.dart';
import 'main_page.dart';

// `main` adalah titik mulai program; `=>` menyingkat fungsi satu ekspresi.
// `runApp` memasang MyApp sebagai widget akar yang akan digambar Flutter.

void main() => runApp(const MyApp());
// MyApp adalah StatelessWidget karena konfigurasi akar aplikasi tidak berubah.

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // `super.key` meneruskan identitas widget ke kelas induk; build menyusun widget tree.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Pengaturan global aplikasi, seperti tema warna dan halaman pertama.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

// Memilih halaman login atau aplikasi berdasarkan status autentikasi demo.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoggedIn = false;
  final Set<String> _favoriteNames = {};

  void _toggleFavorite(FoodItem item) {
    setState(() {
      if (!_favoriteNames.add(item.name)) {
        _favoriteNames.remove(item.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return LoginPage(onLogin: () => setState(() => _isLoggedIn = true));
    }

    return MainPage(
      userName: LoginPage.demoUsername,
      favoriteNames: _favoriteNames,
      onToggleFavorite: _toggleFavorite,
      onLogout: () => setState(() => _isLoggedIn = false),
    );
  }
}

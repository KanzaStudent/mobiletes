import 'package:flutter/material.dart';

// StatelessWidget cocok untuk profil statis yang tidak mengubah state selama aplikasi berjalan.

class ProfilePage extends StatelessWidget {
  // Halaman profil statis yang ditampilkan melalui tab Profil di MainPage.
  final String userName;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Text(
              userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Pelanggan Resto', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}

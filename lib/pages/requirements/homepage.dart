import 'package:flutter/material.dart';

import '../../components/ui/sidedrawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Garage Logbook',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      drawer: const SideDrawer(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0), // responsive padding
          child: const Text(
            'Aplikasi ini diselesaikan untuk mengampuh tugas Komputasi Bergerak Minggu-2\n'
            'dengan Tema Garage Logbook',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../components/ui/sidedrawer.dart';

const String urls = 'assets/profile-pic.jpg';
const String nama = 'Daffa';
const String nim = '223443007';
const String jurusan = 'AE';
const String program = 'TRIN';
const String email = 'khairuonwork@gmail.com';
const String github = 'khairuonwork';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      drawer: const SideDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              urls,
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),
            Text(
              "$nama - $nim",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Program: $program"),
            Text("Jurusan: $jurusan"),
            Text("Email: $email"),
            Text("GitHub: $github"),
          ],
        ),
      ),
    );
  }
}

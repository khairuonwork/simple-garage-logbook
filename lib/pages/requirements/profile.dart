import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull('subject=Hello Daffa&body=Hi, I saw your profile!'),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  Future<void> _launchGitHub() async {
    final Uri githubUri = Uri.parse('https://github.com/$github');

    if (await canLaunchUrl(githubUri)) {
      await launchUrl(githubUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $githubUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
      ),
      drawer: const SideDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(urls, width: 120, height: 120),
            const SizedBox(height: 16),
            Text(
              "$nama - $nim",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Program Studi: $program"),
            Text("Jurusan: $jurusan"),
            Text("Email: $email"),
            Text("GitHub: $github"),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _launchEmail,
              icon: const Icon(Icons.email),
              label: const Text("Contact via Email"),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _launchGitHub,
              icon: const Icon(Icons.link),
              label: const Text("Visit GitHub"),
            ),
          ],
        ),
      ),
    );
  }
}

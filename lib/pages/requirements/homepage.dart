import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../components/ui/sidedrawer.dart';

// Model Dayoff
class Dayoff {
  final String tanggal;
  final String keterangan;
  final bool isCuti;

  Dayoff({
    required this.tanggal,
    required this.keterangan,
    required this.isCuti,
  });

  factory Dayoff.fromJson(Map<String, dynamic> json) {
    return Dayoff(
      tanggal: json['tanggal'],
      keterangan: json['keterangan'],
      isCuti: json['is_cuti'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Dayoff> dayoffs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDayoffs();
  }

  Future<void> fetchDayoffs() async {
    try {
      final response = await http.get(
        Uri.parse('https://dayoffapi.vercel.app/api?month=6&year=2023'),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody is List) {
          setState(() {
            dayoffs = jsonBody.map((item) => Dayoff.fromJson(item)).toList();
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Format data tidak sesuai.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  void _showTapDialog(Dayoff dayoff) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Info Singkat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${dayoff.tanggal}'),
            Text('Cuti: ${dayoff.isCuti ? "Ya" : "Tidak"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLongPressDialog(Dayoff dayoff) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detail Hari Libur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${dayoff.tanggal}'),
            Text('Keterangan: ${dayoff.keterangan}'),
            Text('Cuti: ${dayoff.isCuti ? "Ya" : "Tidak"}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aplikasi ini diselesaikan untuk mengampuh tugas Komputasi Bergerak Minggu-2\n'
                        'dengan Tema Garage Logbook',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Daftar Hari Libur:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: dayoffs.length,
                          itemBuilder: (context, index) {
                            final dayoff = dayoffs[index];
                            return ListTile(
                              title: Text(dayoff.tanggal),
                              subtitle: Text(dayoff.keterangan),
                              trailing: Icon(
                                dayoff.isCuti
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color:
                                    dayoff.isCuti ? Colors.green : Colors.red,
                              ),
                              onTap: () => _showTapDialog(dayoff),
                              onLongPress: () => _showLongPressDialog(dayoff),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

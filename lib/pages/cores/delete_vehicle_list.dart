import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../components/ui/sidedrawer.dart';

class DeleteVehiclePage extends StatefulWidget {
  const DeleteVehiclePage({super.key});

  @override
  State<DeleteVehiclePage> createState() => _DeleteVehiclePageState();
}

class _DeleteVehiclePageState extends State<DeleteVehiclePage> {
  late Future<List<Map<String, dynamic>>> _vehicles;

  @override
  void initState() {
    super.initState();
    _vehicles = _getVehicles();
  }

  /// Ensure the table exists and return all vehicles
  Future<List<Map<String, dynamic>>> _getVehicles() async {
    final db =
        await openDatabase(p.join(await getDatabasesPath(), 'garage.db'));
    await db.execute('''
      CREATE TABLE IF NOT EXISTS vehicle (
        vehicle_id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_name TEXT,
        vehicle_image TEXT,
        vehicle_registration_number TEXT,
        vehicle_notes TEXT
      )
    ''');
    return await db.query('vehicle');
  }

  /// Delete a vehicle by ID and refresh the list
  Future<void> _deleteVehicle(int id) async {
    final db =
        await openDatabase(p.join(await getDatabasesPath(), 'garage.db'));
    await db.delete('vehicle', where: 'vehicle_id = ?', whereArgs: [id]);

    setState(() {
      _vehicles = _getVehicles(); // refresh after delete
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vehicle deleted')),
    );
  }

  /// Show confirmation dialog before deleting
  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: const Text('Are you sure you want to delete this vehicle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteVehicle(id);
            },
            child: const Text('Delete'),
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
          'Delete Vehicles',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      drawer: const SideDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vehicles,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return const Center(child: Text('No vehicles found.'));
          }

          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final v = data[index];
              return ListTile(
                leading: v['vehicle_image'] != null &&
                        v['vehicle_image'].toString().isNotEmpty &&
                        File(v['vehicle_image']).existsSync()
                    ? Image.file(
                        File(v['vehicle_image']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.directions_car),
                title: Text(v['vehicle_name']),
                subtitle: Text(v['vehicle_registration_number']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(v['vehicle_id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

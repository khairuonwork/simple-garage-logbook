import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../components/ui/sidedrawer.dart';
import 'edit_vehicle.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage> {
  late Future<List<Map<String, dynamic>>> _vehicleList;

  @override
  void initState() {
    super.initState();
    _vehicleList = _getVehicles();
  }

  Future<List<Map<String, dynamic>>> _getVehicles() async {
    final db =
        await openDatabase(p.join(await getDatabasesPath(), 'garage.db'));
    return await db.query('vehicle');
  }

  void _refresh() => setState(() => _vehicleList = _getVehicles());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Vehicle List'),
          backgroundColor: Colors.blue.shade900),
      drawer: const SideDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vehicleList,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final vehicles = snapshot.data!;
          if (vehicles.isEmpty)
            return const Center(child: Text('No vehicles found.'));
          return ListView.separated(
            itemCount: vehicles.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final v = vehicles[index];
              return ListTile(
                leading: v['vehicle_image'] != null &&
                        v['vehicle_image'].toString().isNotEmpty
                    ? Image.file(File(v['vehicle_image']),
                        width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.directions_car),
                title: Text(v['vehicle_name']),
                subtitle: Text(v['vehicle_registration_number']),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditVehiclePage(vehicle: v)),
                    );
                    _refresh();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

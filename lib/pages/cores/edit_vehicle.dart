import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class EditVehiclePage extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  const EditVehiclePage({super.key, required this.vehicle});

  @override
  State<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  late TextEditingController _name;
  late TextEditingController _reg;
  late TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.vehicle['vehicle_name']);
    _reg = TextEditingController(
        text: widget.vehicle['vehicle_registration_number']);
    _notes = TextEditingController(text: widget.vehicle['vehicle_notes']);
  }

  Future<void> _updateVehicle() async {
    final db =
        await openDatabase(p.join(await getDatabasesPath(), 'garage.db'));
    await db.update(
      'vehicle',
      {
        'vehicle_name': _name.text.trim(),
        'vehicle_registration_number': _reg.text.trim(),
        'vehicle_notes': _notes.text.trim(),
      },
      where: 'vehicle_id = ?',
      whereArgs: [widget.vehicle['vehicle_id']],
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Vehicle updated')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _name.dispose();
    _reg.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.vehicle['vehicle_image'] as String?;
    final imageWidget = imagePath != null && File(imagePath).existsSync()
        ? Image.file(File(imagePath),
            width: double.infinity, height: 150, fit: BoxFit.cover)
        : const Icon(Icons.directions_car, size: 100);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Vehicle'),
          backgroundColor: Colors.blue.shade900),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Center(child: imageWidget),
          const SizedBox(height: 20),
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Vehicle Name')),
          TextField(
              controller: _reg,
              decoration:
                  const InputDecoration(labelText: 'Registration Number')),
          TextField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
            onPressed: _updateVehicle,
          ),
        ]),
      ),
    );
  }
}

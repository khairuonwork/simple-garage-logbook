import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../../components/ui/sidedrawer.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _nameController = TextEditingController();
  final _registrationController = TextEditingController();
  final _notesController = TextEditingController();
  File? _selectedImage;

  late Database _db;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'garage.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await db.execute(_createTableSQL()),
      onOpen: (db) async => await db.execute(_createTableSQL()),
    );
  }

  String _createTableSQL() {
    return '''
      CREATE TABLE IF NOT EXISTS vehicle (
        vehicle_id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicle_name TEXT,
        vehicle_image TEXT,
        vehicle_registration_number TEXT,
        vehicle_notes TEXT
      )
    ''';
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _insertVehicle() async {
    final name = _nameController.text.trim();
    final reg = _registrationController.text.trim();

    if (name.isEmpty || reg.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Registration required')),
      );
      return;
    }

    await _db.insert('vehicle', {
      'vehicle_name': name,
      'vehicle_image': _selectedImage?.path ?? '',
      'vehicle_registration_number': reg,
      'vehicle_notes': _notesController.text.trim(),
    });

    _nameController.clear();
    _registrationController.clear();
    _notesController.clear();
    setState(() => _selectedImage = null);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vehicle added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title:
              const Text('Add Vehicle', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue.shade900),
      drawer: const SideDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          _buildTextField(_nameController, 'Vehicle Name'),
          const SizedBox(height: 10),
          _buildTextField(_registrationController, 'Registration Number'),
          const SizedBox(height: 10),
          // GestureDetector(
          //   onTap: _pickImage,
          //   child: Container(
          //     width: double.infinity,
          //     height: 150,
          //     decoration: BoxDecoration(
          //       border: Border.all(),
          //       image: _selectedImage != null
          //           ? DecorationImage(
          //               image: FileImage(_selectedImage!), fit: BoxFit.cover)
          //           : null,
          //     ),
          //     child: _selectedImage == null
          //         ? const Center(child: Text('Tap to select image'))
          //         : null,
          //   ),
          // ),
          const SizedBox(height: 10),
          _buildTextField(_notesController, 'Notes', maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Vehicle'),
            onPressed: _insertVehicle,
          )
        ]),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines);
  }
}

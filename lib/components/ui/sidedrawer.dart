import 'package:flutter/material.dart';

// Pages
import '../../pages/requirements/profile.dart';
import '../../pages/requirements/homepage.dart';
import '../../pages/cores/add_vehicle_list.dart';
import '../../pages/cores/vehicle_list.dart';
import '../../pages/cores/delete_vehicle_list.dart'; // No conflict now

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade900),
            child: const Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          _buildNavItem(
            context,
            icon: Icons.home,
            title: 'Homepage',
            page: const HomePage(),
            replace: true,
          ),
          _buildNavItem(
            context,
            icon: Icons.account_circle,
            title: 'Profile',
            page: const Profile(),
          ),
          _buildNavItem(
            context,
            icon: Icons.add,
            title: 'Add Vehicle',
            page: const AddPage(),
          ),
          _buildNavItem(
            context,
            icon: Icons.view_list,
            title: 'List Vehicle',
            page: const VehicleListPage(),
          ),
          _buildNavItem(
            context,
            icon: Icons.delete,
            title: 'Delete Vehicle',
            page: const DeleteVehiclePage(),
          ),
        ],
      ),
    );
  }

  ListTile _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
    bool replace = false,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (replace) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
    );
  }
}

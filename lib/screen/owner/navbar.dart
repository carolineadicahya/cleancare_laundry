import 'package:CleanCare/screen/owner/dashboard_admin.dart';
import 'package:CleanCare/utils/constants.dart';
import 'package:flutter/material.dart';

class LayoutAdmin extends StatefulWidget {
  const LayoutAdmin({super.key});

  @override
  State<LayoutAdmin> createState() => _LayoutAdminState();
}

class _LayoutAdminState extends State<LayoutAdmin> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    DashboardAdmin(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[
          _selectedIndex], // ngebaca widget sesuai denagn index yang di pilih
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_laundry_service_rounded),
            label: 'Service',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Constants.primaryColor,
        unselectedItemColor: Colors.black12,
        onTap: _onItemTapped,
      ),
    );
  }
}

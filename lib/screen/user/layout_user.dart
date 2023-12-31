import 'package:CleanCare/screen/user/pilih_paket.dart';
import 'package:CleanCare/screen/user/dashboard_user.dart';
import 'package:CleanCare/screen/user/order_user.dart';
import 'package:CleanCare/screen/user/map.dart';
import 'package:CleanCare/screen/user/profil_setting.dart';
import 'package:CleanCare/utils/constants.dart';
import 'package:flutter/material.dart';

class LayoutPages extends StatefulWidget {
  const LayoutPages({super.key});

  @override
  State<LayoutPages> createState() => _LayoutPagesState();
}

class _LayoutPagesState extends State<LayoutPages> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    MapPage(),
    AddOrder(),
    OrderPage(),
    ProfilePage(),
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
            icon: Icon(Icons.pin_drop_rounded),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: 'Pilih Paket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_laundry_service),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_rounded),
            label: 'Profil',
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

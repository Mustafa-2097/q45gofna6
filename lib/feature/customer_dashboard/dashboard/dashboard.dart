import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q45gofna6/feature/customer_dashboard/dashboard/widgets/bottom_nav.dart';
import 'package:q45gofna6/feature/customer_dashboard/event/views/event_page.dart';
import 'package:q45gofna6/feature/customer_dashboard/inventory/views/inventory_page.dart';
import 'package:q45gofna6/feature/customer_dashboard/reports/views/reports_page.dart';
import '../home/views/home_page.dart';

class CustomerDashboard extends StatefulWidget {
  final int initialIndex;
  const CustomerDashboard({super.key, this.initialIndex = 0});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  late int _selectedIndex;

  final List<Widget> _screens = [
    HomePage(),
    InventoryPage(),
    EventPage(),
    ReportsPage(),
    const SizedBox(), // Placeholder for Profile
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // set initial tab
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

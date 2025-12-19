import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/search_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/crypto_list_screen.dart';
import '../screens/news_screen.dart';
import '../screens/crypto_heatmap_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 3; // شروع از "ارزها"

  static const List<Widget> _pages = [
    LoginScreen(),
    SearchScreen(),
    FavoritesScreen(), // صرافی‌ها
    CryptoListScreen(),
    NewsScreen(),
    CryptoHeatmapScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'ورود'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'جستجو'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'صرافی‌ها',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_bitcoin),
            label: 'ارزها',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'اخبار'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'نمای بازار',
          ), // ← جدید
        ],
      ),
    );
  }
}

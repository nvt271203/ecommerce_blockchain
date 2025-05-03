import 'package:flutter/material.dart';
import 'package:sales_business_app/views/screens/nav_screen/accout_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/cart_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/favorite_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/home_screen.dart';
import 'package:sales_business_app/views/screens/nav_screen/stores_screen.dart';

import '../../services/ContractFactoryServies.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  List<Widget> _pages = [
    HomeScreen(),
    FavoriteScreen(),
    StoresScreen(),
    CartScreen(),
    AccoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },

          //Hiện nhãn bottombar.
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.home),
            ), label: 'Home'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite_outlined),
                ), label: 'Favorite'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.store_rounded),
                ), label: 'Stores'),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart),
                ), label: 'Cart'),
            BottomNavigationBarItem(icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.person),
            ), label: 'Account'),
          ]),
      body: _pages[_pageIndex],
    );
  }
}

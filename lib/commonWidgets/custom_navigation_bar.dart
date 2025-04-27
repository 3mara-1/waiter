import 'package:flutter/material.dart';
import 'package:waiter/screens/Favorites_Page.dart';
import 'package:waiter/screens/Layout_Page.dart';
import 'package:waiter/screens/Profile_Page.dart';
import 'package:waiter/commonWidgets/drawer.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 1; // مبدئياً على Favorites

  static final List<Widget> _pages = <Widget>[
    LayoutPage(),    // صفحة Layout
    FavoritesPage(), // صفحة Favorites
    ProfilePage(),   // صفحة Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: const Color(0xFFFF5C00),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child:Text(
          'Waiter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),),
        // leading:Drawer(backgroundColor:Color(0xFFFF5C00) ,

        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer:Drawerscreen(),
      body: _pages[_selectedIndex], // هنا بتغيري الصفحة حسب الزر اللي اتضغط
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFFF5C00),
        unselectedItemColor: Colors.orangeAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // لما تضغطي
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'layout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
      ),
    );
  }
}
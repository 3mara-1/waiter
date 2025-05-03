import 'package:flutter/material.dart';
import 'package:waiter/screens/Favorites_Page.dart';
import 'package:waiter/screens/Layout_Page.dart';
import 'package:waiter/screens/Profile_Page.dart';
// import 'package:waiter/commonWidgets/drawer.dart';
class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0; 

  static final List<Widget> _pages = <Widget>[
    LayoutPage(),    
     FavoritesPage(), 
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
     appBar: AppBar(
        
        backgroundColor: Colors.white,
      
        iconTheme: const IconThemeData(color: Color(0xFFFF5C00)), 
       
        
        title: Center( 
          child:Text(
            'Waiter',
            style: TextStyle(
              color: Color(0xFFFF5C00), 
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ), 
      
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: const Icon(Icons.menu, color: Color(0xFFFF5C00)),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
      ),
      
      // drawer:Drawerscreen(),
      
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFFF5C00),
        unselectedItemColor: Colors.orangeAccent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Layout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
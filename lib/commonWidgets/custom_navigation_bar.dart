import 'package:flutter/material.dart';
import 'package:waiter/screens/Favorites_Page.dart';
import 'package:waiter/screens/Layout_Page.dart';
import 'package:waiter/screens/Profile_Page.dart';
import 'package:waiter/commonWidgets/drawer.dart';
// لم نعد بحاجة لاستيراد SearchQueryNotifier هنا


class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0; // القيمة المبدئية على Layout

  static final List<Widget> _pages = <Widget>[
    LayoutPage(),    // صفحة Layout (Index 0)
    FavoritesPage(), // صفحة Favorites (Index 1)
    ProfilePage(),   // صفحة Profile (Index 2)
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
        // تغيير لون الخلفية إلى الأبيض
        backgroundColor: Colors.white,
        // تغيير لون أيقونات الـ AppBar (مثل أيقونة الدرور)
        iconTheme: const IconThemeData(color: Color(0xFFFF5C00)), // لون الثيم البرتقالي
        // إزالة أيقونة البحث المنفصلة
        actions: [],
        // وضع نص العنوان وتغيير لونه
        title: Center(
          widthFactor: 3.3, // لتوسيع النص في المنتصف
          child:Text(
            'Waiter',
            style: TextStyle(
              color: Color(0xFFFF5C00), // لون النص ليظهر على خلفية بيضاء
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        // أيقونة الدرور ستظهر تلقائيًا إذا لم تحدد leading ووجود Drawer في Scaffold
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: const Icon(Icons.menu, color: Color(0xFFFF5C00)),
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //   ),
        // ),
      ),
      // الـ Drawer لا يتغير
      drawer:Drawerscreen(),
      // يتم عرض الصفحة المختارة
      body: _pages[_selectedIndex],
      // BottomNavigationBar لا يتغير
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
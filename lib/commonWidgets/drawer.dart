import 'package:flutter/material.dart';
class Drawerscreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(child: ListView(
    padding: EdgeInsets.zero, // مهم جدًا عشان الـ DrawerHeader يشتغل صح
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Color(0xFFFF5C00),
        ),
        child: Text(
          'Drawer Header',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      // ListTile(
      //   leading: Icon(Icons.home),
      //   title: Text('Home'),
      //   onTap: (){},
      // ),


  ]
    ),
    );
  }
}
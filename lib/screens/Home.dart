import 'package:flutter/material.dart';

class Use extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text(
          'This is the Home Screen!',
          style: TextStyle(fontSize: 20 ,color: Colors.deepOrange),

        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:waiter/screens/User_type.dart';
import 'package:waiter/commonWidgets/custom_navigation_bar.dart';
void main() {
  //  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Future.delayed(Duration(seconds: 4), () {
  //   FlutterNativeSplash.remove();
  // });
  runApp( Waiter());
}
class Waiter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Navbar()
    );
  }
}

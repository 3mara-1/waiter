import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiter/screens/login_screen.dart';
import 'package:waiter/commonWidgets/custom_navigation_bar.dart';
import 'package:waiter/services/auth_service.dart';
import 'package:waiter/providers/user_profile_notifier.dart';
import 'package:waiter/providers/favorites_notifier.dart';
import 'package:waiter/screens/onboarding_screen.dart';
void main() {
  runApp(
  
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileNotifier()),
        ChangeNotifierProvider(create: (context) => FavoritesNotifier()),
        
      ],
      child: Waiter(),
    ),
  );
}

class Waiter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EntryPoint(),

    );
  }
}
class EntryPoint extends StatefulWidget {
  const EntryPoint({Key? key}) : super(key: key);

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  bool _isInitialized = false;
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    
    Widget screen;
    if (isLoggedIn) {
      
      screen = const Navbar();
    } else {
      final hasRegistered = await AuthService.hasRegistered();
      
      if (hasRegistered) {
        
        screen = LoginScreen();
      } else {
        
        screen = OnboardingScreen();
      }
    }

    setState(() {
      _initialScreen = screen;
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5C00)),
          ),
        ),
      );
    }
    
    return _initialScreen!;
  }
}
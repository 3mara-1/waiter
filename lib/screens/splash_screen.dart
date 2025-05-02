import 'package:flutter/material.dart';
import 'package:waiter/commonWidgets/custom_navigation_bar.dart';
import 'package:waiter/screens/login_screen.dart';
import 'package:waiter/screens/onboarding_screen.dart';
import 'package:waiter/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Add a small delay to show splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if user is already logged in
    final isLoggedIn = await AuthService.isLoggedIn();
    
    if (isLoggedIn) {
      // User is logged in, navigate to the main app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Navbar()),
      );
    } else {
      // User is not logged in, check if they've registered before
      final hasRegistered = await AuthService.hasRegistered();
      
      if (hasRegistered) {
        // User has registered before, navigate to login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // New user, navigate to onboarding
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or image
            Image.asset(
              'assets/images/logo.png', // Make sure this asset exists
              width: 160,
              height: 160,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 160,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 80,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // App name
            const Text(
              'Waiter',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5C00),
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5C00)),
            ),
          ],
        ),
      ),
    );
  }
}
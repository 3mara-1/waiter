import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _hasRegisteredKey = 'has_registered';
  static const String userProfileKey = 'user_profile';

  // User model to store user data
  static Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userProfileJson = prefs.getString(userProfileKey);
    
    if (userProfileJson != null) {
      return json.decode(userProfileJson);
    }
    
    return {
      'email': '',
      'firstName': '',
      'lastName': '',
      'imageUrl': 'assets/images/default_profile.png',
      'notificationsEnabled': true,
    };
  }
  

  static Future<bool> saveUserProfile(Map<String, dynamic> profileData) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userProfileKey, json.encode(profileData));
  }

  static Future<bool> register(String email, String password, String firstName, String lastName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'imageUrl': 'assets/images/default_profile.png',
        'notificationsEnabled': true,
      };
      
      // Save user data
      await prefs.setString(userProfileKey, json.encode(userData));
      
      // Set login status
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setBool(_hasRegisteredKey, true);
      
      return true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // Log in existing user
  static Future<bool> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // In a real app, you would validate credentials with an API
      // For this demo, we'll simulate successful login
      
      final userProfileJson = prefs.getString(userProfileKey);
      
      // Check if there's a stored profile
      if (userProfileJson != null) {
        final userData = json.decode(userProfileJson);
        if (userData['email'] == email) {
          // Set login status
          await prefs.setBool(_isLoggedInKey, true);
          return true;
        }
      }
      
      // If we haven't returned yet, login failed
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Log out user
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Set login status to false
      await prefs.setBool(_isLoggedInKey, false);
      
      return true;
    } catch (e) {
      print('Logout error: $e');
      return false;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('isLoggedIn error: $e');
      return false;
    }
  }

  // Check if user has registered before
  static Future<bool> hasRegistered() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasRegisteredKey) ?? false;
    } catch (e) {
      print('hasRegistered error: $e');
      return false;
    }
  }

  // Update user profile
  static Future<bool> updateUserProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    bool? notificationsEnabled,
  }) async {
    try {
      // Get current profile
      final currentProfile = await getUserProfile();
      
      // Update with new values if provided
      if (firstName != null) currentProfile['firstName'] = firstName;
      if (lastName != null) currentProfile['lastName'] = lastName;
      if (email != null) currentProfile['email'] = email;
      if (imageUrl != null) currentProfile['imageUrl'] = imageUrl;
      if (notificationsEnabled != null) currentProfile['notificationsEnabled'] = notificationsEnabled;
      
      // Save updated profile
      return await saveUserProfile(currentProfile);
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  final String email;
  final String firstName;
  final String lastName;
  final String imageUrl;
  final bool notificationsEnabled;

  UserProfile({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.notificationsEnabled,
  });

  // Full name getter
  String get name => '$firstName $lastName';

  // Create a copy with method for updating fields
  UserProfile copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? imageUrl,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      imageUrl: imageUrl ?? this.imageUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  // Convert to and from JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName, 
      'imageUrl': imageUrl,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      imageUrl: json['imageUrl'] ?? 'assets/images/profile_placeholder.jpg',
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }

  // Default profile
  factory UserProfile.defaultProfile() {
    return UserProfile(
      email: 'user@example.com',
      firstName: 'User',
      lastName: '',
      imageUrl: 'assets/images/profile_placeholder.jpg',
      notificationsEnabled: true,
    );
  }
}

class UserProfileNotifier extends ChangeNotifier {
  late UserProfile _userProfile;
  
  UserProfileNotifier() {
    _userProfile = UserProfile.defaultProfile();
    _loadProfile();
  }

  UserProfile get userProfile => _userProfile;

  // Load profile from shared preferences
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('user_email');
    final String? firstName = prefs.getString('user_firstName');
    final String? lastName = prefs.getString('user_lastName');
    final bool notificationsEnabled = prefs.getBool('user_notifications_enabled') ?? true;

    if (email != null) {
      _userProfile = UserProfile(
        email: email,
        firstName: firstName ?? 'User',
        lastName: lastName ?? '',
        imageUrl: 'assets/images/profile_placeholder.jpg',
        notificationsEnabled: notificationsEnabled,
      );
      notifyListeners();
    }
  }

  // Save profile to shared preferences
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', _userProfile.email);
    await prefs.setString('user_firstName', _userProfile.firstName);
    await prefs.setString('user_lastName', _userProfile.lastName);
    await prefs.setBool('user_notifications_enabled', _userProfile.notificationsEnabled);
  }

  // Update user profile
 Future<bool> updateProfile({
  String? email,
  String? firstName,
  String? lastName,
  String? imageUrl,
}) async {
  try {
    _userProfile = _userProfile.copyWith(
      email: email,
      firstName: firstName,
      lastName: lastName,
      imageUrl: imageUrl,
    );
    await _saveProfile();
    notifyListeners();
    return true;
  } catch (e) {
    return false;
  }
}

  // Toggle notifications
  Future<void> setNotificationsEnabled(bool value) async {
    _userProfile = _userProfile.copyWith(notificationsEnabled: value);
    await _saveProfile();
    notifyListeners();
  }

  // Set user profile after login/signup
  Future<void> setUserProfile({
    required String email,
    String? firstName,
    String? lastName,
  }) async {
    _userProfile = UserProfile(
      email: email,
      firstName: firstName ?? 'User',
      lastName: lastName ?? '',
      imageUrl: 'assets/images/profile_placeholder.jpg',
      notificationsEnabled: true,
    );
    await _saveProfile();
    notifyListeners();
  }

  // Clear user profile on logout
  Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_firstName');
    await prefs.remove('user_lastName');
    
    _userProfile = UserProfile.defaultProfile();
    notifyListeners();
  }
}
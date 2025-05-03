import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; 
import 'package:waiter/services/auth_service.dart';

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


  String get name => '$firstName $lastName'.trim().isEmpty ? email : '$firstName $lastName'; 

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
 
  UserProfile _userProfile = UserProfile.defaultProfile();
  bool _isLoading = true; 

  UserProfileNotifier() {
    _loadProfile();
  }

  UserProfile get userProfile => _userProfile;
  bool get isLoading => _isLoading; 

  Future<void> _loadProfile() async {
    _isLoading = true; 
    

    final prefs = await SharedPreferences.getInstance();
   
   
    final String? userProfileJson = prefs.getString(AuthService.userProfileKey);

    UserProfile loadedProfile = UserProfile.defaultProfile(); 

    if (userProfileJson != null) {
      try {
       
        final Map<String, dynamic> userProfileMap = json.decode(userProfileJson);
        
        loadedProfile = UserProfile.fromJson(userProfileMap);
      } catch (e) {
        print("Error decoding user profile from SharedPreferences: $e");
        
      }
    }
   

    _userProfile = loadedProfile; 
    _isLoading = false;          
    notifyListeners();           
  }
  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
   
    final userProfileJson = json.encode(_userProfile.toJson());
    await prefs.setString(AuthService.userProfileKey, userProfileJson); 
  }

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
      print("Error updating profile: $e");
      return false;
    }
  }
  Future<void> setNotificationsEnabled(bool value) async {
    if (_userProfile.notificationsEnabled != value) {
      _userProfile = _userProfile.copyWith(notificationsEnabled: value);
      await _saveProfile();
      notifyListeners();
    }
  }


  Future<void> setUserProfile({
    required String email,
    String? firstName,
    String? lastName,
    String? imageUrl, 
  }) async {
    _userProfile = UserProfile(
      email: email,
      firstName: firstName ?? '', 
      lastName: lastName ?? '',
      imageUrl: imageUrl ?? 'assets/images/profile.jpg', 
      notificationsEnabled: _userProfile.notificationsEnabled,
    );
    await _saveProfile(); 
    notifyListeners();
  }

  Future<void> clearUserProfile() async {
    _userProfile = UserProfile.defaultProfile(); 

    notifyListeners();
  }
}
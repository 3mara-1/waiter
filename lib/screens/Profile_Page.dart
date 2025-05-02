import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiter/screens/Favorites_Page.dart';
import 'package:waiter/screens/login_screen.dart';
import 'package:waiter/screens/edit_profile_screen.dart';
import 'package:waiter/providers/user_profile_notifier.dart';
import 'package:waiter/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFFFF5C00);

    return Consumer<UserProfileNotifier>(
      builder: (context, userProfileNotifier, child) {
        final userProfile = userProfileNotifier.userProfile;

        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildProfileHeader(themeColor, userProfile),
              const SizedBox(height: 20),
              _buildProfileOption(
                context,
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const EditProfileScreen())
                  );
                },
              ),
              _buildProfileOption(
                context,
                icon: Icons.favorite_border,
                title: 'My Favorites',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
                },
              ),
              _buildNotificationOption(
                themeColor,
                userProfile.notificationsEnabled,
                (bool value) {
                  userProfileNotifier.setNotificationsEnabled(value);
                },
              ),
              _buildProfileOption(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings page is not implemented yet.')),
                  );
                },
              ),
              _buildProfileOption(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support page is not implemented yet.')),
                  );
                },
              ),
              const Divider(height: 40, indent: 16, endIndent: 16),
              _isLoggingOut
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _buildProfileOption(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      isLogout: true,
                      onTap: _handleLogout,
                    ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Handle logout with AuthService
  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });
    
    try {
      // Logout using AuthService
      await AuthService.logout();
      
      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to logout. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Widget _buildProfileHeader(Color themeColor, UserProfile userProfile) {
    String fullName = '${userProfile.firstName} ${userProfile.lastName}';
    // If both names are empty, use legacy name property as fallback
    if (fullName.trim().isEmpty) {
      fullName = userProfile.name;
    }

    return Container(
      color: themeColor,
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(userProfile.imageUrl),
            onBackgroundImageError: (_, __) {},
            child: Image.asset(userProfile.imageUrl, errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.person, size: 60, color: Colors.grey);
            }),
          ),
          const SizedBox(height: 12),
          Text(
            fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userProfile.email,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, bool isLogout = false}) {
    final color = isLogout ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color;
    final iconColor = isLogout ? Colors.red : const Color(0xFFFF5C00);

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildNotificationOption(Color themeColor, bool notificationsEnabled, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: const Text('Enable Notifications', style: TextStyle(fontSize: 16)),
      value: notificationsEnabled,
      onChanged: onChanged,
      secondary: Icon(Icons.notifications_none_outlined, color: themeColor),
      activeColor: themeColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
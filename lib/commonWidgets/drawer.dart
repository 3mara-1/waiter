import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // استيراد provider
import 'package:waiter/providers/user_profile_notifier.dart'; // استيراد Notifier


class Drawerscreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // استخدم Consumer للاستماع لبيانات المستخدم
    return Consumer<UserProfileNotifier>(
      builder: (context, userProfileNotifier, child) {
        final userProfile = userProfileNotifier.userProfile;

        return Drawer(child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFF5C00),
              ),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // عرض اسم المستخدم من الـ Notifier
                  Text(
                    userProfile.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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
            ),
            //            ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Home'),
            //   onTap: (){},
            // ),
          ],
        ),
        );
      },
    );
  }
}
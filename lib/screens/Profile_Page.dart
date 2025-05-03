import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:waiter/screens/Favorites_Page.dart'; // <-- إزالة الاستيراد غير المستخدم
import 'package:waiter/screens/login_screen.dart';
import 'package:waiter/screens/edit_profile_screen.dart'; // <-- تأكد من وجود هذه الشاشة
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

    // استخدام Consumer للاستماع إلى التغييرات في UserProfileNotifier
    return Consumer<UserProfileNotifier>(
      builder: (context, userProfileNotifier, child) {
        // التحقق من حالة التحميل قبل عرض المحتوى
        if (userProfileNotifier.isLoading) {
          return Scaffold( // عرض شاشة تحميل
            body: Center(
              child: CircularProgressIndicator(color: themeColor),
            ),
          );
        }

        final userProfile = userProfileNotifier.userProfile;

        // عرض الواجهة الرئيسية بعد انتهاء التحميل
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
                  ).then((_) {
                     // يمكنك إضافة منطق لتحديث الواجهة هنا إذا لزم الأمر بعد العودة من التعديل
                     // على سبيل المثال، إعادة تحميل البروفايل إذا لم يكن Notifier يقوم بذلك تلقائيًا
                  });
                },
              ),
              // --- تم إزالة خيار "My Favorites" من هنا ---
              // _buildProfileOption(
              //   context,
              //   icon: Icons.favorite_border,
              //   title: 'My Favorites',
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
              //   },
              // ),
              _buildNotificationOption( // خيار الإشعارات
                themeColor,
                userProfile.notificationsEnabled,
                (bool value) {
                  // تحديث حالة الإشعارات عبر Notifier
                  userProfileNotifier.setNotificationsEnabled(value);
                },
              ),
              _buildProfileOption( // خيار الإعدادات
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  // يمكنك الانتقال إلى شاشة الإعدادات الفعلية هنا
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings page is not implemented yet.')),
                  );
                },
              ),
              _buildProfileOption( // خيار المساعدة
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  // يمكنك الانتقال إلى شاشة المساعدة الفعلية هنا
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support page is not implemented yet.')),
                  );
                },
              ),
              const Divider(height: 40, indent: 16, endIndent: 16), // فاصل
              _isLoggingOut // التحقق من حالة تسجيل الخروج
                  ? const Center( // عرض مؤشر الدوران أثناء تسجيل الخروج
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _buildProfileOption( // زر تسجيل الخروج
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      isLogout: true, // لتطبيق التنسيق الخاص بتسجيل الخروج
                      onTap: _handleLogout, // استدعاء دالة تسجيل الخروج
                    ),
              const SizedBox(height: 20), // مسافة سفلية
            ],
          ),
        );
      },
    );
  }

  // --- دالة تسجيل الخروج (تبقى كما هي غالبًا) ---
  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true; // بدء عملية تسجيل الخروج (لعرض مؤشر الدوران)
    });

    try {
      // استدعاء دالة تسجيل الخروج من AuthService
      final loggedOut = await AuthService.logout();

      if (loggedOut && mounted) {
        // مسح بيانات المستخدم من Notifier بعد تسجيل الخروج بنجاح
        Provider.of<UserProfileNotifier>(context, listen: false).clearUserProfile();

        // الانتقال إلى شاشة تسجيل الدخول وإزالة جميع الشاشات السابقة
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()), // تأكد من اسم شاشة تسجيل الدخول
          (route) => false, // إزالة جميع المسارات السابقة
        );
      } else if (mounted) {
         // التعامل مع حالة فشل تسجيل الخروج (نادر مع SharedPreferences ولكن جيد للتحقق)
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout failed. Please try again.')),
          );
      }
    } catch (e) {
       // التعامل مع أي أخطاء غير متوقعة
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during logout.')),
        );
         print("Logout error: $e");
      }
    } finally {
       // التأكد من إيقاف مؤشر الدوران حتى لو حدث خطأ
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  // --- الويدجت المساعدة لبناء رأس الملف الشخصي ---
  Widget _buildProfileHeader(Color themeColor, UserProfile userProfile) {
    // بناء الاسم الكامل، وعرض البريد الإلكتروني إذا كان الاسم فارغًا
    String fullName = '${userProfile.firstName} ${userProfile.lastName}'.trim();
    if (fullName.isEmpty) {
      fullName = userProfile.email; // عرض البريد كاسم افتراضي
    }

    return Container(
      color: themeColor, // استخدام لون الثيم للخلفية
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10, // إضافة padding علوي آمن
          bottom: 20,
          left: 16,
          right: 16),
      child: Column(
        children: [
          CircleAvatar( // عرض صورة المستخدم
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.8), // خلفية للصورة
            backgroundImage: AssetImage(userProfile.imageUrl), // محاولة تحميل الصورة من المسار
            // معالج خطأ إذا فشلت الصورة في التحميل
            onBackgroundImageError: (_, __) {
              print("Error loading profile image: ${userProfile.imageUrl}");
            },
            child: ClipOval( // قص الصورة بشكل دائري
              child: Image.asset(
                userProfile.imageUrl,
                fit: BoxFit.cover, // تغطية المساحة
                width: 100,
                height: 100,
                // عرض أيقونة افتراضية في حالة الخطأ
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 60, color: Colors.grey);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text( // عرض الاسم الكامل
            fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          // عرض البريد الإلكتروني فقط إذا كان الاسم الكامل ليس هو البريد الإلكتروني
          if (fullName != userProfile.email) ...[
            const SizedBox(height: 4),
            Text(
              userProfile.email,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ]
        ],
      ),
    );
  }

  // --- الويدجت المساعدة لبناء خيارات الملف الشخصي ---
  Widget _buildProfileOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, bool isLogout = false}) {
    // تحديد اللون بناءً على ما إذا كان خيار تسجيل الخروج أم لا
    final color = isLogout ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color;
    final iconColor = isLogout ? Colors.red : const Color(0xFFFF5C00);

    return ListTile(
      leading: Icon(icon, color: iconColor), // الأيقونة
      title: Text(title, style: TextStyle(color: color, fontSize: 16)), // عنوان الخيار
      trailing: isLogout ? null : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // سهم الانتقال (ما عدا لتسجيل الخروج)
      onTap: onTap, // الدالة التي تُنفذ عند الضغط
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // الحشو الداخلي
    );
  }

  // --- الويدجت المساعدة لبناء خيار الإشعارات ---
  Widget _buildNotificationOption(Color themeColor, bool notificationsEnabled, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: const Text('Enable Notifications', style: TextStyle(fontSize: 16)), // عنوان الخيار
      value: notificationsEnabled, // القيمة الحالية للمفتاح
      onChanged: onChanged, // الدالة التي تُنفذ عند تغيير القيمة
      secondary: Icon(Icons.notifications_none_outlined, color: themeColor), // الأيقونة
      activeColor: themeColor, // لون المفتاح عند التفعيل
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // الحشو الداخلي
    );
  }
}
import 'package:flutter/material.dart';
import 'package:waiter/model/feed_model.dart'; // تأكد من المسار الصحيح لملف الموديل

// الكلاس الذي سيدير حالة العناصر المفضلة
class FavoritesNotifier with ChangeNotifier {
  // قائمة العناصر المفضلة
  // في البداية، نقوم بتهيئة القائمة بالعناصر التي تم تعليمها كمفضلة في feedItems الافتراضية
  // في تطبيق حقيقي، ستحتاج لتحميل هذه من التخزين الدائم عند بدء التطبيق
  List<FeedItem> _favoriteItems = List.from(feedItems.where((item) => item.isFavorite));

  // Getter للوصول إلى قائمة المفضلة
  List<FeedItem> get favoriteItems => _favoriteItems;

  // دالة لإضافة أو إزالة عنصر من المفضلة وتحديث القائمة الأصلية
  void toggleFavoriteStatus(FeedItem item) {
    // العثور على العنصر في القائمة الأصلية feedItems
    final indexInFeedItems = feedItems.indexWhere((feedItem) => feedItem.title == item.title);

    if (indexInFeedItems != -1) {
      // تبديل حالة المفضلة في القائمة الأصلية (مصدر الحقيقة لجميع العناصر)
      feedItems[indexInFeedItems].isFavorite = !feedItems[indexInFeedItems].isFavorite;

      // إعادة بناء قائمة المفضلة في الـ Notifier بناءً على القائمة الأصلية المحدثة
      _favoriteItems = List.from(feedItems.where((item) => item.isFavorite));

      notifyListeners(); // أخبر الـ Widgets المستمعة (FavoritesPage, LayoutPage, Shop) أن القائمة قد تغيرت
    }
  }

  // دالة مساعدة للتحقق مما إذا كان العنصر مفضلاً
  bool isItemFavorite(FeedItem item) {
    // بما أننا نحدث isFavorite مباشرة في feedItems، يمكننا التحقق منها
    return item.isFavorite;
    // أو يمكن التحقق من قائمة _favoriteItems الداخلية إذا كنت تفضل ذلك:
    // return _favoriteItems.any((favItem) => favItem.title == item.title);
  }

  // يمكنك إضافة دوال أخرى هنا لتحميل وحفظ حالة المفضلة من/إلى التخزين الدائم
}
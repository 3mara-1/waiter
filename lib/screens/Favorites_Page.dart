import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // استيراد provider
import 'package:waiter/model/feed_model.dart';
import 'package:waiter/screens/shop_profile.dart';
// استيراد ملف FavoritesNotifier (تأكد من المسار الصحيح)
import 'package:waiter/providers/favorites_notifier.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  // لم نعد بحاجة لقائمة favoriteItems المحلية أو دالة _toggleFavorite هنا

  @override
  void initState() {
    super.initState();
    // لا حاجة للتهيئة هنا، الـ Notifier يدير القائمة
  }

  @override
  Widget build(BuildContext context) {
    // استخدم Consumer للاستماع إلى التغييرات في FavoritesNotifier
    return Consumer<FavoritesNotifier>(
      builder: (context, favoritesNotifier, child) {
        // احصل على قائمة المفضلة من الـ Notifier
        final favoriteItems = favoritesNotifier.favoriteItems;

        return Scaffold(
         
          body: favoriteItems.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Color(0xFFFF5C00),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add some places to your favorites',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favoriteItems[index];
                    // مرر الـ Notifier إلى buildFavoriteCard
                    return buildFavoriteCard(context, item, favoritesNotifier);
                  },
                ),
        );
      },
    );
  }

  // ويدجت بناء بطاقة العنصر المفضل (الآن يأخذ FavoritesNotifier كوسيط)
  Widget buildFavoriteCard(BuildContext context, FeedItem item, FavoritesNotifier favoritesNotifier) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // Shop page سيستخدم أيضًا FavoritesNotifier
              builder: (context) => Shop(item: item),
            ),
          ).then((_) {
            // لا حاجة لـ setState هنا بعد العودة، لأن Provider سيحدث الواجهة تلقائيًا
            // عندما تتغير حالة المفضلة في Shop ويتم استدعاء notifyListeners
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // Image placeholder with fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 70,
                  height: 70,
                  color: Colors.white,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset(
                      item.imagePath,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image,
                          color: Color(0xFFFF5C00),
                          size: 32,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFF5C00),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Favorite icon
              IconButton(
                // تحقق من حالة المفضلة باستخدام isItemFavorite من الـ Notifier
                icon: Icon(
                  favoritesNotifier.isItemFavorite(item) ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFFF5C00),
                ),
                // استخدم دالة toggleFavoriteStatus من الـ Notifier لتغيير الحالة
                onPressed: () {
                   favoritesNotifier.toggleFavoriteStatus(item);
                   // يمكنك إظهار SnackBar هنا أيضًا إذا أردت
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                       content: Text(favoritesNotifier.isItemFavorite(item) ? 'Added to favorites' : 'Removed from favorites'),
                       duration: const Duration(seconds: 1),
                     ),
                   );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
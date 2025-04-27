import 'package:flutter/material.dart';
import 'package:waiter/model/feed_model.dart';
import 'package:waiter/screens/shop_profile.dart';
// import 'package:waiter/commonWidgets/drawer.dart';
// import 'package:waiter/commonWidgets/custom_navigation_bar.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);
  @override
  State<FavoritesPage> createState() => _FeedPageState();
}
class _FeedPageState extends State<FavoritesPage> {
  
  // Sample data
  final List<FeedItem> _feedItems = [
    FeedItem(
      title: "Coastal Paradise",
      subtitle: "Oceanfront getaway",
      imagePath: "assets/images/p7.jpg",
      isFavorite: true
    ),
    FeedItem(
      title: "Mountain Retreat",
      subtitle: "Alpine adventure",
      imagePath: "assets/images/p2.jpg",
      isFavorite:true
    ),
    FeedItem(
      title: "Urban Escape",
      subtitle: "City exploration",
      imagePath: "assets/images/p3.jpg",
      isFavorite: true
    ),
    FeedItem(
      title: "Countryside Lodge",
      subtitle: "Rural relaxation",
      imagePath: "assets/images/p4.jpg",
      isFavorite: true
    ),
    FeedItem(
      title: "Lakeside Haven",
      subtitle: "Waterfront views",
      imagePath: "assets/images/p5.jpg",
      isFavorite: true
    ),
    FeedItem(
      title: "Desert Oasis",
      subtitle: "Southwest serenity",
      imagePath: "assets/images/p6.jpg",
      isFavorite: true
    ),
  ];

  void _toggleFavorite(int index) {
    setState(() {


      final item = _feedItems[index];
      if (item.isFavorite) {
      // لو كان مفضلاً وانلغى، نحذفه من الليست
      _feedItems.removeAt(index);
    } else {
      _feedItems[index] = FeedItem(
        title: item.title,
        subtitle: item.subtitle,
        imagePath: item.imagePath,
        isFavorite: !item.isFavorite,
      );
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
      
       ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _feedItems.length,
        itemBuilder: (context, index) {
          final item = _feedItems[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Container(
              child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(item: item),
        ),
      );
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
                        color:Colors.white,
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
                      icon: Icon(
                        item.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFFFF5C00),
                      ),
                      onPressed: () => _toggleFavorite(index),
                    ),
                  ],
                ),
              ),
            ),
          ),
          );
        },
      
    );
  }
}
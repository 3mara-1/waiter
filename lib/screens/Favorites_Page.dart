import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:waiter/model/feed_model.dart';
import 'package:waiter/screens/shop_profile.dart';
import 'package:waiter/providers/favorites_notifier.dart';

class FavoritesPage extends StatefulWidget {
  

  @override
  State<FavoritesPage> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Consumer<FavoritesNotifier>(
      builder: (context, favoritesNotifier, child) {
   
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
                 
                    return buildFavoriteCard(context, item, favoritesNotifier);
                  },
                ),
        );
      },
    );
  }

  
  Widget buildFavoriteCard(BuildContext context, FeedItem item, FavoritesNotifier favoritesNotifier) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
             
              builder: (context) => Shop(item: item),
            ),
          ).then((_) {
            
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              
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
              
              IconButton(
                icon: Icon(
                  favoritesNotifier.isItemFavorite(item) ? Icons.favorite : Icons.favorite_border,
                  color: const Color(0xFFFF5C00),
                ),
                onPressed: () {
                   favoritesNotifier.toggleFavoriteStatus(item);
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
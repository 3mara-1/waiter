import 'package:flutter/material.dart';
import 'package:waiter/model/feed_model.dart';

class FavoritesNotifier with ChangeNotifier {

  List<FeedItem> _favoriteItems = List.from(feedItems.where((item) => item.isFavorite));

 
  List<FeedItem> get favoriteItems => _favoriteItems;

  void toggleFavoriteStatus(FeedItem item) { 

    final indexInFeedItems = feedItems.indexWhere((feedItem) => feedItem.title == item.title);
    if (indexInFeedItems != -1) {
      feedItems[indexInFeedItems].isFavorite = !feedItems[indexInFeedItems].isFavorite;
      _favoriteItems = List.from(feedItems.where((item) => item.isFavorite));
      notifyListeners(); 
    }
  }
  bool isItemFavorite(FeedItem item) {
    return item.isFavorite;
  }

}
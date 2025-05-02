import 'package:flutter/material.dart';

class SearchQueryNotifier with ChangeNotifier {
  String _searchQuery = "";

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners(); // أخبر المستمعين أن نص البحث تغير
  }
}
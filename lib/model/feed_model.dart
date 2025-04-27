class FeedItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isFavorite;

  
  FeedItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.isFavorite = false,
  });
}
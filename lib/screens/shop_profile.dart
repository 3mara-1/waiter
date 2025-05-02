import 'package:flutter/material.dart';
import 'package:waiter/model/feed_model.dart';

class Shop extends StatefulWidget {
  final FeedItem item;

  const Shop({Key? key, required this.item}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  late Restaurant restaurant;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Find the restaurant that matches the feed item
    findRestaurant();
  }

  void findRestaurant() {
    // This would normally be an API call or database query
    // For now, we'll simulate with a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Find restaurant by matching the feed item title
      for (var i = 0; i < restaurants.length; i++) {
        if (restaurants[i].feed.title == widget.item.title) {
          setState(() {
            restaurant = restaurants[i];
            isLoading = false;
          });
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF5C00)))
          : CustomScrollView(
              slivers: [
                // Image AppBar
                SliverAppBar(
                  expandedHeight: 300.0,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.item.subtitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Image background
                        Image.asset(
                          widget.item.imagePath,
                          fit: BoxFit.cover,
                        ),
                        // Gradient overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFFFF5C00)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        widget.item.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color:Color(0xFFFF5C00),
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle favorite status
                          restaurant.isFavorite = !restaurant.isFavorite;
                          restaurant.syncFavoriteStatus();
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.item.isFavorite
                                  ? 'Removed from favorites'
                                  : 'Added to favorites'
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                
                // Restaurant content - reusing your existing implementation
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rating section
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF5C00),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.white, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      restaurant.rating.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Description
                          const Text(
                            'About',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            restaurant.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Contact information
                          const Text(
                            'Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InfoItem(
                            icon: Icons.access_time,
                            title: 'Opening Hours',
                            content: restaurant.openingHours,
                          ),
                          InfoItem(
                            icon: Icons.location_on,
                            title: 'Address',
                            content: restaurant.address,
                          ),
                          InfoItem(
                            icon: Icons.phone,
                            title: 'Phone',
                            content: restaurant.phoneNumber,
                          ),
                          InfoItem(
                            icon: Icons.email,
                            title: 'Email',
                            content: restaurant.email,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Social links
                          const Text(
                            'Social Media',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            children: [
                              SocialButton(
                                icon: Icons.facebook,
                                onPressed: () {
                                  // Open Facebook link
                                },
                              ),
                              SocialButton(
                                icon: Icons.camera_alt,
                                onPressed: () {
                                  // Open Instagram link
                                },
                              ),
                              SocialButton(
                                icon: Icons.web,
                                onPressed: () {
                                  // Open website
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Menu section
                          const Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Menu items
                          ...restaurant.menu.map((item) => MenuItemCard(
                            menuItem: item,
                          )).toList(),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}

// Helper widgets for shop details remain the same
class InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const InfoItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFF5C00), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SocialButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF5C00),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;

  const MenuItemCard({Key? key, required this.menuItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant_menu, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          menuItem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${menuItem.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5C00),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    menuItem.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Color(0xFFFF5C00),
                        ),
                        onPressed: () {
                          // Add to order functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
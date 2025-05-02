class FeedItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final String category;  // Added category property
  final double rating;    // Added rating property
  bool isFavorite;

  FeedItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.category,
    required this.rating,
    this.isFavorite = false,
  });
  
  // Clone method to create a new instance with updated values
  FeedItem copyWith({
    String? title,
    String? subtitle,
    String? imagePath,
    String? category,
    double? rating,
    bool? isFavorite,
  }) {
    return FeedItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

List<FeedItem> feedItems = [
  FeedItem(
    title: "Coastal Paradise",
    subtitle: "Oceanfront getaway",
    imagePath: "assets/images/p7.jpg",
    category: "Restaurants",
    rating: 4.7,
    isFavorite: false
  ),
  FeedItem(
    title: "Mountain Retreat",
    subtitle: "Alpine adventure",
    imagePath: "assets/images/p2.jpg",
    category: "Cafes",
    rating: 4.5,
    isFavorite: false
  ),
  FeedItem(
    title: "Urban Escape",
    subtitle: "City exploration",
    imagePath: "assets/images/p3.jpg",
    category: "Restaurants",
    rating: 4.8,
    isFavorite: false
  ),
  FeedItem(
    title: "Countryside Lodge",
    subtitle: "Rural relaxation",
    imagePath: "assets/images/p4.jpg",
    category: "Restaurants",
    rating: 4.6,
    isFavorite: false
  ),
  FeedItem(
    title: "Lakeside Haven",
    subtitle: "Waterfront views",
    imagePath: "assets/images/p5.jpg",
    category: "Cafes",
    rating: 4.9,
    isFavorite: false
  ),
  FeedItem(
    title: "Desert Oasis",
    subtitle: "Southwest serenity",
    imagePath: "assets/images/p6.jpg",
    category: "Bakeries",
    rating: 4.7,
    isFavorite: false
  ),
];

class MenuItem {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Restaurant {
  final String id;
  final String description;
  final double rating;
  final List<String> socialLinks;
  final String address;
  final String phoneNumber;
  final String email;
  final String openingHours;
  final List<MenuItem> menu;
  bool isFavorite;
  final FeedItem feed;
  
  Restaurant({
    required this.id,
    required this.description,
    required this.rating,
    required this.socialLinks,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.openingHours,
    required this.menu,
    this.isFavorite = false,
    required this.feed,
  });
  
  // Method to sync the favorite status with related FeedItem
  void syncFavoriteStatus() {
    // Find the corresponding feedItem and update its status
    for (var item in feedItems) {
      if (item.title == feed.title) {
        item.isFavorite = isFavorite;
        break;
      }
    }
  }
}

// Create a list of restaurants corresponding to feedItems
List<Restaurant> restaurants = [
    Restaurant(
      id: '1',
      feed: feedItems[0],
      description: 'Experience the best seafood while enjoying breathtaking ocean views. Our restaurant offers fresh, locally sourced seafood prepared with unique and flavorful recipes.',
      rating: 4.7,
      socialLinks: ['facebook.com/coastalparadise', 'instagram.com/coastalparadise'],
      address: '123 Ocean Drive, Beachside, CA 90210',
      phoneNumber: '(555) 123-4567',
      email: 'info@coastalparadise.com',
      openingHours: 'Mon-Fri: 11:00 AM - 10:00 PM, Sat-Sun: 10:00 AM - 11:00 PM',
      menu: [
        MenuItem(
          name: 'Grilled Sea Bass',
          description: 'Fresh sea bass grilled to perfection with lemon herb butter',
          price: 24.99,
          imageUrl: 'assets/sea_bass.jpg',
        ),
        MenuItem(
          name: 'Lobster Linguine',
          description: 'Homemade linguine with fresh lobster in a creamy sauce',
          price: 28.99,
          imageUrl: 'assets/lobster_linguine.jpg',
        ),
        MenuItem(
          name: 'Seafood Platter',
          description: 'Assortment of fried calamari, prawns, and fish with dipping sauces',
          price: 32.99,
          imageUrl: 'assets/seafood_platter.jpg',
        ),
      ],
      isFavorite: true,
    ),
    Restaurant(
      id: '2',
      feed: feedItems[1],
      description: 'A cozy mountain restaurant offering hearty meals with stunning alpine views. Our menu features locally sourced ingredients and traditional mountain recipes.',
      rating: 4.5,
      socialLinks: ['facebook.com/mountainretreat', 'instagram.com/mountainretreat'],
      address: '456 Pine Ridge, Alpine, CO 80517',
      phoneNumber: '(555) 234-5678',
      email: 'info@mountainretreat.com',
      openingHours: 'Daily: 8:00 AM - 9:00 PM',
      menu: [
        MenuItem(
          name: 'Alpine Cheese Fondue',
          description: 'Traditional cheese fondue with artisan bread and vegetables',
          price: 22.99,
          imageUrl: 'assets/cheese_fondue.jpg',
        ),
        MenuItem(
          name: 'Venison Steak',
          description: 'Grilled venison steak with mushroom sauce and roasted potatoes',
          price: 34.99,
          imageUrl: 'assets/venison_steak.jpg',
        ),
        MenuItem(
          name: 'Mountain Berry Pie',
          description: 'Warm berry pie with mixed seasonal berries and vanilla ice cream',
          price: 12.99,
          imageUrl: 'assets/berry_pie.jpg',
        ),
      ],
      isFavorite: true,
    ),
    Restaurant(
      id: '3',
      feed: feedItems[2],
      description: 'Modern fusion cuisine in the heart of downtown. Our innovative chefs blend international flavors to create unique culinary experiences.',
      rating: 4.8,
      socialLinks: ['facebook.com/urbanescape', 'instagram.com/urbanescape'],
      address: '789 Metro Ave, Downtown, NY 10001',
      phoneNumber: '(555) 345-6789',
      email: 'info@urbanescape.com',
      openingHours: 'Mon-Thu: 11:00 AM - 11:00 PM, Fri-Sat: 11:00 AM - 1:00 AM, Sun: 10:00 AM - 10:00 PM',
      menu: [
        MenuItem(
          name: 'Sushi Fusion Platter',
          description: 'Selection of innovative sushi rolls with international influences',
          price: 36.99,
          imageUrl: 'assets/sushi_fusion.jpg',
        ),
        MenuItem(
          name: 'Truffle Risotto',
          description: 'Creamy risotto with wild mushrooms and truffle oil',
          price: 29.99,
          imageUrl: 'assets/truffle_risotto.jpg',
        ),
        MenuItem(
          name: 'Molecular Dessert Trio',
          description: 'Three experimental desserts using molecular gastronomy techniques',
          price: 18.99,
          imageUrl: 'assets/molecular_dessert.jpg',
        ),
      ],
      isFavorite: true,
    ),
    Restaurant(
      id: '4',
      feed: feedItems[3],
      description: 'Family-owned farmhouse restaurant offering traditional comfort food in a rustic setting. We use fresh ingredients from our own farm and local producers.',
      rating: 4.6,
      socialLinks: ['facebook.com/countrysidelodge', 'instagram.com/countrysidelodge'],
      address: '1010 Farmland Road, Greenfield, VT 05648',
      phoneNumber: '(555) 456-7890',
      email: 'info@countrysidelodge.com',
      openingHours: 'Wed-Sun: 8:00 AM - 8:00 PM, Mon-Tue: Closed',
      menu: [
        MenuItem(
          name: 'Farm Breakfast',
          description: 'Farm-fresh eggs, bacon, homemade sausage, and sourdough toast',
          price: 16.99,
          imageUrl: 'assets/farm_breakfast.jpg',
        ),
        MenuItem(
          name: 'Chicken Pot Pie',
          description: 'Homemade pot pie with free-range chicken and seasonal vegetables',
          price: 21.99,
          imageUrl: 'assets/chicken_pot_pie.jpg',
        ),
        MenuItem(
          name: 'Apple Cider Donut',
          description: 'Warm donuts made with local apple cider and cinnamon sugar',
          price: 8.99,
          imageUrl: 'assets/apple_donut.jpg',
        ),
      ],
      isFavorite: true,
    ),
    Restaurant(
      id: '5',
      feed: feedItems[4],
      description: 'Elegant dining experience with panoramic lake views. Our chef specializes in fresh fish and seasonal ingredients from the surrounding region.',
      rating: 4.9,
      socialLinks: ['facebook.com/lakesidehaven', 'instagram.com/lakesidehaven'],
      address: '222 Lakeshore Drive, Clear Lake, MN 56333',
      phoneNumber: '(555) 567-8901',
      email: 'reservations@lakesidehaven.com',
      openingHours: 'Tue-Sun: 5:00 PM - 10:00 PM, Mon: Closed',
      menu: [
        MenuItem(
          name: 'Lake Trout',
          description: 'Locally caught trout with herb butter and wild rice pilaf',
          price: 27.99,
          imageUrl: 'assets/lake_trout.jpg',
        ),
        MenuItem(
          name: 'Duck Confit',
          description: 'Slow-cooked duck leg with cherry reduction and roasted vegetables',
          price: 32.99,
          imageUrl: 'assets/duck_confit.jpg',
        ),
        MenuItem(
          name: 'Blueberry Lavender Tart',
          description: 'Wild blueberry tart with lavender cream and honey drizzle',
          price: 14.99,
          imageUrl: 'assets/blueberry_tart.jpg',
        ),
      ],
      isFavorite: true,
    ),
    Restaurant(
      id: '6',
      feed: feedItems[5],
      description: 'Southwestern-inspired restaurant featuring bold flavors and desert ingredients. Our outdoor patio offers stunning sunset views over the canyon.',
      rating: 4.7,
      socialLinks: ['facebook.com/desertoasis', 'instagram.com/desertoasis'],
      address: '444 Canyon Road, Mesa Springs, AZ 85201',
      phoneNumber: '(555) 678-9012',
      email: 'hello@desertoasis.com',
      openingHours: 'Daily: 11:00 AM - 9:00 PM',
      menu: [
        MenuItem(
          name: 'Prickly Pear Cactus Salad',
          description: 'Fresh cactus with citrus dressing, pepitas, and queso fresco',
          price: 14.99,
          imageUrl: 'assets/cactus_salad.jpg',
        ),
        MenuItem(
          name: 'Mesquite Grilled Steak',
          description: 'Prime beef grilled over mesquite wood with chimichurri sauce',
          price: 38.99,
          imageUrl: 'assets/mesquite_steak.jpg',
        ),
        MenuItem(
          name: 'Ancho Chili Chocolate Cake',
          description: 'Rich chocolate cake with hint of ancho chili and caramel sauce',
          price: 12.99,
          imageUrl: 'assets/chocolate_cake.jpg',
        ),
      ],
      isFavorite: true,
    ),
  ];
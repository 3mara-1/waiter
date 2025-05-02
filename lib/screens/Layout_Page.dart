import 'package:flutter/material.dart';
import 'package:waiter/model/feed_model.dart';
import 'package:waiter/screens/shop_profile.dart';
import 'package:provider/provider.dart'; // لا نزال نحتاج Provider للمفضلة
// استيراد FavoritesNotifier (تأكد من المسار)
import 'package:waiter/providers/favorites_notifier.dart';
// لم نعد بحاجة لاستيراد SearchQueryNotifier هنا


class LayoutPage extends StatefulWidget {
  const LayoutPage({Key? key}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  final List<String> _categories = ['All', 'Restaurants', 'Cafes', 'Bakeries', 'Fast Food'];
  String _selectedCategory = 'All';
  bool _isGridView = false;
  List<FeedItem> _filteredItems = [];
  // إعادة حقل البحث المحلي والـ Controller الخاص به
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // عند التهيئة، نقوم بفلترة أولية (قد لا يكون هناك نص بحث في البداية)
    _filterItems();

    // إضافة المستمع على controller المحلي لإعادة الفلترة عند تغيير النص
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
     // إزالة المستمع والـ dispose للـ controller المحلي
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  // دالة الفلترة تعود لاستخدام نص البحث من الـ controller المحلي
  void _filterItems() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = feedItems.where((item) {
        final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
        // الفلترة تستخدم نص البحث من الـ controller المحلي
        final matchesSearch = searchQuery.isEmpty ||
                              item.title.toLowerCase().contains(searchQuery) ||
                              item.subtitle.toLowerCase().contains(searchQuery);
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // إعادة بناء الـ Search Bar المحلي هنا
          _buildSearchBar(),

          // Category filter pills
          _buildCategoryFilter(),

          // Toggle view button
          _buildViewToggle(),

          // Content list/grid (يتم بناؤها باستخدام _filteredItems التي تم تحديثها في _filterItems)
          Expanded(
            child: _isGridView
                ? _buildGridView(_filteredItems)
                : _buildListView(_filteredItems),
          ),
        ],
      ),
    );
  }

  // إعادة دالة بناء الـ SearchBar المحلي
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController, // استخدام الـ controller المحلي
        decoration: InputDecoration(
          hintText: 'Search places...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5C00)),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        ),
         // لم نعد نستخدم onChanged لتحديث Notifier، المستمع على controller يقوم بذلك
        // onChanged: (query) {
        //   searchQueryNotifier.setSearchQuery(query);
        // },
      ),
    );
  }


  Widget _buildCategoryFilter() {
     return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              backgroundColor: Colors.grey[200],
              selectedColor: const Color(0xFFFF5C00).withOpacity(0.2),
              checkmarkColor: const Color(0xFFFF5C00),
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFF5C00) : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                   // عند تغيير الفئة، نعيد الفلترة باستخدام نص البحث الحالي في الـ controller المحلي
                   _filterItems();
                });
              },
            ),
          );
        },
      ),
    );
  }

  // بقية الدوال المتعلقة بالعرض والمفضلة لا تتغير

  // ... (بقية الكود الخاص بـ _buildViewToggle, _buildListView, _buildGridView, _buildEmptyState, _buildPlaceCard, _buildGridCard)
  // تأكد من أنها لا تزال تستخدم FavoritesNotifier كما تم التعديل سابقًا
   Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: const Color(0xFFFF5C00),
            ),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<FeedItem> items) {
    return items.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildPlaceCard(items[index]);
            },
          );
  }

  Widget _buildGridView(List<FeedItem> items) {
    return items.isEmpty
        ? _buildEmptyState()
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildGridCard(items[index]);
            },
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No places found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

   Widget _buildPlaceCard(FeedItem item) {
     final rating = item.rating;
     // لا نزال نحتاج FavoritesNotifier للمفضلة
     final favoritesNotifier = Provider.of<FavoritesNotifier>(context, listen: false);

     return Card(
       margin: const EdgeInsets.only(bottom: 16),
       elevation: 2,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12),
       ),
       child: InkWell(
         onTap: () {
           Navigator.push(
             context,
             MaterialPageRoute(
                // Shop page سيستخدم FavoritesNotifier
               builder: (context) => Shop(item: item),
             ),
           ).then((_) {
              // إعادة فلترة القائمة بعد العودة للتأكد من تحديث العرض بناءً على أي تغييرات في feedItems (مثل المفضلة)
              _filterItems(); // استخدام دالة الفلترة المحلية
           });
         },
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Stack(
               children: [
                 ClipRRect(
                   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                   child: Image.asset(
                     item.imagePath,
                     height: 160,
                     width: double.infinity,
                     fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace) {
                       return Container(
                         height: 160,
                         width: double.infinity,
                         color: Colors.grey[300],
                         child: const Icon(Icons.image_not_supported, color: Color(0xFFFF5C00), size: 48),
                       );
                     },
                   ),
                 ),
                 Positioned(
                   top: 8,
                   left: 8,
                   child: Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(
                       color: Colors.black.withOpacity(0.6),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Text(
                       item.category,
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 12,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ),
                 ),
                 Positioned(
                   top: 8,
                   right: 8,
                   child: Container(
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.8),
                       shape: BoxShape.circle,
                     ),
                      // لا يزال هذا Consumer يستخدم FavoritesNotifier
                     child: Consumer<FavoritesNotifier>(
                       builder: (context, notifier, child) {
                         return IconButton(
                           icon: Icon(
                             notifier.isItemFavorite(item) ? Icons.favorite : Icons.favorite_border,
                             color: const Color(0xFFFF5C00),
                             size: 20,
                           ),
                           onPressed: () {
                              notifier.toggleFavoriteStatus(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                 content: Text(notifier.isItemFavorite(item) ? 'Added to favorites' : 'Removed from favorites'),
                                 duration: const Duration(seconds: 1),
                               ),
                             );
                           },
                           constraints: const BoxConstraints(
                             minWidth: 36,
                             minHeight: 36,
                           ),
                           padding: EdgeInsets.zero,
                         );
                       },
                     ),
                   ),
                 ),
               ],
             ),
             Padding(
               padding: const EdgeInsets.all(12),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     item.title,
                     style: const TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 16,
                     ),
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   ),
                   Text(
                     item.subtitle,
                     style: TextStyle(
                       color: Colors.grey[600],
                       fontSize: 14,
                     ),
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       Row(
                         children: List.generate(5, (index) {
                           return Icon(
                             index < rating.floor()
                                 ? Icons.star
                                 : (index < rating
                                     ? Icons.star_half
                                     : Icons.star_border),
                             color: Colors.amber,
                             size: 16,
                           );
                         }),
                       ),
                       const SizedBox(width: 4),
                       Text(
                         rating.toString(),
                         style: const TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 12,
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 8),
                   Row(
                     children: [
                       const Icon(
                         Icons.location_on,
                         size: 14,
                         color: Colors.grey,
                       ),
                       const SizedBox(width: 2),
                       Text(
                         '${(rating * 0.5).toStringAsFixed(1)} km',
                         style: TextStyle(
                           color: Colors.grey[600],
                           fontSize: 12,
                         ),
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

   Widget _buildGridCard(FeedItem item) {
     final rating = item.rating;
      // لا نزال نحتاج FavoritesNotifier للمفضلة
     final favoritesNotifier = Provider.of<FavoritesNotifier>(context, listen: false);

     return Card(
       elevation: 2,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(12),
       ),
       child: InkWell(
         onTap: () {
           Navigator.push(
             context,
             MaterialPageRoute(
                // Shop page سيستخدم FavoritesNotifier
               builder: (context) => Shop(item: item),
             ),
           ).then((_) {
              _filterItems(); // استخدام دالة الفلترة المحلية
           });
         },
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Stack(
               children: [
                 ClipRRect(
                   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                   child: Image.asset(
                     item.imagePath,
                     height: 120,
                     width: double.infinity,
                     fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace) {
                       return Container(
                         height: 120,
                         width: double.infinity,
                         color: Colors.grey[300],
                         child: const Icon(Icons.image_not_supported, color: Color(0xFFFF5C00), size: 40),
                       );
                     },
                   ),
                 ),
                 Positioned(
                   top: 4,
                   right: 4,
                    // لا يزال هذا Consumer يستخدم FavoritesNotifier
                   child: Consumer<FavoritesNotifier>(
                     builder: (context, notifier, child) {
                       return Container(
                          decoration: BoxDecoration(
                             color: Colors.white.withOpacity(0.8),
                             shape: BoxShape.circle,
                           ),
                         child: IconButton(
                           icon: Icon(
                             notifier.isItemFavorite(item) ? Icons.favorite : Icons.favorite_border,
                             color: const Color(0xFFFF5C00),
                             size: 16,
                           ),
                           onPressed: () {
                              notifier.toggleFavoriteStatus(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                 content: Text(notifier.isItemFavorite(item) ? 'Added to favorites' : 'Removed from favorites'),
                                 duration: const Duration(seconds: 1),
                               ),
                             );
                           },
                           constraints: const BoxConstraints(
                             minWidth: 30,
                             minHeight: 30,
                           ),
                           padding: EdgeInsets.zero,
                         ),
                       );
                     }
                   ),
                 ),
               ],
             ),
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(
                       item.title,
                       style: const TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 14,
                       ),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                     ),
                     Text(
                       item.subtitle,
                       style: TextStyle(
                         color: Colors.grey[600],
                         fontSize: 12,
                       ),
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                     ),
                     Row(
                       children: [
                         Icon(
                           Icons.star,
                           color: Colors.amber,
                           size: 14,
                         ),
                         const SizedBox(width: 2),
                         Text(
                           rating.toString(),
                           style: const TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 12,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }
}
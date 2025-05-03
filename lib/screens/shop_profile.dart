import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- إضافة استيراد Provider
import 'package:waiter/model/feed_model.dart';
import 'package:waiter/providers/favorites_notifier.dart'; // <-- إضافة استيراد FavoritesNotifier

class Shop extends StatefulWidget {
  final FeedItem item;

  const Shop({Key? key, required this.item}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  // لم نعد نحتاج إلى متغير `restaurant` محلي إذا كانت كل المعلومات في `widget.item`
  // أو إذا كان Restaurant model لا يضيف معلومات إضافية جوهرية غير موجودة في FeedItem.
  // سنفترض مؤقتًا أننا لا نزال بحاجة إليه لتحميل التفاصيل الإضافية (الوصف، القائمة، إلخ)
  late Restaurant restaurant;
  bool isLoading = true;
  bool _isRestaurantFound = false; // <-- متغير لتتبع إذا تم العثور على المطعم

  @override
  void initState() {
    super.initState();
    findRestaurant();
  }

  void findRestaurant() {
    // البحث عن المطعم المطابق - محاكاة لطلب API
    Future.delayed(const Duration(milliseconds: 300), () { // تقليل التأخير قليلًا
      int foundIndex = restaurants.indexWhere((r) => r.feed.title == widget.item.title);

      // التحقق مما إذا كانت الويدجت لا تزال موجودة قبل استدعاء setState
      if (!mounted) return;

      if (foundIndex != -1) {
        setState(() {
          restaurant = restaurants[foundIndex];
          _isRestaurantFound = true; // <-- تم العثور عليه
          isLoading = false;
        });
      } else {
        // التعامل مع حالة عدم العثور على المطعم
        print("Error: Restaurant details not found for ${widget.item.title}");
        setState(() {
          isLoading = false; // إيقاف مؤشر التحميل
          _isRestaurantFound = false; // <-- لم يتم العثور عليه
        });
        // عرض رسالة خطأ والعودة للصفحة السابقة
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restaurant details not available.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // الوصول إلى الـ Notifier خارج الـ Consumer للاستخدام في أماكن متعددة إذا لزم الأمر
    // ولكن هنا سنستخدم Consumer مباشرة في AppBar ليكون التحديث محصوراً بزر الإعجاب
    // final favoritesNotifier = Provider.of<FavoritesNotifier>(context, listen: false); // لا حاجة لهذا هنا

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF5C00)))
          : !_isRestaurantFound // <-- التحقق إذا لم يتم العثور على المطعم بعد انتهاء التحميل
              ? const Center(child: Text('Failed to load restaurant details.')) // <-- عرض رسالة بديلة
              : CustomScrollView(
                  slivers: [
                    // --- AppBar المعدل ---
                    SliverAppBar(
                      expandedHeight: 250.0, // تقليل الارتفاع قليلاً
                      pinned: true, // تثبيت الـ AppBar عند التمرير
                      floating: false,
                      stretch: true, // إضافة تأثير التمدد عند السحب للأسفل
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // لون خلفية يتناسب مع الثيم
                      leading: IconButton(
                        icon: Container( // إضافة خلفية لتسهيل الرؤية
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text( // استخدام Title مباشر لتبسيط الكود
                          widget.item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0, // تصغير حجم الخط قليلاً
                            shadows: [ // إضافة ظل للنص لتحسين القراءة
                              Shadow(blurRadius: 2.0, color: Colors.black54)
                            ]
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        centerTitle: true, // توسيط العنوان
                        titlePadding: const EdgeInsets.only(bottom: 16.0, left: 50, right: 50), // تعديل الـ padding
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Image background
                            Image.asset(
                              widget.item.imagePath, // استخدام الصورة من widget.item
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container( // عرض عنصر نائب في حالة فشل تحميل الصورة
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                );
                              },
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.2),
                                    Colors.black.withOpacity(0.7),
                                  ],
                                  stops: const [0.5, 0.7, 1.0], // تعديل تدرج الألوان
                                ),
                              ),
                            ),
                          ],
                        ),
                        stretchModes: const [ // تحديد أنواع التمدد
                          StretchMode.zoomBackground,
                          StretchMode.fadeTitle,
                        ],
                      ),
                      actions: [
                        // --- استخدام Consumer لتحديث زر الإعجاب فقط ---
                        Consumer<FavoritesNotifier>(
                          builder: (context, favoritesNotifier, child) {
                            bool isCurrentlyFavorite = favoritesNotifier.isItemFavorite(widget.item);
                            return IconButton(
                              icon: Container( // إضافة خلفية لتسهيل الرؤية
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isCurrentlyFavorite ? const Color(0xFFFF5C00) : Colors.white, // تغيير اللون حسب الحالة
                                  size: 24,
                                ),
                              ),
                              onPressed: () {
                                // استدعاء دالة التبديل في الـ Notifier
                                favoritesNotifier.toggleFavoriteStatus(widget.item);

                                // إظهار SnackBar بناءً على الحالة الجديدة
                                ScaffoldMessenger.of(context).hideCurrentSnackBar(); // إخفاء أي SnackBar حالي
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isCurrentlyFavorite // إذا كانت مفضلة *قبل* الضغط، فهي الآن أُزيلت
                                          ? '"${widget.item.title}" removed from favorites'
                                          : '"${widget.item.title}" added to favorites',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: const Color(0xFFFF5C00), // لون مميز للـ SnackBar
                                    duration: const Duration(seconds: 2), // زيادة المدة قليلاً
                                  ),
                                );
                                // --- لا حاجة لـ setState هنا ---
                                // --- لا حاجة لـ restaurant.syncFavoriteStatus() ---
                              },
                            );
                          }
                        ),
                        const SizedBox(width: 8), // مسافة صغيرة
                      ],
                    ),

                    // --- بقية محتوى الصفحة (SliverList) ---
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Rating section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row( // مجموعة التقييم
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        // استخدام التقييم من restaurant إذا كان متاحًا، وإلا من widget.item
                                        (restaurant.rating > 0 ? restaurant.rating : widget.item.rating).toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                       Text(
                                         // يمكنك إضافة عدد المراجعات هنا إذا كانت متاحة
                                         '(+50 reviews)', // مثال
                                         style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                       ),
                                    ],
                                  ),
                                   // يمكنك إضافة أيقونات أخرى هنا مثل المسافة أو وقت التوصيل
                                   Row(
                                     children: [
                                      Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                                      const SizedBox(width: 2),
                                       Text(
                                         // مثال للمسافة
                                         '${(widget.item.rating * 0.5).toStringAsFixed(1)} km',
                                         style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                       ),
                                     ],
                                   )
                                ],
                              ),

                              const SizedBox(height: 24), // زيادة المسافة

                              // Description
                              if (restaurant.description.isNotEmpty) ...[
                                const Text(
                                  'About',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  restaurant.description,
                                  style: TextStyle(fontSize: 16, color: Colors.grey[800], height: 1.4), // تحسين تباعد الأسطر
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Contact information
                              const Text(
                                'Information',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16), // زيادة المسافة
                              InfoItem(
                                icon: Icons.access_time_filled, // استخدام أيقونة ممتلئة
                                title: 'Opening Hours',
                                content: restaurant.openingHours.isNotEmpty ? restaurant.openingHours : 'Not available', // قيمة افتراضية
                              ),
                              InfoItem(
                                icon: Icons.location_on,
                                title: 'Address',
                                content: restaurant.address.isNotEmpty ? restaurant.address : 'Not available',
                              ),
                              InfoItem(
                                icon: Icons.phone,
                                title: 'Phone',
                                content: restaurant.phoneNumber.isNotEmpty ? restaurant.phoneNumber : 'Not available',
                              ),
                              if (restaurant.email.isNotEmpty) // عرض البريد فقط إذا كان متاحًا
                                InfoItem(
                                  icon: Icons.email,
                                  title: 'Email',
                                  content: restaurant.email,
                                ),

                              const SizedBox(height: 24),

                              // Social links (إذا كانت متاحة)
                              // يمكنك إضافة منطق لعرض هذا القسم فقط إذا كانت هناك روابط
                              if (true) ...[ // استبدل `true` بشرط التحقق من وجود روابط
                                const Text(
                                  'Social Media',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 12), // زيادة المسافة
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 8, // إضافة تباعد رأسي
                                  children: [
                                    SocialButton(icon: Icons.facebook, onPressed: () {/* Open Facebook */}),
                                    SocialButton(icon: Icons.camera_alt, onPressed: () {/* Open Instagram */}), // قد ترغب في استخدام أيقونة Instagram مخصصة
                                    SocialButton(icon: Icons.web, onPressed: () {/* Open website */}),
                                  ],
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Menu section
                              if (restaurant.menu.isNotEmpty) ...[
                                const Text(
                                  'Menu Highlights', // تغيير العنوان
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                // استخدام ListView أفقي لعرض بعض العناصر بشكل مميز أو GridView
                                SizedBox(
                                  height: 220, // تحديد ارتفاع للـ ListView الأفقي
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: restaurant.menu.length > 5 ? 5 : restaurant.menu.length, // عرض 5 عناصر كحد أقصى
                                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                                    itemBuilder: (context, index) {
                                       return SizedBox( // تحديد عرض لبطاقة القائمة الأفقية
                                         width: 160,
                                         child: MenuItemCard(menuItem: restaurant.menu[index], isHorizontal: true),
                                       );
                                    },
                                  ),
                                ),
                                // يمكنك إضافة زر "View Full Menu" هنا
                                const SizedBox(height: 24),
                              ],

                               // يمكنك إضافة أقسام أخرى مثل "Reviews" أو "Photos" هنا
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

// --- Helper Widgets ---

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
      padding: const EdgeInsets.only(bottom: 12), // تقليل المسافة السفلية
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.3), // تعديل اللون والتباعد
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
      borderRadius: BorderRadius.circular(8), // إضافة شكل دائري للتأثير عند الضغط
      child: Container(
        padding: const EdgeInsets.all(10), // تعديل الحشو
        decoration: BoxDecoration(
          color: const Color(0xFFFF5C00).withOpacity(0.15), // لون أخف للخلفية
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFF5C00), // لون الأيقونة الرئيسي
          size: 22, // تعديل حجم الأيقونة
        ),
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final MenuItem menuItem;
  final bool isHorizontal; // لتحديد التنسيق الأفقي

  const MenuItemCard({Key? key, required this.menuItem, this.isHorizontal = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: isHorizontal ? EdgeInsets.zero : const EdgeInsets.only(bottom: 16), // إزالة الهامش في العرض الأفقي
      elevation: 1.5, // تقليل الظل
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // زوايا أكثر دائرية
      clipBehavior: Clip.antiAlias, // قص المحتوى الزائد
      child: InkWell( // إضافة تأثير الضغط
        onTap: () {
          // يمكن عرض تفاصيل العنصر هنا أو إضافته للسلة
        },
        child: isHorizontal ? _buildHorizontalLayout(context) : _buildVerticalLayout(context),
      ),
    );
  }

  // تخطيط عمودي (الافتراضي)
  Widget _buildVerticalLayout(BuildContext context) {
     return Padding(
        padding: const EdgeInsets.all(12.0), // تقليل الحشو
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset( // افتراض وجود صورة للعنصر
                menuItem.imageUrl ?? 'assets/images/dish_placeholder.png', // استخدام صورة افتراضية
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.restaurant_menu, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // تصغير الخط
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    menuItem.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]), // تصغير الخط
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${menuItem.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16, // تصغير الخط
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5C00),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFF5C00)), // تغيير الأيقونة
                        iconSize: 28, // حجم الأيقونة
                         padding: EdgeInsets.zero, // إزالة الحشو
                         constraints: const BoxConstraints(), // إزالة القيود الافتراضية
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('"${menuItem.name}" added to cart'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: const Color(0xFFFF5C00),
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
      );
  }

  // تخطيط أفقي (لقائمة الـ Highlights)
  Widget _buildHorizontalLayout(BuildContext context) {
    return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Expanded( // لجعل الصورة تملأ المساحة المتاحة
           child: ClipRRect(
             // لا حاجة لـ BorderRadius هنا لأن الـ Card يقوم بذلك
             child: Image.asset(
               menuItem.imageUrl ?? 'assets/images/dish_placeholder.png',
               width: double.infinity, // تملأ عرض البطاقة
               fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) => Container(
                 color: Colors.grey[200],
                 child: const Icon(Icons.restaurant_menu, size: 40, color: Colors.grey),
               ),
             ),
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 menuItem.name,
                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
               ),
               const SizedBox(height: 2),
                Text(
                 '\$${menuItem.price.toStringAsFixed(2)}',
                 style: const TextStyle(
                   fontSize: 14, // حجم خط السعر
                   fontWeight: FontWeight.bold,
                   color: Color(0xFFFF5C00),
                 ),
               ),
             ],
           ),
         ),
         // يمكنك إضافة زر إضافة صغير هنا إذا أردت
       ],
     );
  }
}

// --- افتراض: تعديل تعريف MenuItem في feed_model.dart ليشمل imageUrl ---
/*
class MenuItem {
  final String name;
  final String description;
  final double price;
  final String? imageUrl; // <-- إضافة حقل الصورة (اختياري)

  MenuItem({
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });
}
*/
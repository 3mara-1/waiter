import 'package:flutter/material.dart';
import 'package:waiter/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Content for onboarding pages
  final List<Map<String, dynamic>> pages = [
    {
      'centerImage': 'assets/images/food1.jpg',
      'leftBottomImage': 'assets/images/side4.jpg',
      'rightTopImage': null,
      'title': 'Add More Items',
      'subtitle': 'You can easily add new items to your offerings.',
    },
    {
      'centerImage': 'assets/images/food2.jpg',
      'leftBottomImage': null,
      'rightTopImage': null,
      'title': 'Full Control',
      'subtitle': 'Manage orders and update status from your dashboard.',
    },
    {
      'centerImage': 'assets/images/food3.jpg',
      'leftBottomImage': 'assets/images/side1.jpg',
      'rightTopImage': 'assets/images/side.jpg',
      'title': 'Browse Food Items',
      'subtitle': 'Explore a variety of delicious food options.',
    },
  ];

  void nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToEnd() {
    _controller.animateToPage(
      pages.length - 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildSideImage(String? imagePath, {bool isLeft = true}) {
    if (imagePath == null) return SizedBox.shrink();

    return Positioned(
      top: isLeft ? null : 50,
      bottom: isLeft ? 40 : null,
      left: isLeft ? -70 : null,
      right: isLeft ? null : -70,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 3,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: ClipOval(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(imagePath),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF5E5),
      body: Column(
        children: [
          // Top section: PageView
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    // Center image
                    Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.asset(pages[index]['centerImage']),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Side images (if any)
                    if (pages[index]['leftBottomImage'] != null)
                      _buildSideImage(pages[index]['leftBottomImage'], isLeft: true),
                    if (pages[index]['rightTopImage'] != null)
                      _buildSideImage(pages[index]['rightTopImage'], isLeft: false),
                  ],
                );
              },
            ),
          ),

          // Page indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(pages.length, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                width: _currentPage == index ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.deepOrange : Colors.grey[400],
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),

          // Text content below dots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  pages[_currentPage]['title'],
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  pages[_currentPage]['subtitle'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Navigation buttons (Skip / Next / Get Started)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip button (only shown before last page)
                _currentPage < pages.length - 1
                    ? TextButton(
                  onPressed: skipToEnd,
                  child: Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                )
                    : SizedBox(width: 70), // Spacer for last page
                // Next / Get Started button
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      // On last page, navigate to login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } else {
                      // Go to next page in PageView
                      nextPage();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentPage == pages.length - 1 ? "Get Started" : "Next",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
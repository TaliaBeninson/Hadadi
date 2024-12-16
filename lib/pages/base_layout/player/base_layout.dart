import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/home_page/home_page.dart';
import 'package:hadadi/pages/base_layout/drawer_widget/drawer_widget.dart';
import 'package:hadadi/pages/base_layout/player/widgets/bottom_navigation_bar.dart';
import 'package:hadadi/pages/base_layout/player/widgets/data_counts.dart';
import 'package:hadadi/pages/base_layout/player/widgets/top_bar_widget.dart';
import 'package:hadadi/pages/player/my_guarantees/my_guarantees_page.dart';
import 'package:hadadi/pages/player/my_products/my_products_page.dart';
import 'package:hadadi/pages/player/notification_page/notification_page.dart';
import 'package:hadadi/pages/player/profile_page/profile_page.dart';
import 'package:hadadi/pages/player/search_product_page/search_product/search_product_page.dart';
import 'package:hadadi/pages/welcome_page/welcome_page.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:hadadi/services/auth_service.dart';

class BaseLayout extends StatefulWidget {
  final bool isGuest;

  const BaseLayout({super.key, required this.isGuest});

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int selectedIndex = 0;
  String? userName;
  String? userEmail;
  String? userRole;
  String? profileImageUrl;
  String? userId;
  bool isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        isGuest: widget.isGuest,
      ),
      const MyGuaranteesPage(),
      const SearchProductPage(),
      const MyProductsPage(),
      const NotificationPage(),
    ];

    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Directionality(
            textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xFFF1F1F1),
              appBar: selectedIndex == 2
                  ? AppBar(
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          onItemTapped(0);
                        },
                      ),
                      backgroundColor: const Color(0xFFFF5A1F),
                      elevation: 0,
                      title: Text(
                        translate('base_layout.search_product'),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )
                  : TopBarWidget(
                      profileImageUrl: profileImageUrl,
                      onProfileTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      onSearchTap: () {
                        onItemTapped(2);
                      },
                    ),
              drawer: selectedIndex != 2
                  ? DrawerWidget(
                      name: userName,
                      email: userEmail,
                      profileImageUrl: profileImageUrl,
                      role: userRole,
                      onLogout: _logout,
                      onNavigate: onItemTapped,
                      userID: userId,
                    )
                  : null,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return selectedIndex != 2
                      ? [
                          const SliverToBoxAdapter(
                            child: DataCounts(),
                          ),
                        ]
                      : [];
                },
                body: pages[selectedIndex],
              ),
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: selectedIndex,
                onItemTapped: onItemTapped,
              ),
            ),
          );
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await _authService.signOut();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(translate('auth.logout_failed'))),
      );
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _fetchUserData() async {
    if (widget.isGuest) {
      setState(() {
        userName = translate('home.guest');
        userEmail = 'guest@example.com';
        userRole = 'guest';
        profileImageUrl = null;
        isLoading = false;
      });
    } else {
      final userService = UserService();
      userId = await userService.getCurrentUserId();

      if (userId != null) {
        final userData = await userService.getUserData(userId!);

        if (userData != null) {
          setState(() {
            userName = userData['name'] ?? translate('home.user');
            userEmail = userData['email'] ?? 'unknown@example.com';
            userRole = userData['role'] ?? 'קונה';
            profileImageUrl = userData['profilePic'];
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}

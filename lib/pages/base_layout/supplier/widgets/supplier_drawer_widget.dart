import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/profile_page/profile_page.dart';
import 'package:hadadi/pages/base_layout/drawer_widget/widgets/header_widget.dart';
import 'package:hadadi/pages/base_layout/drawer_widget/widgets/item_widget.dart';
import 'package:hadadi/pages/base_layout/drawer_widget/widgets/logout_tile_widget.dart';
import 'package:hadadi/pages/base_layout/player/base_layout.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';

class SupplierDrawerWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? role;
  final String? profileImageUrl;
  final VoidCallback onLogout;
  final Function(int) onNavigate;

  const SupplierDrawerWidget({
    super.key,
    this.name,
    this.email,
    this.role,
    this.profileImageUrl,
    required this.onLogout,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.9,
      backgroundColor: const Color(0xFFF2F2F2),
      child: Column(
        children: [
          HeaderWidget(
            name: name,
            email: email,
            profileImageUrl: profileImageUrl,
            onProfileTap: () => onNavigate(4),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: role == 'קונה'
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomButton(
                      text: translate('base_layout.play'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BaseLayout(isGuest: false),
                        ),
                      ),
                      backgroundColor: const Color(0xff000089),
                      textColor: Colors.white,
                    ),
                  )
                : Center(
                    child: Text(
                      translate('base_layout.register_player'),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFFFFF).withOpacity(0.8),
                      offset: const Offset(-8, -8),
                      blurRadius: 16,
                    ),
                    BoxShadow(
                      color: const Color(0xFFD7D7D7).withOpacity(0.8),
                      offset: const Offset(8, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    ItemWidget(
                      assetPath: 'assets/drawer/home.png',
                      label: translate('store_layout.dashboard'),
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(0);
                      },
                    ),
                    ItemWidget(
                      assetPath: 'assets/drawer/guarantees.png',
                      label: translate('store_layout.my_products'),
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(1);
                      },
                    ),
                    ItemWidget(
                      assetPath: 'assets/drawer/products.png',
                      label: translate('store_layout.view_purchases'),
                      onTap: () {
                        Navigator.pop(context);
                        onNavigate(3);
                      },
                    ),
                    ItemWidget(
                      assetPath: 'assets/drawer/profile.png',
                      label: translate('base_layout.profile'),
                      onTap: () {
                        navigateToProfilePage(context);
                      },
                    ),
                    ItemWidget(
                      assetPath: 'assets/drawer/star.png',
                      label: translate('base_layout.points'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ItemWidget(
                      assetPath: 'assets/drawer/settings.png',
                      label: translate('base_layout.settings'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          LogoutTileWidget(onLogout: onLogout),
        ],
      ),
    );
  }

  void navigateToProfilePage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }
}

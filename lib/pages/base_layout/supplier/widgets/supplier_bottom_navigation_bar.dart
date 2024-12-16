import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class StoreBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const StoreBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFFAFAFA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(182, 182, 182, 0.7),
            offset: Offset(0, -3),
            blurRadius: 16,
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(39),
          topRight: Radius.circular(39),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 0
                  ? 'assets/bottom_nav/house_after.png'
                  : 'assets/bottom_nav/house_before.png',
            ),
            label: translate('store_layout.dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 1
                  ? 'assets/bottom_nav/products_after.png'
                  : 'assets/bottom_nav/products_before.png',
            ),
            label: translate('store_layout.my_products'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 2
                  ? 'assets/bottom_nav/search_after.png'
                  : 'assets/bottom_nav/search_before.png',
            ),
            label: translate('store_layout.add_product'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 3
                  ? 'assets/bottom_nav/products_after.png'
                  : 'assets/bottom_nav/products_before.png',
            ),
            label: translate('store_layout.view_purchases'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 4
                  ? 'assets/bottom_nav/products_after.png'
                  : 'assets/bottom_nav/products_before.png',
            ),
            label: translate('store_layout.notifications'),
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF5A1F),
        unselectedItemColor: const Color(0xFF767676),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Color(0xFFFF5A1F),
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w400,
          fontSize: 10,
          color: Color(0xFF767676),
        ),
      ),
    );
  }
}

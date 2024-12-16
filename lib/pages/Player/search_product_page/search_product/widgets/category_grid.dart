import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CategoryGridPage extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoryGridPage({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {
        "key": "flights",
        "name_he": "כרטיסי טיסה",
        "icon": "assets/fight_icon.png"
      },
      {
        "key": "electronics",
        "name_he": "אלקטרוניקה ומחשבים",
        "icon": "assets/electronics_icon.png"
      },
      {
        "key": "used_cars",
        "name_he": "רכבים יד שניה",
        "icon": "assets/car_icon.png"
      },
      {
        "key": "furniture",
        "name_he": "ריהוט ועיצוב",
        "icon": "assets/house_icon.png"
      },
      {
        "key": "home_electric",
        "name_he": "חשמל לבית",
        "icon": "assets/light_icon.png"
      },
      {
        "key": "subscriptions",
        "name_he": "מנויים",
        "icon": "assets/card_icon.png"
      },
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 400 ? 2 : 1;
    double childAspectRatio =
        screenWidth > 400 ? (screenWidth / 2) / 63 : screenWidth / 63;
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Directionality(
      textDirection: isHebrew ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment:
                  isHebrew ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 23.0),
                child: Text(
                  translate('category_grid_page.header'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000089),
                    fontFamily: 'Rubik',
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final categoryKey = categories[index]["key"]!;
                final categoryNameHe = categories[index]["name_he"]!;

                return CategoryTile(
                    name:
                        translate('category_grid_page.categories.$categoryKey'),
                    iconPath: categories[index]["icon"]!,
                    onSelected: () => onCategorySelected(categoryNameHe),
                    isHebrew: LocalizedApp.of(context)
                            .delegate
                            .currentLocale
                            .languageCode ==
                        'he');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String name;
  final String iconPath;
  final VoidCallback onSelected;
  final bool isHebrew;

  const CategoryTile(
      {super.key,
      required this.name,
      required this.iconPath,
      required this.onSelected,
      required this.isHebrew});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        height: 63,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
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
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: isHebrew
                    ? const EdgeInsets.only(right: 10.0)
                    : const EdgeInsets.only(left: 10.0),
                child: Text(
                  name,
                  textAlign: isHebrew ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    color: Color(0xFF0F0F14),
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                color: const Color(0xFFC1C3EE),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
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
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 58,
                  height: 58,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

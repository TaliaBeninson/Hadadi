import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TopSearchBar extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const TopSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(215, 215, 215, 0.75),
                offset: Offset(4.7, 4.7),
                blurRadius: 9.39),
            BoxShadow(
                color: Color.fromRGBO(227, 227, 227, 0.25),
                offset: Offset(-4.7, -4.7),
                blurRadius: 14.09),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search, color: Color(0xFF767676), size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                onChanged: onSearchChanged,
                style: const TextStyle(
                    color: Color(0xFF767676),
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: translate('profile.search_status'),
                  hintStyle: const TextStyle(
                      color: Color(0xFF767676),
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

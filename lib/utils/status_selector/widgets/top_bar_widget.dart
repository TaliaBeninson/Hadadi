import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TopBar extends StatelessWidget {
  final String headlineKey;
  final String topButtonKey;
  final VoidCallback selectOrClearAll;

  const TopBar({
    super.key,
    required this.headlineKey,
    required this.topButtonKey,
    required this.selectOrClearAll,
  });

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(227, 227, 227, 0.8), blurRadius: 16)
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF000089), size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              translate(headlineKey),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000089),
                fontFamily: 'Rubik',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: selectOrClearAll,
            child: Text(
              translate(topButtonKey),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000089),
                decoration: TextDecoration.underline,
                fontFamily: 'Rubik',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

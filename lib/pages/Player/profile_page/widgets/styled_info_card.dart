import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class StyledInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  const StyledInfoCard({
    super.key,
    required this.label,
    required this.value,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Container(
      height: 39,
      margin: const EdgeInsets.only(bottom: 16),
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
          Padding(
            padding: EdgeInsets.only(
              left: isHebrew ? 28.0 : 12.0,
              right: isHebrew ? 37.0 : 28.0,
            ),
            child: Icon(
              iconData,
              size: 20,
              color: const Color(0xFF4C52CC),
            ),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: isHebrew ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: Color(0xFF0F0F14),
                fontFamily: 'Rubik',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: isHebrew ? 36.0 : 8.0,
              right: isHebrew ? 0 : 36.0,
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF000089),
                fontFamily: 'Rubik',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

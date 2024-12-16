import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LogoutTileWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutTileWidget({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        child: ListTile(
          leading: Container(
            width: 50,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: Center(
              child: Image.asset(
                'assets/drawer/logout.png',
                color: const Color(0xFF4C52CC),
                width: 24,
                height: 24,
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Text
              Text(
                translate('base_layout.logout'),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000089),
                ),
              ),
            ],
          ),
          onTap: onLogout,
        ),
      ),
    );
  }
}

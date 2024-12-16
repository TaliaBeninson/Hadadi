import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const ItemWidget({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
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
                assetPath,
                color: const Color(0xFF4C52CC),
                width: 24,
                height: 24,
              ),
            ),
          ),
          title: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Color(0xFF181818),
              fontFamily: 'Rubik',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 269,
            height: 1,
            color: const Color(0xFFC1C3EE),
          ),
        )
      ],
    );
  }
}

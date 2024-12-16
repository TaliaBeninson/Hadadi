import 'package:flutter/material.dart';

class SquareDetailWidget extends StatelessWidget {
  final String value;
  final String title;
  final String assetName;

  const SquareDetailWidget({
    Key? key,
    required this.value,
    required this.title,
    required this.assetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8FF),
        borderRadius: BorderRadius.circular(21),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetName,
            height: 40,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$value $title',
              style: const TextStyle(
                color: Color(0xFF0F0F14),
                fontFamily: 'Rubik',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              softWrap: true, // Allows text to wrap if needed
              overflow: TextOverflow.visible, // Ensures no truncation
            ),
          ),
        ],
      ),
    );
  }
}

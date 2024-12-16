import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String number;
  final String assetPath;
  final Color mainColor;
  final String bottomText;

  const StatCard({
    required this.number,
    required this.assetPath,
    required this.mainColor,
    required this.bottomText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: mainColor, width: 2.0),
        borderRadius: BorderRadius.circular(22.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
          ),
          const SizedBox(height: 9.0),
          Text(number,
              style: TextStyle(
                  color: mainColor,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 1.0),
          Text(
            bottomText,
            style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

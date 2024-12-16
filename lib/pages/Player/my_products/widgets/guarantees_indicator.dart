import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Widget buildGuaranteesIndicator(
    List<dynamic> guarantees, int guaranteesAmount) {
  double percent = guaranteesAmount > 0
      ? (guarantees.length / guaranteesAmount).clamp(0.0, 1.0)
      : 0.0;
  Color progressColor = const Color(0xFF4C52CC);

  return Column(
    children: [
      CircularPercentIndicator(
        radius: 60.0, // Increased radius
        lineWidth: 14.0, // Thicker line width
        percent: percent,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translate('my_products.guarantees'),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF767676),
                fontFamily: 'Rubik',
              ),
            ),
            Text(
              "${guarantees.length}/$guaranteesAmount",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: progressColor,
                fontSize: 14,
                fontFamily: 'Rubik',
              ),
            ),
          ],
        ),
        progressColor: progressColor,
        backgroundColor: const Color(0xFFF2F2F2),
        circularStrokeCap: CircularStrokeCap.round,
      ),
      const SizedBox(height: 8),
    ],
  );
}
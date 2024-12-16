import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Widget buildTimeLeftIndicator(
    Duration timeLeft, DateTime endDateTime, String type) {
  int totalHours = endDateTime.difference(DateTime.now()).inHours;
  double percent =
  totalHours > 0 ? (timeLeft.inHours / totalHours).clamp(0.0, 1.0) : 1.0;

  Color progressColor =
  type == 'basic' ? const Color(0xFFF7B500) : const Color(0xFFFF5A1F);

  return Column(
    children: [
      CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 14.0,
        percent: percent,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translate('my_products.time_left'),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF767676),
                fontFamily: 'Rubik',
              ),
            ),
            timeLeft.isNegative
                ? Text(
              translate('my_products.finished_time'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            )
                : Text(
              DateFormat('HH:mm:ss')
                  .format(DateTime.now().add(timeLeft)),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                  fontFamily: 'Rubik'),
            ),
          ],
        ),
        progressColor: timeLeft.isNegative ? Colors.red : progressColor,
        backgroundColor: const Color(0xFFF2F2F2),
        circularStrokeCap: CircularStrokeCap.round,
      ),
      const SizedBox(height: 8),
    ],
  );
}
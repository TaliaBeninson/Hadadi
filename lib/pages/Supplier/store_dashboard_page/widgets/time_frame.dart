import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class Timeframe extends StatelessWidget {
  final String selectedTimeframe;
  final Function(String) onTimeframeChange;

  const Timeframe({
    required this.selectedTimeframe,
    required this.onTimeframeChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> timeframes = [
      translate('dashboard.timeframe.days'),
      translate('dashboard.timeframe.weeks'),
      translate('dashboard.timeframe.months'),
      translate('dashboard.timeframe.years'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: timeframes.map((timeframe) {
          final bool isSelected = selectedTimeframe == timeframe;
          return GestureDetector(
            onTap: () => onTimeframeChange(timeframe),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4C52CC)
                    : const Color(0xFFC1C3EE),
                borderRadius: BorderRadius.circular(21.0),
              ),
              child: Text(
                timeframe,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF070707),
                  fontFamily: 'Rubik',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

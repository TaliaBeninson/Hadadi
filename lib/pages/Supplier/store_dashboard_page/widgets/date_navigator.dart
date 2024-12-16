import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class DateNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTimeframe;
  final Function(int days) onDateChange;
  final bool isHebrew;

  const DateNavigator({
    required this.selectedDate,
    required this.selectedTimeframe,
    required this.onDateChange,
    required this.isHebrew,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFFFF5A1F),
            size: 28.0,
          ),
          onPressed: () =>
              onDateChange(_calculateStep(selectedTimeframe, isForward: false)),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21.0),
            color: const Color(0xFFFF5A1F),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFFFFFFF),
                offset: Offset(-8, -8),
                blurRadius: 16,
              ),
              BoxShadow(
                color: Color(0xFFD7D7D7),
                offset: Offset(8, 8),
                blurRadius: 16,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
          child: Text(
            _formatSelectedDate(selectedDate, selectedTimeframe, isHebrew),
            style: const TextStyle(
              color: Color(0xFFF2F2F2),
              fontFamily: 'Rubik',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              textBaseline: TextBaseline.alphabetic,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.chevron_right,
            color: Color(0xFFFF5A1F),
            size: 28.0,
          ),
          onPressed: () =>
              onDateChange(_calculateStep(selectedTimeframe, isForward: true)),
        ),
      ],
    );
  }

  int _calculateStep(String timeframe, {required bool isForward}) {
    int step = 1;
    if (timeframe == translate('dashboard.timeframe.weeks')) {
      step = 7;
    } else if (timeframe == translate('dashboard.timeframe.months')) {
      step = 30;
    } else if (timeframe == translate('dashboard.timeframe.years')) {
      step = 365;
    }
    return isForward ? step : -step;
  }
}

String _formatSelectedDate(DateTime date, String timeframe, bool isHebrew) {
  final String locale = isHebrew ? 'he' : 'en';

  if (timeframe == translate('dashboard.timeframe.days')) {
    return DateFormat('dd.MM.yyyy', locale).format(date);
  } else if (timeframe == translate('dashboard.timeframe.weeks')) {
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return '${DateFormat('dd.MM', locale).format(startOfWeek)} - ${DateFormat('dd.MM', locale).format(endOfWeek)}'; // Week range
  } else if (timeframe == translate('dashboard.timeframe.months')) {
    return DateFormat('MMMM yyyy', locale).format(date);
  } else if (timeframe == translate('dashboard.timeframe.years')) {
    return DateFormat('yyyy', locale).format(date);
  }
  return '';
}

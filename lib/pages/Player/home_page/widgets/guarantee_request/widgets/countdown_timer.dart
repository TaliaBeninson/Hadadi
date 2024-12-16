import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CountdownTimerWidget extends StatelessWidget {
  final Timestamp endTime;

  const CountdownTimerWidget({required this.endTime, super.key});

  String _formatTime(CurrentRemainingTime time) {
    final int days = time.days ?? 0;
    final int hours = time.hours ?? 0;
    final int minutes = time.min ?? 0;
    return '${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: isHebrew ? 20 : 0,
            left: isHebrew ? 0 : 20,
          ),
          child: CountdownTimer(
            endTime: endTime.millisecondsSinceEpoch,
            widgetBuilder: (_, CurrentRemainingTime? time) {
              if (time == null) {
                return Text(
                  translate('widget.expired'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF5A1F),
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return Text(
                _formatTime(time),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFF5A1F),
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: isHebrew ? 4 : 0,
            left: isHebrew ? 0 : 4,
          ),
          child: const Icon(
            Icons.access_time,
            size: 16,
            color: Color(0xFFFF5A1F),
          ),
        ),
      ],
    );
  }
}

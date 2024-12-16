import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/player/notification_page/notification_item.dart';
import 'package:hadadi/services/DB/notification_service.dart';
import 'package:hadadi/services/DB/user_service.dart';

class NotificationPage extends StatefulWidget {
  final bool showAppBar;

  const NotificationPage({Key? key, this.showAppBar = false}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();
  final UserService _userService = UserService();
  String _userName = 'Unknown';
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final userId = await _userService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in.');
      }
      final userData = await _userService.getUserData(userId);
      _userName = userData?['name'] ?? 'Unknown';
      _notifications = await _notificationService.fetchUserNotifications();
    } catch (e) {
      _hasError = true;
    }

    setState(() {
      _isLoading = false;
    });
  }

  // This is the callback function that will update the notification type locally.
  void _updateNotificationLocally(String notificationId, String newType) {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      setState(() {
        _notifications[index]['type'] = newType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError || _userName == 'Unknown') {
      return Center(
        child: Text(translate('notifications.login_required')),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Text(translate('notifications.no_notifications')),
      );
    }

    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    List<Map<String, dynamic>> todayNotifications = [];
    List<Map<String, dynamic>> thisWeekNotifications = [];
    List<Map<String, dynamic>> earlierNotifications = [];

    for (var notification in _notifications) {
      dynamic timestamp = notification['timestamp'];

      DateTime date;
      try {
        if (timestamp is Timestamp) {
          date = timestamp.toDate();
        } else if (timestamp is String) {
          date = DateTime.parse(timestamp);
        } else {
          throw Exception('Invalid timestamp format');
        }
      } catch (e) {
        continue;
      }

      if (date.isAfter(today)) {
        todayNotifications.add(notification);
      } else if (date.isAfter(startOfWeek)) {
        thisWeekNotifications.add(notification);
      } else {
        earlierNotifications.add(notification);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 12),
            child: Text(
              translate('base_layout.notifications'),
              style: const TextStyle(
                color: Color(0xFF000089),
                fontFamily: 'Rubik',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (todayNotifications.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                translate('notifications.today'),
                style: const TextStyle(
                  color: Color(0xFF000089),
                  fontFamily: 'Rubik',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...todayNotifications.map((notification) => buildNotificationItem(
                notification, _userName, isHebrew, _updateNotificationLocally)),
          ],
          if (thisWeekNotifications.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                translate('notifications.this_week'),
                style: const TextStyle(
                  color: Color(0xFF000089),
                  fontFamily: 'Rubik',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...thisWeekNotifications.map((notification) =>
                buildNotificationItem(notification, _userName, isHebrew,
                    _updateNotificationLocally)),
          ],
          if (earlierNotifications.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                translate('notifications.earlier'),
                style: const TextStyle(
                  color: Color(0xFF000089),
                  fontFamily: 'Rubik',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...earlierNotifications.map((notification) => buildNotificationItem(
                notification, _userName, isHebrew, _updateNotificationLocally)),
          ],
        ],
      ),
    );
  }
}

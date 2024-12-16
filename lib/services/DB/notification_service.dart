import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'user_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  final UserService _userService = UserService();
  NotificationService._internal();

  final List<String> _scopes = [
    'https://www.googleapis.com/auth/firebase.messaging'
  ];

  /// Loads the service account JSON file from assets.
  Future<String> loadServiceAccount() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/service-account-file.json');
      return jsonString;
    } catch (e) {
      throw Exception('Failed to load service account file: $e');
    }
  }

  /// Fetches an access token using the service account credentials.
  Future<String> getAccessToken() async {
    try {
      String jsonString = await loadServiceAccount();
      var accountCredentialsJson = jsonDecode(jsonString);
      var accountCredentials =
          ServiceAccountCredentials.fromJson(accountCredentialsJson);
      var client = http.Client();

      AccessCredentials credentials =
          await obtainAccessCredentialsViaServiceAccount(
        accountCredentials,
        _scopes,
        client,
      );

      client.close(); // Ensure the HTTP client is closed after use
      return credentials.accessToken.data;
    } catch (e) {
      throw Exception('Failed to fetch access token: $e');
    }
  }

  /// Sends an FCM notification to the specified token.
  Future<void> sendFCMNotification(
      String token, String title, String body) async {
    final accessToken = await getAccessToken();

    try {
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/hadadi-7a752/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'message': {
              'token': token,
              'notification': {
                'title': title,
                'body': body,
              },
              'data': {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'message': 'You have received a new guarantee!',
              },
            },
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully: ${response.body}");
      } else {
        print("Failed to send notification: ${response.body}");
        final responseBody = jsonDecode(response.body);
        final errorCode = responseBody['error']?['details']?[0]?['errorCode'];
        if (errorCode == "UNREGISTERED") {
          print("FCM token is unregistered: $token");
          // Handle invalid FCM token cleanup
        }
        throw Exception('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error sending notification: $e');
    }
  }

  /// Adds a notification to a Firestore user's notifications collection.
  Future<void> addNotification({
    required String userId,
    required Map<String, dynamic> notification,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add(notification);
      print('Notification added to Firestore for user $userId');
    } catch (e) {
      print('Error adding notification: $e');
      throw Exception('Failed to add notification');
    }
  }

  /// Fetch notifications for the current user.
  Future<List<Map<String, dynamic>>> fetchUserNotifications() async {
    try {
      final String? userId = await _userService.getCurrentUserId();

      if (userId == null) {
        throw Exception('User ID not found. User is not logged in.');
      }

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include the document ID
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<void> updateNotification({
    required String userId,
    required String notificationId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update(data);
      print('Notification $notificationId updated for user $userId');
    } catch (e) {
      print('Error updating notification: $e');
      throw Exception('Failed to update notification');
    }
  }
}

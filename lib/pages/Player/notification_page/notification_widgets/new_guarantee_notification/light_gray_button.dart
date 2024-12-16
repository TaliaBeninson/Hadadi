import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hadadi/services/DB/notification_service.dart';
import 'package:hadadi/services/DB/user_service.dart';

class LightGrayButton extends StatefulWidget {
  final String emoji;
  final String recipientName;
  final String symbol;
  final String product;
  final String userName;
  final String notificationID;
  final Color emojiColor;
  final void Function(String notificationId, String newType)
      onNotificationTypeUpdated;

  const LightGrayButton({
    Key? key,
    required this.emoji,
    required this.recipientName,
    required this.symbol,
    required this.product,
    required this.userName,
    required this.notificationID,
    required this.emojiColor,
    required this.onNotificationTypeUpdated,
  }) : super(key: key);

  @override
  _LightGrayButtonState createState() => _LightGrayButtonState();
}

class _LightGrayButtonState extends State<LightGrayButton> {
  bool _isSending = false; // Track if we're currently sending

  IconData getIconData(String emoji) {
    switch (emoji) {
      case 'heart':
        return Icons.favorite;
      case 'smile':
        return Icons.emoji_emotions;
      case 'victory':
        return Icons.emoji_events;
      default:
        return Icons.help;
    }
  }

  Future<void> _handleTap() async {
    if (_isSending) return; // Prevent multiple clicks

    setState(() {
      _isSending = true;
    });

    try {
      await _sendThankYouMessage(
        widget.recipientName,
        widget.symbol,
        widget.product,
        widget.userName,
        widget.notificationID,
      );
      widget.onNotificationTypeUpdated(
          widget.notificationID, 'newGuaranteeSent');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _sendThankYouMessage(
    String recipientUID,
    String emojiType,
    String product,
    String userName,
    String notificationID,
  ) async {
    final userService = UserService();
    final notificationService = NotificationService();

    final recipientData = await userService.getUserData(recipientUID);
    if (recipientData != null) {
      String fcmToken = recipientData['fcmToken'] ?? '';
      String preferredLanguage = recipientData['preferredLanguage'] ?? 'he';

      final currentUserId = await userService.getCurrentUserId();
      if (currentUserId != null) {
        await notificationService.updateNotification(
          userId: currentUserId,
          notificationId: notificationID,
          data: {'type': 'newGuaranteeSent'},
        );

        await notificationService.addNotification(
          userId: recipientUID,
          notification: {
            'name': userName,
            'product': product,
            'symbol': emojiType,
            'timestamp': FieldValue.serverTimestamp(),
            'type': 'thankYou',
          },
        );

        if (fcmToken.isNotEmpty) {
          String newRequestTitle;
          String newRequestMessage;
          if (preferredLanguage == 'he') {
            newRequestTitle = "תודה רבה";
            newRequestMessage =
                "קיבלת תודה מ-$userName על שנתת ערבות עבור $product!";
          } else {
            newRequestTitle = "Thank You!";
            newRequestMessage =
                "You received a thank you from $userName for providing a guarantee on $product!";
          }

          await notificationService.sendFCMNotification(
            fcmToken,
            newRequestTitle,
            newRequestMessage,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(22),
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
            child: Icon(
              getIconData(widget.emoji),
              color: widget.emojiColor,
              size: 24,
            ),
          ),
          if (_isSending)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

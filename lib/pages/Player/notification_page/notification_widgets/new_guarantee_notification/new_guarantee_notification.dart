import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'emoji_icon.dart';
import 'light_gray_button.dart';

Widget buildNewGuaranteeNotification(
  String? name,
  String? product,
  String? symbol,
  String date,
  String uid,
  String userName,
  String notificationID,
  String type,
  bool isHebrew,
  void Function(String notificationId, String newType)
      onNotificationTypeUpdated,
) {
  String displayName = name ?? 'Unknown';
  String displayProduct = product ?? 'Unknown product';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC1C3EE),
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
                  child: Center(
                    child: Image.asset(
                      'assets/handshake.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment:
                            isHebrew ? Alignment.topLeft : Alignment.topRight,
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF767676),
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              translate('notifications.new_guarantee.title'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F0F14),
                                fontFamily: 'Rubik',
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translate(
                                      'notifications.new_guarantee.message',
                                      args: {'name': displayName}),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0F0F14),
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  translate(
                                      'notifications.new_guarantee.product',
                                      args: {'product': displayProduct}),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0F0F14),
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (symbol != null && symbol.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: buildEmojiIcon(symbol),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (type != 'newGuaranteeSent')
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Center(
                child: Text(
                  translate('notification.thank_you_back'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (type != 'newGuaranteeSent')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LightGrayButton(
                    emoji: 'heart',
                    recipientName: uid,
                    symbol: 'heart',
                    product: displayProduct,
                    userName: userName,
                    notificationID: notificationID,
                    emojiColor: const Color(0xFFFF5A1F),
                    onNotificationTypeUpdated: onNotificationTypeUpdated,
                  ),
                  const SizedBox(width: 10),
                  LightGrayButton(
                    emoji: 'smile',
                    recipientName: uid,
                    symbol: 'smile',
                    product: displayProduct,
                    userName: userName,
                    notificationID: notificationID,
                    emojiColor: const Color(0xFF4C52CC),
                    onNotificationTypeUpdated: onNotificationTypeUpdated,
                  ),
                  const SizedBox(width: 10),
                  LightGrayButton(
                    emoji: 'victory',
                    recipientName: uid,
                    symbol: 'victory',
                    product: displayProduct,
                    userName: userName,
                    notificationID: notificationID,
                    emojiColor: const Color(0xFFF7B500),
                    onNotificationTypeUpdated: onNotificationTypeUpdated,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 18),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/notification_page/notification_widgets/new_guarantee_notification/emoji_icon.dart';

Widget buildThankYouNotification(String senderName, String emoji, String date,
    String product, bool isHebrew) {
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC1E6),
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
              child: const Center(
                child: Icon(
                  Icons.favorite,
                  color: Color(0xFFD9489F),
                  size: 25,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: isHebrew
                        ? Alignment.topLeft
                        : Alignment.topRight, // Align based on language
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('notifications.thank_you.title'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F0F14),
                          fontFamily: 'Rubik',
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
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
                            // First text
                            Text(
                              translate(
                                'notifications.thank_you.message',
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0F0F14),
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              translate('notifications.thank_you.message2',
                                  args: {'sender': senderName}),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0F0F14),
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              translate('notifications.thank_you.message3',
                                  args: {'product': product}),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0F0F14),
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (emoji.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: buildEmojiIcon(emoji),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

Widget buildReduceGuaranteeNotification(String sellerName, String product,
    String reducedNumber, String date, bool isHebrew) {
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
                color: const Color(0xFFE2BFF3),
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
                  Icons.remove_circle,
                  color: Color(
                      0xFF9C27B0),
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Notification text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: isHebrew
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color:
                        Color(0xFF767676),
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
                          translate('notifications.reduce_guarantee.title'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                          ),
                          softWrap:
                          true,
                          overflow: TextOverflow
                              .ellipsis,
                          maxLines:
                          2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translate('notifications.reduce_guarantee.message'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF0F0F14),
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    translate('notifications.reduce_guarantee.message2', args: {
                      'product': product,
                      'reducedNumber': reducedNumber
                    }),
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
          ],
        ),
      ),
    ),
  );
}
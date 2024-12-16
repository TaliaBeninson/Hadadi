import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notification_widgets/finish_guarantee.dart';
import 'notification_widgets/new_guarantee_notification/new_guarantee_notification.dart';
import 'notification_widgets/new_purchase_notification.dart';
import 'notification_widgets/reduce_guarantee_notification.dart';
import 'notification_widgets/thank_you_notification.dart';
import 'notification_widgets/turbo_notification.dart';
import 'notification_widgets/update_turbo_notification.dart';

Widget buildNotificationItem(
  Map<String, dynamic> notification,
  String userName,
  bool isHebrew,
  void Function(String notificationId, String newType)
      onNotificationTypeUpdated,
) {
  String type = notification['type'] ?? 'unknown';
  String product = notification['product'] ?? 'Unknown product';
  String symbol = notification['symbol']?.toString() ?? '';

  DateTime date;
  dynamic timestamp = notification['timestamp'];

  try {
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is String) {
      date = DateTime.parse(timestamp);
    } else {
      throw Exception('Invalid timestamp format');
    }
  } catch (e) {
    return const SizedBox.shrink();
  }

  String formattedDate = DateFormat('dd/MM/yyyy').format(date);
  String uid = notification['uid']?.toString() ?? '';
  String notificationID = notification['id'] ?? '';

  if (type == 'newGuarantee' || type == 'newGuaranteeSent') {
    String name = notification['name']?.toString() ?? 'Unknown';
    // Pass the callback down to buildNewGuaranteeNotification
    return buildNewGuaranteeNotification(
      name,
      product,
      symbol,
      formattedDate,
      uid,
      userName,
      notificationID,
      type,
      isHebrew,
      onNotificationTypeUpdated,
    );
  } else if (type == 'finishGuarantee') {
    return buildFinishGuaranteeNotification(product, formattedDate, isHebrew);
  } else if (type == 'turbo') {
    String lowestPrice = notification['name']?.toString() ?? '0.0';
    String hoursRemaining = notification['symbol']?.toString() ?? '0';
    return buildTurboNotification(
        product, hoursRemaining, lowestPrice, formattedDate, isHebrew);
  } else if (type == 'updateTurbo') {
    String currentPrice = notification['name']?.toString() ?? '0.0';
    return buildUpdateTurboNotification(
        product, currentPrice, formattedDate, isHebrew);
  } else if (type == 'thankYou') {
    String senderName = notification['name']?.toString() ?? 'Anonymous';
    return buildThankYouNotification(
        senderName, symbol, formattedDate, product, isHebrew);
  } else if (type == 'reduceGuarantee') {
    String sellerName = notification['name']?.toString() ?? 'Seller';
    String reducedNumber = notification['symbol']?.toString() ?? '';
    return buildReduceGuaranteeNotification(
        sellerName, product, reducedNumber, formattedDate, isHebrew);
  } else if (type == 'newPurchase') {
    String buyerName = notification['name']?.toString() ?? 'Unknown';
    String price = notification['symbol']?.toString() ?? '0';
    String quantity = notification['uid']?.toString() ?? '1';
    return buildNewPurchaseNotification(
        buyerName, product, price, formattedDate, quantity, isHebrew);
  } else {
    return const SizedBox.shrink();
  }
}

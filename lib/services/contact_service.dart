import 'dart:io';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/services/DB/store_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactService {
  final StoreService _storeService = StoreService();

  Future<void> navigateToSupplierViaWhatsApp(
    String storeID,
    String productName,
    String userName, {
    bool isSimplified = false,
    double? finalPrice,
    String? purchaseOrder,
  }) async {
    try {
      // Fetch store details
      final storeDetails = await _storeService.fetchStoreDetails(storeID);
      if (storeDetails == null || !storeDetails.containsKey('whatsapp')) {
        throw 'WhatsApp number not found for store.';
      }

      String whatsappNumber = storeDetails['whatsapp'] ?? '';
      String storeName = storeDetails['storeName'] ?? '';

      if (whatsappNumber.isNotEmpty) {
        String formattedNumber =
            whatsappNumber.replaceAll(' ', '').replaceAll('-', '');
        if (formattedNumber.startsWith('0')) {
          formattedNumber = formattedNumber.substring(1);
        }
        if (!formattedNumber.startsWith('+')) {
          formattedNumber = '+972$formattedNumber';
        }

        String text;
        if (isSimplified) {
          // Simplified format
          text = translate('my_products.simplified_message_template', args: {
            'storeName': storeName,
            'productName': productName,
            'userName': userName,
          });
        } else {
          // Detailed format
          text = translate('my_products.message_template', args: {
            'userName': storeName,
            'productName': productName,
            'finalPrice': finalPrice?.toStringAsFixed(2) ?? '',
            'purchaseOrder': purchaseOrder ?? '',
          });
          text +=
              "\n\n${translate('my_products.confirm_delivery_and_payment')}";
          text += "\n\n$userName";
        }

        String androidUrl =
            "whatsapp://send?phone=$formattedNumber&text=${Uri.encodeComponent(text)}";
        String iosUrl =
            "https://wa.me/$formattedNumber?text=${Uri.encodeComponent(text)}";
        String webUrl =
            'https://api.whatsapp.com/send/?phone=$formattedNumber&text=${Uri.encodeComponent(text)}';

        try {
          if (Platform.isIOS) {
            if (await canLaunchUrl(Uri.parse(iosUrl))) {
              await launchUrl(Uri.parse(iosUrl));
            } else {
              throw 'Could not launch WhatsApp for iOS';
            }
          } else if (Platform.isAndroid) {
            if (await canLaunchUrl(Uri.parse(androidUrl))) {
              await launchUrl(Uri.parse(androidUrl),
                  mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch WhatsApp for Android';
            }
          }
        } catch (e) {
          if (await canLaunchUrl(Uri.parse(webUrl))) {
            await launchUrl(Uri.parse(webUrl),
                mode: LaunchMode.externalApplication);
          }
        }
      }
    } catch (e) {
      print('Error in navigateToSupplierViaWhatsApp: $e');
      rethrow;
    }
  }

  Future<void> navigateToSupplierViaEmail(
    String storeID,
    String productName,
    String userName, {
    bool isSimplified = false,
    double? finalPrice,
    String? purchaseOrder,
  }) async {
    try {
      // Fetch store details
      final storeDetails = await _storeService.fetchStoreDetails(storeID);
      if (storeDetails == null || !storeDetails.containsKey('email')) {
        throw 'Email address not found for store.';
      }

      String emailAddress = storeDetails['email'] ?? '';
      String storeName = storeDetails['storeName'] ?? '';

      if (emailAddress.isNotEmpty) {
        String subject =
            Uri.encodeComponent(translate('my_products.email_subject', args: {
          'productName': productName,
          'purchaseOrder': purchaseOrder ?? '',
        }));

        String body;
        if (isSimplified) {
          body = translate('my_products.simplified_message_template', args: {
            'storeName': storeName,
            'productName': productName,
            'userName': userName,
          });
        } else {
          body = "${translate('my_products.message_template', args: {
                'userName': storeName,
                'productName': productName,
                'finalPrice': finalPrice?.toStringAsFixed(2) ?? '',
                'purchaseOrder': purchaseOrder ?? '',
              })}\n\n${translate('my_products.confirm_delivery_and_payment')}\n\n$userName";
        }

        // Replace `+` with `%20` for spaces
        body = Uri.encodeComponent(body).replaceAll('+', '%20');
        subject = subject.replaceAll('+', '%20');

        Uri emailUri = Uri(
          scheme: 'mailto',
          path: emailAddress,
          query: 'subject=$subject&body=$body',
        );

        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        }
      }
    } catch (e) {
      print('Error in navigateToSupplierViaEmail: $e');
      rethrow;
    }
  }
}

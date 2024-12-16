import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

Widget paymentInProgressBanner(String purchaseOrder, bool isHebrew) {
  return Align(
    alignment: isHebrew ? Alignment.centerLeft : Alignment.centerRight,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 21,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFC1C3EE),
              borderRadius: BorderRadius.only(
                bottomRight: isHebrew ? const Radius.circular(22) : Radius.zero,
                bottomLeft: isHebrew ? Radius.zero : const Radius.circular(22),
              ),
            ),
            child: Text(
              translate('my_products.purchase_order',
                  args: {'purchaseOrder': purchaseOrder}),
              style: const TextStyle(
                color: Color(0xFFF2F2F2),
                fontFamily: 'Rubik',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),

          // Purple Container
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF39A844),
              borderRadius: BorderRadius.only(
                topLeft: isHebrew ? const Radius.circular(22) : Radius.zero,
                topRight: isHebrew ? Radius.zero : const Radius.circular(22),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: isHebrew ? 11 : 0,
                      left: isHebrew ? 0 : 11,
                    ),
                    child: const Icon(
                      Icons.credit_card,
                      size: 16,
                      color: Color(0xFFF2F2F2),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    translate('my_products.payment_in_progress'),
                    style: const TextStyle(
                      color: Color(0xFFF2F2F2),
                      fontFamily: 'Rubik',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

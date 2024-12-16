import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

Widget priceDetailsSection(String type, double finalPrice, double originalPrice,
    String transactionStatus) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xffF2F2F2),
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
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        if (transactionStatus == 'inPaymentProgress') ...[
          Text(
            translate('my_products.final_price'),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff0F0F14),
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          Text(
            '${finalPrice.toStringAsFixed(2)} ₪',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF39A844),
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ] else ...[
          Text(
            translate('my_products.price_label'),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff0F0F14),
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
            ),
          ),
          if (type == 'Turbo') ...[
            Text(
              '${finalPrice.toStringAsFixed(2)} ₪',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFFF5A1F),
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0), // Add top padding of 3
              child: Text(
                '(${((originalPrice - finalPrice) / originalPrice * 100).toStringAsFixed(2)}%)',
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFFF5A1F),
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                '${originalPrice.toStringAsFixed(2)} ₪',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xff000089),
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ] else ...[
            Text(
              '${finalPrice.toStringAsFixed(2)} ₪',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff000089),
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ],
    ),
  );
}

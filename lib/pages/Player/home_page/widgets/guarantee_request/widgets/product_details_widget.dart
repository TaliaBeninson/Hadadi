import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ProductDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const ProductDetailsWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction['amount'] > 1
                ? translate(
                    'widget.purchase_product_quantity',
                    args: {
                      'quantity': transaction['amount'].toString(),
                      'productName': transaction['itemName'],
                    },
                  )
                : translate(
                    'widget.purchase_product',
                    args: {
                      'productName': transaction['itemName'],
                    },
                  ),
            style: const TextStyle(
              color: Color(0xFF0F0F14),
              fontFamily: 'Rubik',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          if (transaction['type'] == 'Turbo')
            Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              children: [
                Text(
                  '${transaction['price']} ₪',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  translate('widget.minimum_price', args: {
                    'worstCasePrice': transaction['worstCasePrice'],
                  }),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          if (transaction['type'] != 'Turbo')
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              children: [
                Text(
                  translate('widget.product_price'),
                  style: const TextStyle(
                    color: Color(0xFF0F0F14),
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                Text(
                  '${transaction['price'].toString()} ₪',
                  style: const TextStyle(
                    color: Color(0xFF0F0F14),
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

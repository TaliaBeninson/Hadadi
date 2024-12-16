import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/utils/guarantor_expansion_tile.dart';
import 'package:share_plus/share_plus.dart';

class GuaranteeCard extends StatefulWidget {
  final Map<String, dynamic> guarantee;

  const GuaranteeCard({super.key, required this.guarantee});

  @override
  _GuaranteeCardState createState() => _GuaranteeCardState();
}

class _GuaranteeCardState extends State<GuaranteeCard> {
  @override
  Widget build(BuildContext context) {
    var product = widget.guarantee['product'];
    var buyer = widget.guarantee['buyer'];

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8F8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                  offset: Offset(-8, -8),
                  blurRadius: 16,
                ),
                BoxShadow(
                  color: Color.fromRGBO(215, 215, 215, 0.8),
                  offset: Offset(8, 8),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: product['image'] != null
                            ? Image.network(
                                product['image'],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.image,
                                    color: Colors.white, size: 40),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ??
                                  translate('guarantees.no_product_name'),
                              style: const TextStyle(
                                color: Color(0xff0F0F14),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rubik',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${translate('guarantees.for')}: ${buyer['name'] ?? translate('guarantees.no_buyer_name')}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff696969),
                                fontFamily: 'Rubik',
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _shareViaAnyApp(
                            buyer['name'],
                            product['name'],
                            widget.guarantee['guaranteesAmount'],
                          );
                        },
                        child: const Icon(
                          Icons.share,
                          size: 24,
                          color: Color(0xFFFF5A1F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GuarantorsExpansionTile(
            guarantees: widget.guarantee['guarantees'],
          ),
        ],
      ),
    );
  }

  Future<void> _shareViaAnyApp(
      String buyerName, String productName, int amount) async {
    final String message = translate('guarantees.share_message', args: {
      'productName': productName,
      'buyerName': buyerName,
      'amount': amount.toString()
    });

    Share.share(message);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadadi/services/contact_service.dart';

class ContactSupplierWidget extends StatelessWidget {
  final bool isInPaymentProgress;
  final bool isHebrew;
  final String storeID;
  final String itemName;
  final double finalPrice;
  final String purchaseOrder;
  final Widget timeLeftIndicator;
  final Widget guaranteesIndicator;
  final String userName;

  const ContactSupplierWidget({
    super.key,
    required this.isInPaymentProgress,
    required this.isHebrew,
    required this.storeID,
    required this.itemName,
    required this.finalPrice,
    required this.purchaseOrder,
    required this.timeLeftIndicator,
    required this.guaranteesIndicator,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final ContactService contactService = ContactService();

    return Padding(
      padding: const EdgeInsets.only(top: 27, bottom: 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isInPaymentProgress)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment:
                    isHebrew ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  translate('my_products.contact_supplier'),
                  style: const TextStyle(
                    color: Color(0xFF000089),
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: isHebrew ? TextAlign.right : TextAlign.left,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isInPaymentProgress)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // WhatsApp Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                contactService.navigateToSupplierViaWhatsApp(
                              storeID,
                              itemName,
                              userName,
                              isSimplified: false,
                              finalPrice: finalPrice,
                              purchaseOrder: purchaseOrder,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF000089),
                                borderRadius: BorderRadius.circular(21),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    offset: const Offset(-8, -8),
                                    blurRadius: 16,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFD7D7D7)
                                        .withOpacity(0.8),
                                    offset: const Offset(8, 8),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      translate('my_products.contact_whatsapp'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Rubik',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Email Button
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                contactService.navigateToSupplierViaEmail(
                              storeID,
                              itemName,
                              userName,
                              isSimplified: false,
                              finalPrice: finalPrice,
                              purchaseOrder: purchaseOrder,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF000089),
                                borderRadius: BorderRadius.circular(21),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    offset: const Offset(-8, -8),
                                    blurRadius: 16,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFD7D7D7)
                                        .withOpacity(0.8),
                                    offset: const Offset(8, 8),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      translate('my_products.contact_email'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Rubik',
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  timeLeftIndicator,
                  guaranteesIndicator,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

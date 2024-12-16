import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadadi/services/contact_service.dart';

class ProductImageAndDetails extends StatelessWidget {
  final String itemName;
  final String specifications;
  final String imageUrl;
  final bool isHebrew;
  final String warrantyYear;
  final String transactionStatus;
  final String storeID;
  final String userName;

  const ProductImageAndDetails({
    super.key,
    required this.itemName,
    required this.specifications,
    required this.imageUrl,
    required this.isHebrew,
    required this.warrantyYear,
    required this.transactionStatus,
    required this.storeID,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final ContactService contactService = ContactService();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: isHebrew ? 26.0 : 0.0,
            left: isHebrew ? 0.0 : 26.0,
          ),
          child: Container(
            width: 41,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[300],
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      alignment: const Alignment(-0.5, 0),
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? const Icon(Icons.image, size: 24, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: itemName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff000089),
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          ' ${translate('my_products.model_prefix')} $specifications',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff0F0F14),
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 4),
              Text(
                translate('my_products.warranty_years', args: {
                  'warrantyYear': warrantyYear.toString(),
                }),
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff0F0F14),
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        if (transactionStatus != 'inPaymentProgress')
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF000089),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            color: const Color(0xFFE4E5FF),
            elevation: 4,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                enabled: false,
                child: Center(
                  child: Text(
                    translate('my_products.contact_supplier'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF000089),
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'whatsapp',
                child: ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Color(0xFF000089),
                  ),
                  title: Text(
                    translate('my_products.contact_whatsapp'),
                    style: const TextStyle(
                      color: Color(0xFF000089),
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'email',
                child: ListTile(
                  leading: const Icon(
                    Icons.email,
                    color: Color(0xFF000089),
                  ),
                  title: Text(
                    translate('my_products.contact_email'),
                    style: const TextStyle(
                      color: Color(0xFF000089),
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
            onSelected: (String value) {
              if (value == 'whatsapp') {
                contactService.navigateToSupplierViaWhatsApp(
                  storeID,
                  itemName,
                  userName,
                  isSimplified: true,
                );
              } else if (value == 'email') {
                contactService.navigateToSupplierViaEmail(
                  storeID,
                  itemName,
                  userName,
                  isSimplified: true,
                );
              }
            },
          ),
      ],
    );
  }
}

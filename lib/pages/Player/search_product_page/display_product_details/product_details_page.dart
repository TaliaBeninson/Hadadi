import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/player/search_product_page/display_product_details/widgets/heart_icon.dart';
import 'package:hadadi/pages/player/search_product_page/display_product_details/widgets/reason_bottom_bar.dart';
import 'package:hadadi/pages/player/search_product_page/display_product_details/widgets/square_detail_widget.dart';
import 'package:hadadi/pages/player/search_product_page/display_product_details/widgets/store_details_section.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:hadadi/utils/widgets/custom_button.dart';
import 'package:hadadi/utils/widgets/custom_dropdown.dart';
import 'package:hadadi/utils/widgets/top_bar_widget.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(String) saveSearchTerm;

  const ProductDetailsPage({
    Key? key,
    required this.product,
    required this.saveSearchTerm,
  }) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedQuantity = '1'; // Default quantity is 1

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Scaffold(
      body: Column(
        crossAxisAlignment:
            isHebrew ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          TopBarWidget(
            titleText: widget.product['name'] ??
                translate('search_product.product_details.no_name'),
            onBackPress: () {
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: isHebrew
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  if (widget.product['image'] != null &&
                      widget.product['image']!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(widget.product['image']),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              left: 20,
                              child: HeartIcon(),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 20),

                  // Product Price
                  Text(
                    '${widget.product['price'] ?? translate('search_product.product_details.no_price')} ₪',
                    style: const TextStyle(
                      color: Color(0xFF000089),
                      fontFamily: 'Rubik',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: isHebrew ? TextAlign.right : TextAlign.left,
                  ),

                  const SizedBox(height: 25),

                  // Specifications
                  if (widget.product['specifications'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['specifications'] ?? '',
                          style: const TextStyle(
                            color: Color(0xFF0F0F14),
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            height: 1.2,
                          ),
                          textAlign:
                              isHebrew ? TextAlign.right : TextAlign.left,
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),

                  if (widget.product['allowMultiplePurchases'] == true)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: CustomDropdown(
                        label: translate('search_product.search_product'),
                        initialValue: selectedQuantity,
                        items: List<String>.generate(
                          widget.product['maxPurchasesPerUser'] ?? 1,
                          (index) => (index + 1).toString(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedQuantity = value ?? '1';
                          });
                        },
                        hasError: false,
                        showSearchBar: false,
                        prependText: translate('search_product.quantity'),
                      ),
                    ),

                  Center(
                    child: Column(
                      children: [
                        CustomButton(
                          text: translate('search_product.request_guarantee'),
                          onPressed: () {
                            widget.saveSearchTerm(widget.product['name'] ?? '');
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return ReasonBottomBar(
                                  onConfirm:
                                      (reasonHeadline, reasonInfo) async {
                                    try {
                                      await TransactionService()
                                          .createTransaction(
                                        product: widget.product,
                                        reasonHeadline: reasonHeadline,
                                        reasonInfo: reasonInfo,
                                        quantity:
                                            int.tryParse(selectedQuantity) ?? 1,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(translate(
                                                'search_product.success'))),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(translate(
                                                'search_product.error'))),
                                      );
                                    }
                                  },
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          },
                          backgroundColor: const Color(0xff000089),
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),

                  // Additional Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SquareDetailWidget(
                          value: widget.product['warranty'],
                          title: translate(
                              'search_product.product_details.warranty'),
                          assetName: 'assets/check.png',
                        ),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: SquareDetailWidget(
                          value: widget.product['year'],
                          title:
                              translate('search_product.product_details.year'),
                          assetName: 'assets/calendar.png',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translate('store_details.store_details'),
                        style: const TextStyle(
                          color: Color(0xFF000089),
                          fontFamily: 'Rubik',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 16),
                      if (widget.product['storeID'] != null)
                        StoreDetailsWidget(storeID: widget.product['storeID'])
                      else
                        Text(
                          translate('store_details.not_available'),
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

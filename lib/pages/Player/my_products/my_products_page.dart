import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/player/my_products/widgets/contact_supplier_section.dart';
import 'package:hadadi/pages/player/my_products/widgets/guarantees_indicator.dart';
import 'package:hadadi/pages/player/my_products/widgets/header_section.dart';
import 'package:hadadi/pages/player/my_products/widgets/payment_in_progress_banner_widget.dart';
import 'package:hadadi/pages/player/my_products/widgets/price_details.dart';
import 'package:hadadi/pages/player/my_products/widgets/product_image_and_details.dart';
import 'package:hadadi/pages/player/my_products/widgets/time_left_indicator.dart';
import 'package:hadadi/services/DB/product_service.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:hadadi/services/DB/user_service.dart';
import 'package:hadadi/services/turbo_price_service.dart';
import 'package:hadadi/utils/filter_popup/filter_page.dart';
import 'package:hadadi/utils/guarantor_expansion_tile.dart';

import 'widgets/transaction_banner.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  final ProductService _productService = ProductService();
  final PricingService pricingService = PricingService();
  final UserService _userService = UserService();
  final TransactionService _transactionService = TransactionService();

  String _userName = '';
  Set<int> expandedItems = {};
  String _selectedStatus = translate('filter.all_statuses');
  Set<String> _selectedCategories = {translate('filter.all_categories')};
  double _minPrice = 0;
  double _maxPrice = 50000;

  final Map<String, bool> _isExpandedMap = {};

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isHebrew =
        LocalizedApp.of(context).delegate.currentLocale.languageCode == 'he';

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: Column(
        children: [
          headerSection(onFilterPressed: _showFilterPage),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchFilteredProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(translate('my_products.no_products')),
                  );
                }
                final combinedData = snapshot.data!;

                return ListView.builder(
                  itemCount: combinedData.length,
                  itemBuilder: (context, index) {
                    final productData = combinedData[index];
                    double price = (productData['price'] as int).toDouble();
                    double originalPrice = price;

                    String itemName =
                        productData['name'] ?? translate('my_products.no_name');
                    String imageUrl = productData['image'] ?? '';
                    String specifications = productData['specifications'] ??
                        translate('my_products.no_specifications');
                    String warrantyYear = productData['warranty'] ?? '0';

                    String transactionStatus =
                        productData['status'] ?? 'Active';
                    double finalPrice =
                        productData['finalPrice']?.toDouble() ?? price;
                    String storeID = productData['storeID'];

                    print(productData);

                    String type = productData['type'] ?? 'Basic';
                    int guaranteesAmount = productData['guaranteesAmount'] ?? 0;
                    List<dynamic> guarantees = productData['guarantees'] ?? [];
                    Timestamp endDate =
                        productData['endDate'] ?? Timestamp.now();
                    DateTime endDateTime = endDate.toDate();
                    Duration timeLeft = endDateTime.difference(DateTime.now());
                    String purchaseOrder = productData['purchaseOrder'];

                    if (type == 'Turbo') {
                      int hoursLeft = timeLeft.inHours;

                      price = pricingService.calculateTurboPrice(
                        originalPrice: originalPrice,
                        hoursLeft: hoursLeft,
                        timeDiscountValue: productData['timeDiscountValue'],
                        timeDiscount:
                            (productData['timeDiscount'] as num).toDouble(),
                        peopleDiscountValue: productData['peopleDiscountValue'],
                        peopleDiscount:
                            (productData['peopleDiscount'] as num).toDouble(),
                        guaranteesLength: guarantees.length,
                        guaranteesAmount: guaranteesAmount,
                      );
                    }

                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 20, left: 20, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (transactionStatus == 'inPaymentProgress')
                                paymentInProgressBanner(
                                    purchaseOrder, isHebrew),
                              if (transactionStatus != 'inPaymentProgress')
                                transactionTypeLabel(type, isHebrew),
                              const SizedBox(height: 10),
                              ProductImageAndDetails(
                                itemName: itemName,
                                specifications: specifications,
                                imageUrl: imageUrl,
                                isHebrew: isHebrew,
                                warrantyYear: warrantyYear,
                                transactionStatus: transactionStatus,
                                storeID: storeID,
                                userName: _userName,
                              ),
                              const SizedBox(height: 10),
                              priceDetailsSection(type, finalPrice,
                                  originalPrice, transactionStatus),
                              const SizedBox(height: 10),
                              ContactSupplierWidget(
                                isInPaymentProgress:
                                    transactionStatus == 'inPaymentProgress',
                                isHebrew: isHebrew,
                                storeID: storeID,
                                itemName: itemName,
                                finalPrice: finalPrice,
                                purchaseOrder: purchaseOrder,
                                timeLeftIndicator: buildTimeLeftIndicator(
                                    timeLeft, endDateTime, type),
                                guaranteesIndicator: buildGuaranteesIndicator(
                                    guarantees, guaranteesAmount),
                                userName: _userName,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                  ),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                      dividerColor: Colors.transparent),
                                  child: GuarantorsExpansionTile(
                                      guarantees: guarantees),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchUserName() async {
    try {
      final userId = await _userService.getCurrentUserId();
      if (userId == null) {
        setState(() {
          _userName = translate('my_products.guest');
        });
        return;
      }
      final userData = await _userService.getUserData(userId);
      if (userData != null) {
        setState(() {
          _userName = userData['name'] ?? translate('my_products.guest');
        });
      } else {
        setState(() {
          _userName = translate('my_products.guest');
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
      setState(() {
        _userName = translate('my_products.guest');
      });
    }
  }

  void _showFilterPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(39)),
            ),
            child: FilterPage(
              minPrice: _minPrice,
              maxPrice: _maxPrice,
              selectedCategories: _selectedCategories,
              selectedStatus: _selectedStatus,
              onApplyFilters: (status, categories, minPrice, maxPrice) {
                setState(() {
                  _selectedStatus = status;
                  _selectedCategories = categories;
                  _minPrice = minPrice;
                  _maxPrice = maxPrice;
                });
              },
              isFromMyProductsPage: true,
            ),
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchFilteredProducts() async {
    try {
      final userId = await _userService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User ID not found.');
      }

      final transactions = await _transactionService.getFilteredTransactions(
        userId: userId,
        selectedStatus: _selectedStatus,
        selectedCategories: _selectedCategories,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
      );

      List<Map<String, dynamic>> combinedData = [];

      for (var transaction in transactions) {
        final itemID = transaction['itemID'];
        if (itemID == null) continue;

        final productData = await _productService.getProductData(itemID);

        if (productData != null) {
          combinedData.add({
            ...productData,
            ...transaction,
          });
        } else {
          combinedData.add(transaction);
        }
      }

      return combinedData;
    } catch (e) {
      print('Error fetching filtered products: $e');
      return [];
    }
  }
}

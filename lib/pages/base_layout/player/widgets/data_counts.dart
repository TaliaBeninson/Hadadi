import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/services/DB/product_service.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:hadadi/services/DB/user_service.dart';

class DataCounts extends StatefulWidget {
  const DataCounts({super.key});

  @override
  _DataCountsState createState() => _DataCountsState();
}

class _DataCountsState extends State<DataCounts> {
  final UserService userService = UserService();
  final TransactionService transactionService = TransactionService();
  final ProductService productService = ProductService();

  late Future<List<String>> _cachedData;

  @override
  void initState() {
    super.initState();
    _cachedData = _fetchData(); // Cache the data
  }

  String formatPrice(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  Future<List<String>> _fetchData() async {
    int userCount = await userService.getTotalUserCount();
    double transactionSum = await transactionService.getTotalTransactionSum();
    int transactionCount = await transactionService.getTotalTransactionCount();
    int productCount = await productService.getTotalProductCount();

    return [
      formatPrice(userCount.toDouble()),
      '₪${formatPrice(transactionSum)}',
      formatPrice(transactionCount.toDouble()),
      formatPrice(productCount.toDouble()),
    ];
  }

  Widget buildDataCountItem({
    required String imageAsset,
    required String number,
    required String label,
  }) {
    return SizedBox(
      width: 80,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: Image.asset(imageAsset, width: 40, height: 40),
            ),
            Text(
              number,
              style: const TextStyle(
                color: Color(0xFF000089),
                fontFamily: 'Rubik',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF0F0F14),
                  fontFamily: 'Rubik',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _cachedData, // Use cached data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data ?? ['0', '₪0', '0', '0'];

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(42),
              bottomRight: Radius.circular(42),
            ),
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
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildDataCountItem(
                    imageAsset: 'assets/icon2.png',
                    number: data[0],
                    label: translate('data_counts.users'),
                  ),
                  const SizedBox(width: 22),
                  buildDataCountItem(
                    imageAsset: 'assets/icon4.png',
                    number: data[1],
                    label: translate('data_counts.in_use'),
                  ),
                  const SizedBox(width: 22),
                  buildDataCountItem(
                    imageAsset: 'assets/icon1.png',
                    number: data[2],
                    label: translate('data_counts.transactions'),
                  ),
                  const SizedBox(width: 22),
                  buildDataCountItem(
                    imageAsset: 'assets/icon3.png',
                    number: data[3],
                    label: translate('data_counts.products'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

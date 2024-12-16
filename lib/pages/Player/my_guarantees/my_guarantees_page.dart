import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hadadi/pages/Player/my_guarantees/guarantee_card.dart';
import 'package:hadadi/services/DB/product_service.dart';
import 'package:hadadi/services/DB/transaction_service.dart';
import 'package:hadadi/services/DB/user_service.dart';

class MyGuaranteesPage extends StatefulWidget {
  const MyGuaranteesPage({super.key});

  @override
  _MyGuaranteesPageState createState() => _MyGuaranteesPageState();
}

class _MyGuaranteesPageState extends State<MyGuaranteesPage> {
  final UserService _userService = UserService();
  final TransactionService _transactionService = TransactionService();
  final ProductService _productService = ProductService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _guarantees = [];

  @override
  void initState() {
    super.initState();
    _fetchGuarantees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _guarantees.isEmpty
              ? Center(child: Text(translate('guarantees.no_guarantees')))
              : ListView.builder(
                  itemCount: _guarantees.length,
                  itemBuilder: (context, index) {
                    var guarantee = _guarantees[index];
                    return GuaranteeCard(guarantee: guarantee);
                  },
                ),
    );
  }

  Future<void> _fetchGuarantees() async {
    try {
      String? currentUserId = await _userService.getCurrentUserId();
      if (currentUserId == null) throw Exception("User not logged in");
      Map<String, dynamic>? userData =
          await _userService.getUserData(currentUserId);
      List<dynamic> guaranteesProvided = userData?['guaranteesProvided'] ?? [];
      if (guaranteesProvided.isEmpty) {
        setState(() {
          _isLoading = false;
          _guarantees = [];
        });
        return;
      }

      List<Map<String, dynamic>> guarantees = [];
      for (String transactionId in guaranteesProvided) {
        var transactionData =
            await _transactionService.getTransactionData(transactionId);

        if (transactionData != null) {
          String itemId = transactionData['itemID'];
          String buyerId = transactionData['buyerID'];

          var productData = await _productService.getProductData(itemId);
          var buyerData = await _userService.getUserData(buyerId);

          transactionData['product'] = productData;
          transactionData['buyer'] = buyerData;
          guarantees.add(transactionData);
        }
      }

      setState(() {
        _guarantees = guarantees;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch guarantees: $e');
      setState(() {
        _isLoading = false;
        _guarantees = [];
      });
    }
  }
}

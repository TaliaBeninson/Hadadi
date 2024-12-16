import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_translate/flutter_translate.dart';

class TransactionService {
  // Creates a new transaction in Firebase Firestore.
  Future<String> createTransaction({
    required Map<String, dynamic> product,
    required String reasonHeadline,
    required String reasonInfo,
    required int quantity,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }
      String buyerID = user.uid;
      DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(product['itemID'])
          .get();

      if (!productSnapshot.exists) {
        throw Exception('Product not found');
      }
      final productData = productSnapshot.data() as Map<String, dynamic>;
      int guaranteeDays = productData['guaranteeDays'] ?? 0;
      int guaranteePayment = productData['guaranteePayment'] ?? 0;
      int guaranteesAmount = productData['guaranteesAmount'] ?? 0;

      int totalGuaranteesAmount = guaranteesAmount * quantity;
      DateTime endDate = DateTime.now().add(Duration(hours: guaranteeDays));
      DateTime purchaseDate = DateTime.now();

      String sellerID = productData['sellerID'];
      String storeID = productData['storeID'];
      DocumentReference transactionRef =
          await FirebaseFirestore.instance.collection('transactions').add({
        'buyerID': buyerID,
        'endDate': endDate,
        'itemID': product['itemID'],
        'itemName': product['name'],
        'price': int.parse(product['price']!),
        'purchaseDate': purchaseDate,
        'sellerID': sellerID,
        'transactionID': '',
        'guarantees': [],
        'reasonHeadline': reasonHeadline,
        'reasonInfo': reasonInfo,
        'guaranteePayment': guaranteePayment,
        'guaranteesAmount': totalGuaranteesAmount,
        'type': 'basic',
        'worstCasePrice': 0,
        'storeID': storeID,
        'status': 'inProgress',
        'purchaseOrder': "",
        'amount': quantity,
        'category': product['category'][0],
      });

      String transactionID = transactionRef.id;
      await transactionRef.update({'transactionID': transactionID});

      return transactionID;
    } catch (e) {
      print('Error creating transaction: $e');
      rethrow;
    }
  }

  // Fetch transaction data and return a list of maps
  Future<List<Map<String, dynamic>>> getTransactionsForSeller(
      String sellerID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('sellerID', isEqualTo: sellerID)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Fetch transaction data by ID
  Future<Map<String, dynamic>?> getTransactionData(String transactionId) async {
    try {
      DocumentSnapshot transactionSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .get();

      if (transactionSnapshot.exists) {
        return transactionSnapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching transaction data: $e');
      throw Exception('Failed to fetch transaction data');
    }
  }

  /// Fetches transactions excluding those made by the current user and those that current user approved already
  Future<List<Map<String, dynamic>>> fetchTransactions() async {
    String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

    try {
      QuerySnapshot transactionSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .where('buyerID', isNotEqualTo: currentUserID)
          .get();

      return transactionSnapshot.docs
          .where((doc) {
            var data = doc.data() as Map<String, dynamic>;

            List<dynamic>? reportSpam = data['reportSpam'] as List<dynamic>?;
            if (reportSpam != null && reportSpam.contains(currentUserID)) {
              return false;
            }

            List<dynamic>? guarantees = data['guarantees'] as List<dynamic>?;
            if (guarantees != null &&
                guarantees.any((guarantee) =>
                    (guarantee as Map<String, dynamic>)['guarantorID'] ==
                    currentUserID)) {
              return false;
            }

            DateTime endDate = (data['endDate'] as Timestamp).toDate().toUtc();
            String type = (data['type'] ?? '').toLowerCase();

            if (endDate.isBefore(DateTime.now().toUtc()) && type == 'basic') {
              return false;
            }

            String status = (data['status'] ?? '');
            if (status == 'inPaymentProgress') {
              return false;
            }

            return true;
          })
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow;
    }
  }

  /// Adds a guarantee to the transaction.
  Future<void> addGuarantee({
    required String transactionId,
    required String guarantorId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .update({
        'guarantees': FieldValue.arrayUnion([
          {
            'guarantorID': guarantorId,
            'timestamp': Timestamp.now(),
          }
        ])
      });
    } catch (e) {
      print('Error adding guarantee: $e');
      throw Exception('Failed to add guarantee');
    }
  }

  // Get the total sum of all transaction prices
  Future<double> getTotalTransactionSum() async {
    try {
      QuerySnapshot transactionsSnapshot =
          await FirebaseFirestore.instance.collection('transactions').get();
      double totalSum = transactionsSnapshot.docs.fold(0.0, (sum, doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return sum + (data['price'] as int).toDouble();
      });
      return totalSum;
    } catch (e) {
      print('Error fetching total transaction sum: $e');
      throw Exception('Failed to fetch total transaction sum');
    }
  }

  // Get the total number of transactions
  Future<int> getTotalTransactionCount() async {
    try {
      QuerySnapshot transactionsSnapshot =
          await FirebaseFirestore.instance.collection('transactions').get();
      return transactionsSnapshot.docs.length;
    } catch (e) {
      print('Error fetching transaction count: $e');
      throw Exception('Failed to fetch transaction count');
    }
  }

  /// Checks if all guarantees for a transaction are fulfilled.
  Future<bool> isGuaranteeComplete({
    required String transactionId,
  }) async {
    try {
      DocumentSnapshot transactionSnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transactionId)
          .get();

      if (!transactionSnapshot.exists) {
        throw Exception('Transaction not found');
      }

      var transactionData = transactionSnapshot.data() as Map<String, dynamic>;
      List<dynamic> guarantees = transactionData['guarantees'] ?? [];
      int guaranteesAmount = transactionData['guaranteesAmount'] ?? 0;

      return guarantees.length >= guaranteesAmount;
    } catch (e) {
      print('Error checking guarantee completion: $e');
      throw Exception('Failed to check guarantee completion');
    }
  }

  Future<List<Map<String, dynamic>>> getFilteredTransactions({
    required String userId,
    required String selectedStatus,
    required Set<String> selectedCategories,
    required double minPrice,
    required double maxPrice,
  }) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection('transactions')
          .where('buyerID', isEqualTo: userId);

      if (selectedStatus != translate('filter.all_statuses')) {
        if (selectedStatus == translate('filter.payment')) {
          query = query.where('status', isEqualTo: translate('filter.payment'));
        } else {
          query = query
              .where('status', isNotEqualTo: translate('filter.payment'))
              .where('type',
                  isEqualTo: selectedStatus == translate('filter.basic_status')
                      ? 'basic'
                      : 'Turbo');
        }
      }

      query = query
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice);

      if (!selectedCategories.contains(translate('filter.all_categories'))) {
        query = query.where('category', whereIn: selectedCategories.toList());
      }

      query = query.orderBy('price');

      QuerySnapshot querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching filtered products: $e');
      return [];
    }
  }
}

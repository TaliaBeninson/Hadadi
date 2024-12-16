import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the total number of products
  Future<int> getTotalProductCount() async {
    try {
      QuerySnapshot productsSnapshot =
          await _firestore.collection('products').get();
      return productsSnapshot.docs.length;
    } catch (e) {
      print('Error fetching product count: $e');
      throw Exception('Failed to fetch product count');
    }
  }

  // Fetch product data by itemID
  Future<Map<String, dynamic>?> getProductData(String itemId) async {
    try {
      final doc = await _firestore.collection('products').doc(itemId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching product data: $e');
      throw Exception('Failed to fetch product data');
    }
  }

  // Fetch all active products
  Future<List<Map<String, dynamic>>> getActiveProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('status', isEqualTo: 'active')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'category': data['category'] ?? 'Uncategorized',
          'image': data['image'] ?? '',
          'itemID': doc.id,
          'linkToProduct': data['linkToProduct'] ?? '',
          'name': data['name'] ?? 'Unnamed product',
          'price': data['price']?.toString() ?? '0',
          'sellerID': data['sellerID'] ?? 'Unknown seller',
          'specifications':
              data['specifications'] ?? 'No specifications available',
          'status': data['status'] ?? 'Unknown status',
          'storeID': data['storeID'] ?? 'Unknown store',
          'warranty': data['warranty'] ?? 'No warranty available',
          'year': data['year'] ?? 'Unknown year',
          'allowMultiplePurchases': data['allowMultiplePurchases'] ?? false,
          'maxPurchasesPerUser': data['maxPurchasesPerUser'] ?? 1,
          'stock': data['stock'] ?? 0
        };
      }).toList();
    } catch (e) {
      print('Error fetching active products: $e');
      throw Exception('Failed to fetch active products');
    }
  }
}

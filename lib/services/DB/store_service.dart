import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch store details by storeID
  Future<Map<String, dynamic>?> fetchStoreDetails(String storeID) async {
    try {
      DocumentSnapshot storeSnapshot =
          await _firestore.collection('stores').doc(storeID).get();

      if (storeSnapshot.exists) {
        return storeSnapshot.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching store details: $e');
      return null;
    }
  }

  /// Fetch store details by ownerID
  Future<Map<String, dynamic>?> fetchStoreDetailsByOwnerID(
      String? ownerID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('stores')
          .where('ownerID', isEqualTo: ownerID)
          .limit(1) // Limit to one result
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        print('No store found for the given ownerID.');
        return null;
      }
    } catch (e) {
      print('Error fetching store details by ownerID: $e');
      return null;
    }
  }
}

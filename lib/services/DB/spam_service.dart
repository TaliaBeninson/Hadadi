import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SpamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Report spam
  Future<void> reportSpam({
    required String transactionId,
    required String buyerId,
    required String productName,
  }) async {
    String currentUserID = FirebaseAuth.instance.currentUser?.uid ?? '';
    Map<String, dynamic> reportData = {
      'transactionID': transactionId,
      'buyerID': buyerId,
      'productName': productName,
      'timestamp': Timestamp.now(),
      'reportedBy': currentUserID,
    };

    try {
      // Add spam report to 'reported_spam' collection
      await _firestore.collection('reported_spam').add(reportData);

      // Update the transaction to include the spam report
      await _firestore.collection('transactions').doc(transactionId).update({
        'reportSpam': FieldValue.arrayUnion([currentUserID]),
      });
    } catch (e) {
      throw Exception('Failed to report spam: $e');
    }
  }
}

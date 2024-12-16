import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current user's ID
  Future<String?> getCurrentUserId() async {
    return _auth.currentUser?.uid;
  }

  // Fetch user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> data) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(data);
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  // Check if user is pending approval
  Future<bool> isUserPendingApproval(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('pendingUsers')
          .where('email', isEqualTo: email)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking pending approval: $e');
      return false;
    }
  }

  // Check if password is temporary
  Future<bool> isPasswordTemporary(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.exists && (userDoc['isPasswordTemporary'] ?? false);
    } catch (e) {
      print('Error checking temporary password: $e');
      return false;
    }
  }

  // Get the total number of users
  Future<int> getTotalUserCount() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      return usersSnapshot.docs.length;
    } catch (e) {
      print('Error fetching user count: $e');
      throw Exception('Failed to fetch user count');
    }
  }

  //add user signup to pending users collection
  Future<void> addToPendingUsers({
    required String userId,
    required String email,
    required String fullName,
    required String phone,
    required String id,
    required String socialMediaLink,
    required String profileImageUrl,
    required List<String> interests,
    required String city,
    required String street,
  }) async {
    try {
      await _firestore.collection('pendingUsers').doc(userId).set({
        'userId': userId,
        'email': email,
        'fullName': fullName,
        'phone': phone,
        'id': id,
        'socialMediaLink': socialMediaLink,
        'profileImageUrl': profileImageUrl,
        'interests': interests,
        'city': city,
        'street': street,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add user to pendingUsers: $e');
    }
  }

  // Updates user guarantees for the buyer and guarantor.
  Future<void> updateUserGuarantees({
    required String guarantorId,
    required String buyerId,
    required String transactionId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(guarantorId)
          .update({
        'guaranteesProvided': FieldValue.arrayUnion([transactionId]),
      });

      await FirebaseFirestore.instance.collection('users').doc(buyerId).update({
        'guaranteesReceived': FieldValue.arrayUnion([transactionId]),
      });
    } catch (e) {
      print('Error updating user guarantees: $e');
      throw Exception('Failed to update user guarantees');
    }
  }
}

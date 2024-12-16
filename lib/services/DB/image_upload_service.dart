import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadProfileImage(File image) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('User not authenticated.');
      }
      String userEmail = user.email!;
      String sanitizedEmail = userEmail.replaceAll(RegExp(r'[^\w\.]+'), '_');

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$sanitizedEmail.jpg');

      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<String?> getProfileImageUrl(String email) async {
    try {
      String sanitizedEmail = email.replaceAll(RegExp(r'[^\w\.]+'), '_');
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$sanitizedEmail.jpg');

      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error fetching profile image URL: $e');
      return null;
    }
  }
}

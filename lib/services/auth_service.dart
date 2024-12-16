import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'DB/image_upload_service.dart';
import 'DB/user_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final UserService _userService = UserService();
  final ImageUploadService _imageUploadService = ImageUploadService();

  User? get currentUser => _firebaseAuth.currentUser;

  // Initialize the listener for FCM token refresh
  void initializeFCMTokenListener() {
    // Attach listener for when the token gets refreshed
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("FCM Token refreshed: $newToken");
      _updateTokenInFirestore(newToken);
    });
  }

  // Update Firestore with the refreshed token
  Future<void> _updateTokenInFirestore(String newToken) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'fcmToken': newToken,
        });
        print("FCM token updated in Firestore for user: ${user.uid}");
      } catch (e) {
        print("Error updating FCM token in Firestore: $e");
      }
    } else {
      print("No logged-in user found to update FCM token.");
    }
  }

  // Sign up with email and password
  Future<String?> signUp(String email, String password) async {
    try {
      // Create a new user with Firebase Auth
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      // Return the user ID
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception(
              'The email address is already in use by another account.');
        case 'weak-password':
          throw Exception('The password provided is too weak.');
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        default:
          throw Exception('An unexpected error occurred. Please try again.');
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<bool> checkEmailVerification() async {
    await currentUser?.reload();
    return currentUser?.emailVerified ?? false;
  }

  Future<void> deleteOldUserAndCreateNewUser({
    required String oldEmail,
    required String newEmail,
    required String tempPassword,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    try {
      // Delete the old user
      await user.delete();

      UserCredential newUserCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: newEmail,
        password: tempPassword,
      );

      await newUserCredential.user?.sendEmailVerification();

      print("New user created with updated email and verification sent.");
    } catch (e) {
      throw Exception('Failed to recreate user: $e');
    }
  }

// Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email not verified. Verification email has been sent.',
        );
      }
      await _saveFCMToken(userCredential.user);

      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset Password Error: $e');
    }
  }

  // Wait for email verification
  Future<void> waitForEmailVerification(User user) async {
    while (!user.emailVerified) {
      await Future.delayed(const Duration(seconds: 5));
      await user.reload();
      user = _firebaseAuth.currentUser!;
    }
  }

  // Save FCM token in Firestore
  Future<void> _saveFCMToken(User? user) async {
    if (user == null) return;

    try {
      // Get FCM token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Save token only if it's new or different
        if (!userDoc.exists || userDoc['fcmToken'] != token) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'fcmToken': token,
          });
          print('FCM Token saved successfully: $token');
        }
      } else {
        print('Failed to get FCM token.');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  // Update user password
  Future<void> updatePassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception('No authenticated user found.');
    }
  }

  // Handle background and foreground notification callbacks
  void setupFCMNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground notification: ${message.notification?.title}');
      // Handle the foreground notification here (e.g., display an in-app notification)
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Opened the app via notification: ${message.notification?.title}');
      // Handle the notification when the app is opened via tapping on a notification
    });
  }

  // Background notification handler
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling background message: ${message.notification?.title}');
  }
}

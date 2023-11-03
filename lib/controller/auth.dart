// import 'package:CleanCare/screen/owner/navbar.dart';
import 'package:CleanCare/screen/owner/layout_admin.dart';
import 'package:CleanCare/screen/user/layout_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user != null) {
        await _firestore
            .collection('user')
            .doc(user.uid)
            .set({'fullName': fullName, 'email': email, 'Password': password});
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection("user").doc(user.uid).get();
        final adminDoc =
            await _firestore.collection("admin").doc(user.uid).get();
        if (userDoc.exists) {
          // User document exists, indicating a regular user.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LayoutPages()),
          );
        } else if (adminDoc.exists) {
          // Admin document exists, indicating an admin.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LayoutAdmin()),
          );
        } else {
          // Neither user nor admin document exists, handle as needed.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const LayoutPages()), // You may want to handle this case differently.
          );
        }
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> resetPasswordAndSaveToFirestore(
      String email, String newPassword) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: newPassword,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('user').doc(user.uid).update({
          'password': newPassword,
        });
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }
}

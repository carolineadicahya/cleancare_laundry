import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection("user").doc(user.uid).get();
        if (!userDoc.exists) {}

        final adminDoc =
            await _firestore.collection("admin").doc(user.uid).get();
        if (!adminDoc.exists) {}
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }

  // Future<bool> checkAdminCredentials(String email, String password) async {
  //   try {
  //     final adminSnapshot =
  //         await _firestore.collection("admin").doc(email).get();

  //     if (adminSnapshot.exists) {
  //       final adminData = adminSnapshot.data() as Map<String, dynamic>;
  //       final storedEmail = adminData['email'];
  //       final storedPassword = adminData['password'];

  //       if (storedEmail == email && storedPassword == password) {
  //         return true; // Email dan password cocok dengan admin.
  //       }
  //     }
  //   } catch (e) {
  //     print("Error checking admin credentials: $e");
  //   }
  //   return false; // Kredensial admin tidak valid.
  // }

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

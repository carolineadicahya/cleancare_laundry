import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<Map<String, dynamic>> loadUserProfile(User user) async {
    final userDoc = await _firestore.collection('user').doc(user.uid).get();
    if (userDoc.exists) {
      final profileData = userDoc.data() as Map<String, dynamic>;
      return profileData;
    } else {
      return {};
    }
  }

  Future<void> updateProfile(
      User user, Map<String, dynamic> profileData) async {
    final userDocRef = _firestore.collection('profil').doc(user.uid);
    await userDocRef.set(profileData, SetOptions(merge: true));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class LaundryService {
  // final User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance.collection('layanan');

  // READ: list layanan
  Stream<QuerySnapshot> layanan(String id) {
    return db
        .doc(id)
        .collection('layanan')
        .orderBy('nama', descending: true)
        .snapshots();
  }

  // ADD: tambah layanan
  Future<void> addLayanan(Map<String, dynamic> body, String ServiceId) {
    return db.doc(ServiceId).collection('layanan').add(body);
  }

  // DELETE: hapus layanan
  Future<void> deleteLayanan(String ServiceId, String id) {
    return db.doc(ServiceId).collection('layanan').doc(id).delete();
  }
}

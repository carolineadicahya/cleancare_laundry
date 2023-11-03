import 'package:cloud_firestore/cloud_firestore.dart';

class LaundryService {
  final db = FirebaseFirestore.instance.collection('layanan');

  Stream<QuerySnapshot> getData() {
    final dataStream = db.snapshots();
    return dataStream;
  }

  // READ: ambil data detail Layanan
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDetail(String id) {
    final dataStream = db.doc(id).snapshots();
    return dataStream;
  }

  // ADD: tambah layanan ke subkoleksi 'layanan'
  Future<void> addLayanan(Map<String, dynamic> body) {
    return db.add(body);
  }

// UPDATE: perbarui layanan dalam subkoleksi 'layanan'
  Future<void> updateLayanan(String id, Map<String, dynamic> body) {
    return db.doc(id).update(body);
  }

  // DELETE: hapus layanan dalam subkoleksi 'layanan'
  Future<void> deleteLayanan(String id) {
    return db.doc(id).delete();
  }
}

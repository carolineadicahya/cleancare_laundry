// import 'package:CleanCare/models/card_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final db = FirebaseFirestore.instance.collection('order');

  // READ: ambil data get all
  Stream<QuerySnapshot> getData() {
    final dataStream =
        db.orderBy('tanggal order', descending: true).snapshots();
    return dataStream;
  }

  // READ: ambil data detail Order get by id
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDetail(String id) {
    final dataStream = db.doc(id).snapshots();
    return dataStream.map(
      (snapshot) => snapshot as DocumentSnapshot<Map<String, dynamic>>,
    );
  }

  // ADD: tambah orderan
  Future<String> addOrder(Map<String, dynamic> body) async {
    var result = await db.add(body);
    return result.id;
  }

  // UPDATE: perbarui order
  Future<void> updateOrder(String id, Map<String, dynamic> body) {
    return db.doc(id).update(body);
  }

  // DELETE: hapus order
  Future<void> cancelOrder(String id) {
    return db.doc(id).delete();
  }

  Future<void> updateOrderStatus(String id, String newStatus) async {
    await db.doc(id).update({'status': newStatus});
  }
}

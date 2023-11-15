import 'package:CleanCare/models/card_order.dart';
import 'package:CleanCare/screen/user/detail_order.dart';
import 'package:CleanCare/service/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Laundry'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: orderService.getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              var items = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final history = items[index].data() as Map<String, dynamic>;
                  final isCancelled = history['status'] == 'Cancel';
                  final textColor = isCancelled ? Colors.red : Colors.green;

                  return OrderCard(
                    email: history['email'] ?? '',
                    items: (history['items'] as List<dynamic>?)
                            ?.map<Map<String, dynamic>>((item) {
                          if (item is Map<String, dynamic>) {
                            return item;
                          } else {
                            // Handle the case where 'items' is not a List<Map<String, dynamic>>
                            return {};
                          }
                        }).toList() ??
                        [],
                    orderDate: (history['tanggal order'] as Timestamp).toDate(),
                    status: getOrderStatus(history['status'] ?? ''),
                    onDetail: () {
                      final String id = items[index].id;
                      if (id != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderDetailPage(
                              id: id,
                            ),
                          ),
                        );
                      }
                      // else {
                      //   // Handle the case where 'id' is null, for example, show an error message.
                      //   print("ID Order tidak ditemukan");
                      // }
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  OrderStatus getOrderStatus(String status) {
    switch (status) {
      case 'Pesanan Diterima':
        return OrderStatus.DITERIMA;
      case 'Dalam Pengerjaan':
        return OrderStatus.DALAM_PENGERJAAN;
      case 'Pesanan Selesai':
        return OrderStatus.SELESAI;
      case 'Cancel':
        return OrderStatus.CANCEL;
      default:
        return OrderStatus
            .DITERIMA; // Default status jika tidak sesuai dengan yang diharapkan
    }
  }
}

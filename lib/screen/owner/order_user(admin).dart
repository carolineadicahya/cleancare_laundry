import 'package:CleanCare/models/card_order.dart';
import 'package:CleanCare/screen/owner/detail_order_user(admin).dart';
import 'package:CleanCare/screen/owner/layout_admin.dart';
import 'package:CleanCare/service/notifikasi_service.dart';
import 'package:CleanCare/service/order_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderUser extends StatefulWidget {
  const OrderUser({Key? key});

  @override
  _OrderUserState createState() => _OrderUserState();
}

class _OrderUserState extends State<OrderUser> {
  OrderService orderService = OrderService();
  NotifikasiService notifikasiService = NotifikasiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order User'),
        centerTitle: true,
      ),
      body: Padding(
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
                  orderDate:
                      (history['tanggal order'] as Timestamp?)?.toDate() ??
                          DateTime.now(),
                  status: getOrderStatus(history['status'] ?? ''),
                  onDetail: () {
                    final String id = items[index].id;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AdminOrderDetailPage(
                          id: id,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
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
      case 'Selesai':
        return OrderStatus.SELESAI;
      case 'di Cancel':
        return OrderStatus.CANCEL;
      default:
        return OrderStatus
            .DITERIMA; // Default status jika tidak sesuai dengan yang diharapkan
    }
  }
}

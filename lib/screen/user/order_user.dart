import 'package:CleanCare/models/card_order.dart';
import 'package:CleanCare/screen/user/detail_order.dart';
import 'package:CleanCare/service/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
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
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openWhatsApp,
        label: Text("Chat Admin"),
        backgroundColor:
            Color.fromARGB(255, 81, 207, 85), // Change to the desired color
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    // Replace the phone number with the desired number
    String phoneNumber = "+6281549205176";
    // Create the WhatsApp URL
    String url = "https://wa.me/$phoneNumber";
    // Check if the WhatsApp app is installed and launch the URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
        return OrderStatus.DITERIMA;
    }
  }
}

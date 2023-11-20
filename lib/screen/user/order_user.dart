import 'package:CleanCare/models/card_order.dart';
import 'package:CleanCare/screen/user/detail_order.dart';
import 'package:CleanCare/screen/user/layout_user.dart';
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
  List<String> dismissedItems = [];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Laundry'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LayoutPages(),
              ),
            );
          },
        ),
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
              var userOrders = items
                  .where((order) => order['email'] == user?.email)
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: userOrders.length,
                itemBuilder: (context, index) {
                  final history =
                      userOrders[index].data() as Map<String, dynamic>;
                  final status = getOrderStatus(history['status'] ?? '');

                  return Dismissible(
                    key: Key(userOrders[index].id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      // Allow dismissal only if the status is 'Cancel' or 'Selesai'
                      return status == OrderStatus.CANCEL ||
                          status == OrderStatus.SELESAI;
                    },
                    onDismissed: (direction) {
                      // Add the dismissed item key to the list
                      dismissedItems.add(userOrders[index].id);
                    },
                    child: OrderCard(
                      email: history['email'] ?? '',
                      items: (history['items'] as List<dynamic>?)
                              ?.map<Map<String, dynamic>>((item) {
                            if (item is Map<String, dynamic>) {
                              return item;
                            } else {
                              return {};
                            }
                          }).toList() ??
                          [],
                      orderDate:
                          (history['tanggal order'] as Timestamp).toDate(),
                      status: status,
                      onDetail: () {
                        final String id = userOrders[index].id;
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
                    ),
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
    String number = "+6281549205176";
    // Create the WhatsApp URL
    String url = "https://wa.me/$number";
    // Check if the WhatsApp app is installed and launch the URL
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print("cannot launch $url: $e");
    }
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
        return OrderStatus.DITERIMA;
    }
  }
}

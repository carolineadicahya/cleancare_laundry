import 'dart:math';

import 'package:CleanCare/screen/user/detail_order.dart';
import 'package:CleanCare/service/order_service.dart';
import 'package:CleanCare/widgets/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/order.dart' as order_widget;

class LatestOrdersUser extends StatelessWidget {
  final orderService = OrderService();
  LatestOrdersUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Terbaru",
                  style: TextStyle(
                    color: Color.fromRGBO(19, 22, 33, 1),
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: orderService.getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var items = snapshot.data!.docs;
              var userOrders = items
                  .where((order) => order['email'] == user?.email)
                  .toList();

              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(3, userOrders.length),
                itemBuilder: (context, index) {
                  final history =
                      userOrders[index].data() as Map<String, dynamic>;
                  final DateTime orderDate =
                      (history['tanggal order'] as Timestamp).toDate();
                  final status = getOrderStatusText(history['status'] ?? '');

                  // Let's pass the order details to the OrderCard widget
                  return order_widget.Order(
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
                    orderDate: orderDate,
                    estimationDate: orderDate.add(Duration(days: 3)),
                    status: status,
                    onDetail: () {
                      final String id = userOrders[index].id;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderDetailPage(
                            id: id,
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 15.0,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  OrderStatus getOrderStatusText(String status) {
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

import 'dart:math';

import 'package:CleanCare/screen/owner/detail_order_user(admin).dart';
import 'package:CleanCare/service/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/order.dart';

class LatestOrdersAdmin extends StatelessWidget {
  OrderService orderService = OrderService();
  LatestOrdersAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(2, items.length),
                itemBuilder: (context, index) {
                  final history = items[index].data() as Map<String, dynamic>;
                  // Let's pass the order details to the OrderCard widget
                  return Order(
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
                    orderDate: (history['tanggal order'] as Timestamp).toDate(),
                    onDetail: () {
                      final String id = items[index].id;
                      if (id != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AdminOrderDetailPage(
                              id: id,
                            ),
                          ),
                        );
                      }
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
}

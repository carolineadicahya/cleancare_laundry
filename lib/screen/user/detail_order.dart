import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CleanCare/service/order_service.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key, required this.id});

  final String id;

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Map<String, dynamic> order = {};
  final OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 140, 173),
      appBar: AppBar(
        title: Text('Order Detail'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: orderService.getDetail(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot? item = snapshot.data;
            DateTime? tanggalOrder =
                (item?['tanggal order'] as Timestamp).toDate();

            order = {
              "email": item?['email'] ?? '',
              "items": (item?['items'] as List<dynamic>?)
                      ?.map<Map<String, dynamic>>((item) {
                    if (item is Map<String, dynamic>) {
                      return {
                        "nama_paket": item['nama paket'],
                        "quantity": item['quantity'],
                        "total": item['total'],
                      };
                    } else {
                      // Handle the case where 'items' is not a List<Map<String, dynamic>>
                      return {};
                    }
                  }).toList() ??
                  [],
              "tanggal_order": (item?['tanggal order'] as Timestamp).toDate(),
            };

            return OrderDetailBody(
              id: item!.id,
              email: item!['email'],
              items: (item!['items'] as List<dynamic>?)
                      ?.map<Map<String, dynamic>>((item) {
                    if (item is Map<String, dynamic>) {
                      return {
                        "nama_paket": item!['nama paket'],
                        "quantity": item!['quantity'],
                        "total": item!['total'],
                      };
                    } else {
                      // Handle the case where 'items' is not a List<Map<String, dynamic>>
                      return {};
                    }
                  }).toList() ??
                  [],
              tanggalOrder: (item?['tanggal order'] as Timestamp).toDate(),
              estimasiSelesai: tanggalOrder?.add(Duration(days: 3)),
              orderService: orderService,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class OrderDetailBody extends StatelessWidget {
  const OrderDetailBody({
    Key? key,
    required this.id,
    this.email,
    this.items,
    this.tanggalOrder,
    this.estimasiSelesai,
    required this.orderService,
  });

  final String id;
  final String? email;
  final List<Map<String, dynamic>>? items;
  final DateTime? tanggalOrder;
  final DateTime? estimasiSelesai;
  final OrderService? orderService;

  @override
  Widget build(BuildContext context) {
    double estimasiTotal = items!
        .map<double>((item) => (item['total'] as num).toDouble())
        .fold(0, (a, b) => a + b);

    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: $id',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Text(
            'Email: $email',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          for (var item in items!)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['nama_paket']}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                Text('Quantity: ${item['quantity']}'),
                SizedBox(height: 8.0),
                Text('Total: ${item['total']}'),
                SizedBox(height: 16.0),
              ],
            ),
          Text(
            'Estimasi Total: $estimasiTotal',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          Text(
            'Tanggal Order: ${DateFormat('dd MMMM yyyy').format(tanggalOrder!)}',
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            'Estimasi Selesai: ${DateFormat('dd MMMM yyyy').format(estimasiSelesai!)}',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

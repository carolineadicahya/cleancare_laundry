import 'package:CleanCare/models/card_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CleanCare/service/order_service.dart';

class AdminOrderDetailPage extends StatefulWidget {
  const AdminOrderDetailPage({Key? key, required this.id});

  final String id;

  @override
  _AdminOrderDetailPageState createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
  Map<String, dynamic> order = {};
  final OrderService orderService = OrderService();

  void _updateOrderStatus(String status) {
    orderService.updateOrderStatus(widget.id, status as OrderStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: orderService.getDetail(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot? item = snapshot.data;

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
                      return {};
                    }
                  }).toList() ??
                  [],
              "tanggal_order": (item?['tanggal order'] as Timestamp).toDate(),
            };

            return OrderDetailBody(
              id: item!.id,
              email: item!['email'],
              items: (item['items'] as List<dynamic>?)
                      ?.map<Map<String, dynamic>>((item) {
                    if (item is Map<String, dynamic>) {
                      return {
                        "nama_paket": item['nama paket'],
                        "quantity": item['quantity'],
                        "total": item['total'],
                      };
                    } else {
                      return {};
                    }
                  }).toList() ??
                  [],
              tanggalOrder: (item?['tanggal order'] as Timestamp).toDate(),
              orderService: orderService,
              onUpdateStatus: (status) {
                _updateOrderStatus(status);
                // Update the status in the OrderCard by calling the callback
                setState(() {
                  order['status'] = status;
                });
              },
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
    required this.orderService,
    required this.onUpdateStatus,
  });

  final String id;
  final String? email;
  final List<Map<String, dynamic>>? items;
  final DateTime? tanggalOrder;
  final OrderService? orderService;
  final void Function(String) onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    double estimasiTotal = items!
        .map<double>((item) => (item['total'] as num).toDouble())
        .fold(0, (a, b) => a + b);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
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
            'Order Date: $tanggalOrder',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () => onUpdateStatus('Dalam Pengerjaan'),
            child: Text('Dalam Pengerjaan'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => onUpdateStatus('Pesanan Selesai'),
            child: Text('Pesanan Selesai'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => onUpdateStatus('Cancel'),
            child: Text('Cancel'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

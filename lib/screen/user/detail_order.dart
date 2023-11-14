import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:CleanCare/service/order_service.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key, required this.id}) : super(key: key);

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
              "email": item!['email'],
              "nama paket": item['nama_paket'],
              "quantity": item['quantity'],
              "total": item['total'],
              "tanggal order": item['tanggal_order'],
            };
            return OrderDetailBody(
              id: item.id,
              email: item['email'],
              namaPaket: item['nama_paket'],
              quantity: item['quantity'],
              total: item['total'],
              tanggalOrder: item['tanggal_order'],
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
    required this.email,
    required this.namaPaket,
    required this.quantity,
    required this.total,
    required this.tanggalOrder,
    required this.orderService,
  }) : super(key: key);

  final String id;
  final String email;
  final String namaPaket;
  final int quantity;
  final double total;
  final DateTime tanggalOrder;
  final OrderService orderService;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Order ID: $id'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Email: $email'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Package Name: $namaPaket'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Quantity: $quantity'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Total: $total'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Order Date: $tanggalOrder'),
        ),
      ],
    );
  }
}

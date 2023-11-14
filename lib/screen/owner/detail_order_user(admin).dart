import 'package:CleanCare/models/card_order.dart';
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
              "status": item['status']
            };
            return OrderDetailBody(
              id: item.id,
              email: item['email'],
              namaPaket: item['nama_paket'],
              quantity: item['quantity'],
              total: item['total'],
              tanggalOrder: item['tanggal_order'],
              status: item['status'],
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
    required this.status,
    required this.orderService,
  }) : super(key: key);

  final String id;
  final String email;
  final String namaPaket;
  final int quantity;
  final double total;
  final DateTime tanggalOrder;
  final String status;
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Status: $status'),
        ),
        SizedBox(height: 16.0),

        // Tombol untuk mengubah status menjadi "Dalam Pengerjaan"
        if (status != 'Dalam Pengerjaan')
          ElevatedButton(
            onPressed: () {
              updateOrderStatus(context, 'Dalam Pengerjaan');
            },
            child: Text('Mulai Pengerjaan'),
          ),
        SizedBox(height: 8.0),

        // Tombol untuk mengubah status menjadi "Pesanan Selesai"
        if (status != 'Pesanan Selesai')
          ElevatedButton(
            onPressed: () {
              updateOrderStatus(context, 'Pesanan Selesai');
            },
            child: Text('Selesaikan Pesanan'),
          ),
        SizedBox(height: 8.0),

        // Tombol untuk mengubah status menjadi "Cancel"
        if (status != 'Cancel')
          ElevatedButton(
            onPressed: () {
              updateOrderStatus(context, 'Cancel');
            },
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: Text('Cancel Pesanan'),
          ),
      ],
    );
  }

  void updateOrderStatus(BuildContext context, String newStatus) {
    // Panggil fungsi orderService untuk memperbarui status pesanan
    orderService.updateOrderStatus(id, newStatus as OrderStatus);

    // Tampilkan snackbar atau pesan sukses atau handle logika sesuai kebutuhan
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pesanan berhasil diubah menjadi $newStatus'),
      ),
    );
  }
}

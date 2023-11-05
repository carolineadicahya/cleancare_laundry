import 'package:flutter/material.dart';

class OrderDetail {
  final String userName;
  final String service;
  final double servicePrice;
  final int quantity;
  final double subtotal;
  final DateTime estimatedCompletionDate;
  String status;

  OrderDetail({
    required this.userName,
    required this.service,
    required this.servicePrice,
    required this.quantity,
    required this.subtotal,
    required this.estimatedCompletionDate,
    required this.status,
  });
}

class AdminOrderDetailPage extends StatefulWidget {
  final OrderDetail orderDetail;

  AdminOrderDetailPage({required this.orderDetail});

  @override
  _AdminOrderDetailPageState createState() => _AdminOrderDetailPageState();
}

class _AdminOrderDetailPageState extends State<AdminOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama User: ${widget.orderDetail.userName}'),
            Text('Layanan: ${widget.orderDetail.service}'),
            Text(
                'Harga Perlayanan: \$${widget.orderDetail.servicePrice.toStringAsFixed(2)}'),
            Text('Jumlah: ${widget.orderDetail.quantity}'),
            Text(
                'Estimasi Subtotal: \$${widget.orderDetail.subtotal.toStringAsFixed(2)}'),
            Text(
                'Estimasi Tanggal Selesai: ${widget.orderDetail.estimatedCompletionDate.toLocal()}'),
            Row(
              children: [
                Text('Status Order: ${widget.orderDetail.status}'),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Mengubah status pembelian menjadi 'Sedang dikerjakan'
                    setState(() {
                      widget.orderDetail.status = 'Sedang dikerjakan';
                    });
                  },
                  child: Text('Sedang dikerjakan'),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Mengubah status pembelian menjadi 'Selesai'
                    setState(() {
                      widget.orderDetail.status = 'Selesai';
                    });
                  },
                  child: Text('Selesai'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

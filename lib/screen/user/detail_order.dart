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

class OrderDetailPage extends StatefulWidget {
  final OrderDetail orderDetail;

  OrderDetailPage({required this.orderDetail});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Cancel'),
                          content: const Text('Yakin ingin membatalkan order?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  widget.orderDetail.status = 'Cancel';
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {
                      widget.orderDetail.status = 'Cancel';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 238, 114, 105), // Set the background color to red
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

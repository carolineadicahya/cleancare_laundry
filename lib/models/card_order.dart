import 'package:flutter/material.dart';

enum OrderStatus { DITERIMA, DALAM_PENGERJAAN, SELESAI, CANCEL }

class OrderCard extends StatelessWidget {
  OrderCard({
    required this.id,
    required this.email,
    required this.items,
    required this.orderDate,
    required this.status,
    required this.onDetail,
  });

  final String id;
  final String email;
  final List<Map<String, dynamic>> items;
  final DateTime orderDate;
  final OrderStatus status;
  final Function onDetail;

  @override
  Widget build(BuildContext context) {
    String statusText = getStatusText(status);

    return InkWell(
      onTap: () => onDetail(id), // Pass the id to the onDetail function
      child: Container(
        margin: EdgeInsets.all(6.0),
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Text('$email'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Diterima: ${orderDate.toString()}'),
                Text('Status: $statusText',
                    style: TextStyle(color: getStatusColor(status))),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () =>
                  onDetail(id), // Pass the id to the onDetail function
              child: Text('Detail'),
            ),
          ),
        ),
      ),
    );
  }

  String getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.DITERIMA:
        return 'Pesanan Diterima';
      case OrderStatus.DALAM_PENGERJAAN:
        return 'Dalam Pengerjaan';
      case OrderStatus.SELESAI:
        return 'Pesanan Selesai';
      case OrderStatus.CANCEL:
        return 'Cancel';
    }
  }

  Color getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.DITERIMA:
        return Colors.green;
      case OrderStatus.DALAM_PENGERJAAN:
        return Colors.orange;
      case OrderStatus.SELESAI:
        return Colors.green;
      case OrderStatus.CANCEL:
        return Colors.red;
    }
  }
}

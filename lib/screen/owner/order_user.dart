import 'package:flutter/material.dart';

class OrderUser extends StatefulWidget {
  const OrderUser({super.key});

  @override
  _OrderUserState createState() => _OrderUserState();
}

class _OrderUserState extends State<OrderUser> {
  // Contoh data riwayat pembelian
  List<Map<String, dynamic>> purchaseHistory = [
    {
      'waktu': '2023-10-18 14:30:00',
      'diterima': '2023-10-18 15:00:00',
      'detail': 'Cuci baju',
      'status': 'Sukses', // Tambahkan status pembelian
    },
    {
      'waktu': '2023-10-17 10:15:00',
      'diterima': '2023-10-17 11:00:00',
      'detail': 'Cuci selimut',
      'status': 'Cancel', // Tambahkan status pembelian
    },
    // Tambahkan data riwayat lainnya di sini
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Laundry'),
      ),
      body: ListView.builder(
        itemCount: purchaseHistory.length,
        itemBuilder: (context, index) {
          final history = purchaseHistory[index];
          final isCancelled = history['status'] == 'Cancel';
          final textColor = isCancelled ? Colors.red : Colors.green;

          return Card(
            child: ListTile(
              title: Text('Waktu: ${history['waktu']}'),
              subtitle: Text('Diterima: ${history['diterima']}'),
              trailing: Text(
                'Detail: ${history['detail']}',
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

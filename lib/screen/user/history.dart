import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
        title: const Text('Riwayat Pembelian Laundry'),
        centerTitle: true,
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

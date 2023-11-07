import 'package:CleanCare/screen/owner/detail_order_user(admin).dart';
import 'package:flutter/material.dart';

class OrderUser extends StatefulWidget {
  const OrderUser({Key? key});

  @override
  _OrderUserState createState() => _OrderUserState();
}

class _OrderUserState extends State<OrderUser> {
  List<Map<String, dynamic>> purchaseHistory = [
    {
      'waktu': '2023-10-18 14:30:00',
      'diterima': '2023-10-18 15:00:00',
      'detail': 'Cuci baju',
      'status': 'Sukses',
    },
    {
      'waktu': '2023-10-17 10:15:00',
      'diterima': '2023-10-17 11:00:00',
      'detail': 'Cuci selimut',
      'status': 'Cancel',
    },
  ];
  // Tambahkan data riwayat lainnya di sini

  void changePurchaseStatus(int index, String newStatus) {
    setState(() {
      purchaseHistory[index]['status'] = newStatus;
    });
  }

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

          return GestureDetector(
            onTap: () {
              // Navigasi ke halaman detail order dengan memberikan data OrderDetail
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminOrderDetailPage(
                    orderDetail: OrderDetail(
                      userName:
                          'User Name', // Gantilah dengan nama user sesuai dengan data yang diinginkan
                      service: history['detail'],
                      servicePrice:
                          10.0, // Gantilah dengan harga layanan sesuai dengan data yang diinginkan
                      quantity:
                          1, // Gantilah dengan jumlah sesuai dengan data yang diinginkan
                      subtotal:
                          10.0, // Gantilah dengan subtotal sesuai dengan data yang diinginkan
                      estimatedCompletionDate: DateTime
                          .now(), // Gantilah dengan tanggal selesai sesuai dengan data yang diinginkan
                      status: history['status'],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: ListTile(
                  title: Text('Waktu: ${history['waktu']}'),
                  subtitle: Text('Diterima: ${history['diterima']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Detail: ${history['detail']}',
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Mengubah status pembelian menjadi 'Sukses'
                              changePurchaseStatus(index, 'Sukses');
                            },
                            child: Text('Sukses'),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              // Mengubah status pembelian menjadi 'Cancel'
                              changePurchaseStatus(index, 'Cancel');
                            },
                            child: Text('Cancel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 238,
                                  114, 105), // Set the background color to red
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

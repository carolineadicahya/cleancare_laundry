import 'package:CleanCare/service/laundry_service.dart';
import 'package:CleanCare/service/notifikasi_service.dart';
import 'package:CleanCare/service/order_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final LaundryService laundryService = LaundryService();
  final OrderService orderService = OrderService();
  NotifikasiService notifikasiService = NotifikasiService();
  List<Map<String, dynamic>> item = [];
  int total = 0;

  @override
  void initState() {
    super.initState();

    // Fetch laundry items data
    laundryService.getData().listen((querySnapshot) {
      setState(() {
        item = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'price': doc['price'],
            'quantity': 0,
          };
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paket Laundry'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: laundryService.getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var items = snapshot.data?.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      var data = item[index];
                      return Container(
                        child: ListTile(
                          title: Text(
                            "${data['name']}",
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                            'Rp.${(data['price'])}',
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  var dataQuantity = item[index]['quantity'];
                                  setState(() {
                                    if (dataQuantity > 0) {
                                      item[index]['quantity'] = --dataQuantity;
                                      total -= int.parse(item[index]['price']);
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder()),
                                child: const Icon(
                                  Icons.remove_rounded,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Text(data['quantity'].toString(),
                                  style: const TextStyle(fontSize: 18.0)),
                              const SizedBox(width: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  var dataQuantity = item[index]['quantity'];
                                  setState(() {
                                    item[index]['quantity'] = ++dataQuantity;
                                    total += int.parse(item[index]['price']);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder()),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Text("Total Harga Rp. ${total.toString()}"),
            ElevatedButton(
              onPressed: () async {
                // Check if there are selected items before creating an order
                if (total > 0) {
                  await createNewOrder();
                } else {
                  // Show error dialog for empty selectedItems
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Terjadi Kesalahan'),
                        content: Text('Silahkan Pilih Paket Laundry!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Order'),
            ),
            Text(
              'Catatan:\n'
              '1. Order Layanan hanya tersedia 2 hari, jika lebih harus order ulang.\n'
              '2. Pengambilan cucian harus disertai nota.\n'
              '3. Rusak atau hilang akan dikenakan potongan biaya / diskon.\n'
              '4. Cucian yang tidak diambil dalam 30 hari, bukan tanggung jawab kami.\n'
              '5. Kami tidak bertanggung jawab terhadap barang berharga yang tertinggal bersama cucian.\n'
              '6. Kami tidak bertanggung jawab apabila susut / mengecil / luntur dari sifat-sifat bahan.',
              style: TextStyle(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create a new order based on selected items
  Future<void> createNewOrder() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Filter items with quantity greater than 0
    var selectedItems = item.where((data) => data['quantity'] > 0).toList();

    // Create a new order with selected items
    var orderData = {
      'email': user?.email,
      'items': selectedItems.map((data) {
        var itemName = data['name'];
        var quantity = data['quantity'];
        var total = int.parse(data['price']) * quantity;

        return {
          'nama paket': itemName,
          'quantity': quantity,
          'total': total,
        };
      }).toList(),
      'tanggal order': DateTime.now(),
    };

    // Call the OrderService to add the order to Firestore
    var orderId = await orderService.addOrder(orderData);
    notifikasiService.sendOrderNotification(user?.email ?? "");

    // Show a success dialog with the order ID
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Order berhasil
        return AlertDialog(
          title: Text('Order Berhasil'),
          content: Text('Ordermu telah terkirim dengan ID Order: $orderId'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

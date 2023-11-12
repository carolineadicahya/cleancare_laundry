import 'package:CleanCare/service/laundry_service.dart';
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
  List<Map<String, dynamic>> item = [];

  @override
  void initState() {
    super.initState();

    laundryService.getData().listen((querySnapshot) {
      setState(() {
        item = querySnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': doc['name'],
            'price': doc['price'],
            'quantity': 0,
            'totalPrice': 0.0,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              StreamBuilder(
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
                            'Rp${(data['price'])}',
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  updateQuantity(index, -1);
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
                                  updateQuantity(index, 1);
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
              ElevatedButton(
                onPressed: () async {
                  // Order button clicked, create a new order
                  await createNewOrder();
                },
                child: Text('Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to update the quantity and total price for an item
  void updateQuantity(int index, int change) {
    setState(() {
      var data = item[index];
      var newQuantity = data['quantity'] + change;
      if (newQuantity >= 0) {
        item[index]['quantity'] = newQuantity;
        item[index]['totalPrice'] = data['price'] * newQuantity;
      }
    });
  }

  // Function to create a new order based on selected items
  Future<void> createNewOrder() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Filter items with quantity greater than 0
    var selectedItems = item.where((data) => data['quantity'] > 0).toList();

    // Create a new order with selected items
    var orderData = {
      'userName': user?.email,
      'items': selectedItems.map((data) {
        var itemName = data['name'];
        var quantity = data['quantity'];
        var totalPrice = data['price'] * quantity;

        return {
          'itemName': itemName,
          'quantity': quantity,
          'totalPrice': totalPrice,
        };
      }).toList(),
      'orderDate': DateTime.now(),
    };

    print(orderData);

    // Call the OrderService to add the order to Firestore
    // var orderId = await orderService.addOrder(orderData);

    // Show a success dialog with the order ID
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Berhasil'),
          // content: Text('Ordermu telah terkirim dengan Order ID: $orderId'),
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

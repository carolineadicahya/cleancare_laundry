import 'package:CleanCare/service/laundry_service.dart';
import 'package:flutter/material.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final LaundryService laundryService = LaundryService();
  int quantity = 0; // Variabel untuk jumlah quantity
  List<Map<String, dynamic>> item = [];

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
                  if (items != null && items.isNotEmpty) {
                    item = items.map((item) {
                      return {
                        'name': item['name'],
                        'price': item['price'],
                        'quantity': quantity,
                      };
                    }).toList();
                    print(item);
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
                              // 'Rp${(data['price'] * quantity)}',
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
                                    print(dataQuantity);
                                    setState(() {
                                      if (dataQuantity > 0) {
                                        item[index]['quantity'] =
                                            --dataQuantity;
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
                                Text(quantity.toString(),
                                    style: const TextStyle(fontSize: 18.0)),
                                const SizedBox(width: 16.0),
                                ElevatedButton(
                                  onPressed: () {
                                    var dataQuantity = item[index]['quantity'];
                                    print(dataQuantity);
                                    setState(() {
                                      item[index]['quantity'] = ++dataQuantity;
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
                  }

                  return Center(child: Text('Tidak Ada Paket Laundry.'));
                },
              ),
              ElevatedButton(
                onPressed: () {
                  print(item);
                },
                child: Text('Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PaketIndex extends StatefulWidget {
  const PaketIndex({super.key});

  @override
  State<PaketIndex> createState() => _PaketIndex();
}

class _PaketIndex extends State<PaketIndex> {
  List<Map<String, dynamic>> package = [
    {'name': 'Wash & Fold', 'price': 10000, 'quantity': 0},
    {'name': 'Ironing', 'price': 5000, 'quantity': 0},
    {'name': 'Fragrance', 'price': 2000, 'quantity': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paket Laundry'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  print(package);
                },
                child: Text('Simpan')),
            ListView.builder(
              shrinkWrap: true,
              itemCount: package.length,
              itemBuilder: ((context, index) {
                var item = package[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Text(item['name']),
                      Container(
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () {
                                  var data = package[index]['quantity'];
                                  print(data);
                                  setState(() {
                                    if (data > 0) {
                                      package[index]['quantity'] = --data;
                                    }
                                  });
                                },
                                child: Text("-")),
                            Text(item['quantity'].toString()),
                            TextButton(
                                onPressed: () {
                                  var data = package[index]['quantity'];
                                  print(data);
                                  setState(() {
                                    package[index]['quantity'] = ++data;
                                  });
                                },
                                child: Text("+"))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

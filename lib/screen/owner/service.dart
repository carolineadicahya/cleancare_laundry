import 'package:flutter/material.dart';

class LaundryServicePage extends StatefulWidget {
  @override
  _LaundryServicePageState createState() => _LaundryServicePageState();
}

class _LaundryServicePageState extends State<LaundryServicePage> {
  List<Map<String, dynamic>> services = [];
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController servicePriceController = TextEditingController();

  void addService() {
    final name = serviceNameController.text;
    final price = servicePriceController.text;

    if (name.isNotEmpty && price.isNotEmpty) {
      services.add({
        'name': name,
        'price': price,
      });

      serviceNameController.clear();
      servicePriceController.clear();

      setState(() {}); // Update UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laundry Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: serviceNameController,
              decoration: InputDecoration(labelText: 'Layanan'),
            ),
            TextField(
              controller: servicePriceController,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addService,
              child: Text('Tambah Layanan'),
            ),
            SizedBox(height: 16),
            Text('Daftar Layanan:'),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return ListTile(
                    title: Text(service['name']),
                    subtitle: Text('Harga: ${service['price']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:CleanCare/service/laundry_service.dart';
import 'package:flutter/material.dart';

class LaundryServicePage extends StatefulWidget {
  @override
  _LaundryServicePageState createState() => _LaundryServicePageState();
}

class _LaundryServicePageState extends State<LaundryServicePage> {
  final LaundryService laundryService = LaundryService();
  List<Map<String, dynamic>> services = [];
  TextEditingController serviceNameController = TextEditingController();
  TextEditingController servicePriceController = TextEditingController();
  int editedServiceIndex = -1; // Untuk melacak item yang sedang diedit
  bool isEditing = false;
  String? idLayanan = null;

  void addService() async {
    final name = serviceNameController.text;
    final price = servicePriceController.text;

    if (name.isNotEmpty && price.isNotEmpty) {
      if (isEditing) {
        // Jika sedang dalam mode pengeditan, perbarui item yang dipilih
        final service = services[editedServiceIndex];
        final id = service['id'];

        // Perbarui data di Firestore
        await laundryService.updateLayanan(id, {
          'name': name,
          'price': price,
        });

        isEditing = false; // Keluar dari mode pengeditan
      } else {
        // Jika tidak dalam mode pengeditan, tambahkan item baru ke Firestore
        await laundryService.addLayanan({
          'name': name,
          'price': price,
        });

        // Tambahkan item ke daftar lokal
        services.add({
          'name': name,
          'price': price,
        });
      }

      serviceNameController.clear();
      servicePriceController.clear();

      setState(() {}); // Update UI
    }
  }

  void editService() async {
    final name = serviceNameController.text;
    final price = servicePriceController.text;

    if (name.isNotEmpty && price.isNotEmpty) {
      // Perbarui data di Firebase
      await laundryService.updateLayanan(idLayanan.toString(), {
        'name': name,
        'price': price,
      });

      setState(() {
        serviceNameController.clear();
        servicePriceController.clear();
        isEditing = false;
      });
    }
  }

  void deleteService(int index) async {
    final service = services[index];
    final id = service['id'];
    await laundryService.deleteLayanan(id);
    services.removeAt(index);
    isEditing =
        false; // Keluar dari mode pengeditan (jika dalam mode pengeditan)
    setState(() {}); // Update UI
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
              onPressed: () => isEditing ? editService() : addService(),
              child: Text(isEditing ? 'Perbarui Layanan' : 'Tambah Layanan'),
            ),
            SizedBox(height: 16),
            Text('Daftar Layanan:'),
            Expanded(
              child: StreamBuilder(
                stream: laundryService.getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var items = snapshot.data?.docs;
                    if (items!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var item = items[index];
                          return ListTile(
                              title: Text("${item['name']}"),
                              subtitle: Text('Harga: ${item['price']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      var id = items[index]!.id.toString();
                                      laundryService.deleteLayanan(id);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      setState(() {
                                        isEditing = true;
                                        idLayanan = items[index]!.id.toString();
                                        serviceNameController.text =
                                            items[index]!['name'];
                                        servicePriceController.text =
                                            items[index]!['price'].toString();
                                      });
                                    },
                                  )
                                ],
                              ));
                        },
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../utils/constants.dart';

// class AddLaundry extends StatefulWidget {
//   const AddLaundry({super.key});

//   @override
//   _AddLaundryState createState() => _AddLaundryState();
// }

// class _AddLaundryState extends State<AddLaundry> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   final Map<String, dynamic> selectedOutlet = {
//     'name': 'Laundry CleanCare',
//     'description':
//         'Laundry Express tempat terbaik  mencuci pakaian Anda dengan cepat dan efisien.',
//     'address': 'Jalan Martadinata !!',
//     'openingHours': 'Mon-Sun: 8 AM - 9 PM',
//     'contact': 'Phone: (123) 456-7890',
//   };

//   List<Map<String, dynamic>> package = [
//     {'name': 'Wash & Fold', 'price': 10000, 'quantity': 0},
//     // {'name': 'Ironing', 'price': 5000, 'quantity': 0},
//     // {'name': 'Fragrance', 'price': 2000, 'quantity': 0},
//     // {'name': 'Complete Wash', 'price': 13000, 'quantity': 0},
//     // {'name': 'Express Wash', 'price': 15000, 'quantity': 0},
//     // {'name': 'Wash Only', 'price': 7000, 'quantity': 0},
//     // {'name': 'Ironing with Fragrance', 'price': 7000, 'quantity': 0},
//     // {'name': 'Ironing without Fragrance', 'price': 5000, 'quantity': 0},
//     // {'name': 'Fragrance (Soft)', 'price': 5000, 'quantity': 0},
//     // {'name': 'Fragrance (Flowerist)', 'price': 7000, 'quantity': 0},
//     // {'name': 'Fragrance (Woody)', 'price': 5000, 'quantity': 0},
//   ];

//   Future<void> _takeOrder() async {
//     List<Map<String, dynamic>> data =
//         package.where((i) => i['quantity'] > 0).toList();

//     print(data);
//     // for (var i in ) {
//     //   if (i['quantity'] > 0) {
//     //     dataPackages.add({
//     //       'name': i['name'],
//     //       'price': i['price'],
//     //       'quantity': i['quantity']
//     //     });
//     //   }
//     // }

//     // var dataPackages = (selectedOutlet['packages'] as List);

//     // print(dataPackages);

//     // for (var i in selectedOutlet['packages']) {
//     //   if (i['quantity'] > 0) {
//     //     packages.add(i);
//     //   }
//     // }

//     // Map<String, dynamic> body = {
//     //   "outletName": selectedOutlet['name'],
//     //   "orderDate": FieldValue.serverTimestamp(),
//     //   "packages": selectedOutlet['packages'],
//     // };

//     // try {
//     //   // Membuat dokumen order baru dengan auto-incremented ID
//     //   final orderCollection = _firestore.collection('order_db');
//     //   final orderDocument = await orderCollection.add({
//     //     'outletName': selectedOutlet['name'],
//     //     'orderDate': FieldValue.serverTimestamp(),
//     //     'packages': (selectedOutlet['packages'] as List<Map<String, dynamic>>)
//     //         .where((Map<String, dynamic> package) => package['quantity'] > 0)
//     //         .toList(),
//     //   });

//     //   // baiknya ..

//     //   // Menyimpan paket yang dipesan dalam sub-koleksi "packages"
//     //   final packagesCollection = orderDocument.collection('packages');
//     //   final orderedPackages =
//     //       (selectedOutlet['packages'] as List<Map<String, dynamic>>)
//     //           .where((Map<String, dynamic> package) => package['quantity'] > 0)
//     //           .toList();

//     //   for (var package in orderedPackages) {
//     //     await packagesCollection.add({
//     //       'name': package['name'],
//     //       'price': package['price'],
//     //       'quantity': package['quantity'],
//     //     });
//     //   }

//     //   showDialog(
//     //     context: context,
//     //     builder: (BuildContext context) {
//     //       return AlertDialog(
//     //         title: Text('Order Berhasil Ditambahkan'),
//     //         content: Text('ID Order: ${orderDocument.id}'),
//     //         actions: <Widget>[
//     //           TextButton(
//     //             onPressed: () {
//     //               Navigator.of(context).pop();
//     //             },
//     //             child: Text('Tutup'),
//     //           ),
//     //         ],
//     //       );
//     //     },
//     //   );
//     // } catch (error) {
//     //   // Menampilkan popup dialog saat terjadi kesalahan
//     //   showDialog(
//     //     context: context,
//     //     builder: (BuildContext context) {
//     //       return AlertDialog(
//     //         title: Text('Error'),
//     //         content: Text('Terjadi kesalahan saat menambahkan order: $error'),
//     //         actions: <Widget>[
//     //           TextButton(
//     //             onPressed: () {
//     //               Navigator.of(context).pop();
//     //             },
//     //             child: Text('Tutup'),
//     //           ),
//     //         ],
//     //       );
//     //     },
//     //   );
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Constants.primaryColor,
//       body: Container(
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Positioned(
//               right: 0.0,
//               top: 10.0,
//               child: Opacity(
//                 opacity: 0.3,
//                 child: Image.asset(
//                     "assets/images/washing_machine_illustration.png"),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       height: kToolbarHeight,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                     ),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "Laundry Info",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge
//                                 ?.copyWith(
//                                   color: Colors.white,
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                     ),
//                     // Display selected outlet's information
//                     OutletBox(
//                       name: selectedOutlet['name'] ?? '',
//                       description: selectedOutlet['description'] ?? '',
//                       address: selectedOutlet['address'] ?? '',
//                       openingHours: selectedOutlet['openingHours'] ?? '',
//                       contact: selectedOutlet['contact'] ?? '',
//                       packages: package,
//                       takeOrder:
//                           _takeOrder, // Mengirim fungsi _takeOrder ke OutletBox
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OutletBox extends StatefulWidget {
//   final String name;
//   final String description;
//   final String address;
//   final String openingHours;
//   final String contact;
//   final List<Map<String, dynamic>> packages;
//   final VoidCallback
//       takeOrder; // Fungsi _takeOrder yang diteruskan dari _AddLaundryState

//   const OutletBox({
//     super.key,
//     required this.name,
//     required this.description,
//     required this.address,
//     required this.openingHours,
//     required this.contact,
//     required this.packages,
//     required this.takeOrder, // Tambahkan takeOrder ke konstruktor
//   });

//   @override
//   _OutletBoxState createState() => _OutletBoxState();
// }

// class _OutletBoxState extends State<OutletBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.name,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18.0,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             widget.description,
//             style: const TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             widget.address,
//             style: const TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             widget.openingHours,
//             style: const TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             widget.contact,
//             style: const TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           const Text(
//             'Packages:',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16.0,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           // Display laundry packages
//           Column(
//             children: widget.packages.map((package) {
//               return PackageWidget(
//                   package: package,
//                   onChangeIncrement: (value) {
//                     // widget.packages['quantity'] = value;
//                     print(value);
//                   });
//             }).toList(),
//           ),
//           ElevatedButton(
//             onPressed: widget
//                 .takeOrder, // Menggunakan takeOrder yang diteruskan dari _AddLaundryState
//             child: const Text('Order'),
//           )
//         ],
//       ),
//     );
//   }
// }

// class PackageWidget extends StatefulWidget {
//   final Map<String, dynamic> package;
//   final Function onChangeIncrement;
//   const PackageWidget({
//     super.key,
//     required this.package,
//     required this.onChangeIncrement(val),
//   });

//   @override
//   _PackageWidgetState createState() => _PackageWidgetState();
// }

// class _PackageWidgetState extends State<PackageWidget> {
//   int quantity = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//     Text(
//       "${widget.package['name']}",
//       style: const TextStyle(
//         fontSize: 14.0,
//       ),
//     ),
//     Text(
//       'Rp${(widget.package['price'] * quantity).toStringAsFixed(0)}',
//       style: const TextStyle(
//         fontSize: 14.0,
//       ),
//     ),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     ElevatedButton(
//       onPressed: () {
//         setState(() {
//           // yang di cari adalah list package di atas
//           if (quantity > 0) {
//             quantity--;
//           }
//           // kemudian set quantitiyny berdasarkan object yang ada di variable pakacke
//         });
//       },
//       style: ElevatedButton.styleFrom(shape: const CircleBorder()),
//       child: const Icon(
//         Icons.remove_rounded,
//         size: 24,
//       ),
//     ),
//     const SizedBox(width: 16.0),
//     Text(quantity.toString(), style: const TextStyle(fontSize: 18.0)),
//     const SizedBox(width: 16.0),
//     ElevatedButton(
//       onPressed: () {
//         setState(() {
//           quantity++;
//         });
//         widget.onChangeIncrement(quantity);
//       },
//       style: ElevatedButton.styleFrom(shape: const CircleBorder()),
//       child: const Icon(
//         Icons.add_rounded,
//         size: 24,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:CleanCare/service/laundry_service.dart';
import 'package:flutter/material.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrder createState() => _AddOrder();
}

class _AddOrder extends State<AddOrder> {
  final LaundryService laundryService = LaundryService();
  int _selectedIndex = 0; // Variabel untuk index
  int quantity = 0; // Variabel untuk jumlah quantity

  List<Map<String, dynamic>> item = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

                  if (items!.isNotEmpty) {
                    // Menggabungkan data dari snapshot ke dalam variabel item
                    item = items.map((item) {
                      return {
                        'name': item['name'],
                        'price': item['price'],
                        'quantity':
                            quantity, // Mungkin perlu diperbarui sesuai kebutuhan.
                      };
                    }).toList();
                    print(item);
                    return Column(
                      children: items.map((item) {
                        return ListTile(
                          title: Text(
                            "${item['name']}",
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          subtitle: Text(
                            'Rp${(item['price'] * quantity)}',
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (quantity > 0) {
                                      quantity--;
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
                                  setState(() {
                                    quantity++;
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
                        );
                      }).toList(),
                    );
                  }

                  return Center(child: Text('Tidak Ada Paket Laundry.'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

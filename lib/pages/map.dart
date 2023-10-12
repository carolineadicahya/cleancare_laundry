// import 'package:flutter/material.dart';
// import '../utils/constants.dart';
// import 'package:flutter_google_maps/flutter_google_maps.dart';

// class LaundryPage extends StatelessWidget {
//   final Map<String, dynamic> selectedOutlet;

//   LaundryPage({required this.selectedOutlet});

//   @override
//   Widget build(BuildContext context) {
//     final LatLng center = LatLng(-6.2088, 106.8456); // Ganti dengan koordinat lokasi laundry Anda

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
//                   "assets/images/washing_machine_illustration.png",
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: kToolbarHeight,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(
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
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     // Display selected outlet's information
//                     OutletBox(
//                       name: selectedOutlet['name'] ?? '',
//                       description: selectedOutlet['description'] ?? '',
//                       address: selectedOutlet['address'] ?? '',
//                       openingHours: selectedOutlet['openingHours'] ?? '',
//                       contact: selectedOutlet['contact'] ?? '',
//                       packages: selectedOutlet['packages'] ?? [],
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     // Add Google Maps here
//                     Container(
//                       height: 300, // Sesuaikan dengan tinggi yang Anda inginkan
//                       child: GoogleMap(
//                         initialPosition: GeoCoord(center.latitude, center.longitude),
//                         mapType: MapType.roadmap, // Ganti dengan tipe peta yang Anda inginkan
//                         interactive: true,
//                         markers: {
//                           Marker(GeoCoord(center.latitude, center.longitude)),
//                         },
//                         mobilePreferences: MobileMapPreferences(
//                           zoomControlsEnabled: false,
//                           myLocationButtonEnabled: false,
//                         ),
//                         webPreferences: WebMapPreferences(
//                           fullscreenControl: true,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     // Add a form here to input laundry details, such as type, quantity, price, etc.
//                     // You can add form fields and input widgets here.
//                     // For example, TextFormField for type, quantity, etc.
//                     // SizedBox(height: 10.0),
//                     // Add a button here to submit the laundry order
//                     // RaisedButton(
//                     //   onPressed: () {
//                     //     // Handle order submission
//                     //   },
//                     //   child: Text("Submit Order"),
//                     // ),
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

//   OutletBox({
//     required this.name,
//     required this.description,
//     required this.address,
//     required this.openingHours,
//     required this.contact,
//     required this.packages,
//   });

//   @override
//   _OutletBoxState createState() => _OutletBoxState();
// }

// class _OutletBoxState extends State<OutletBox> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16.0),
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.name,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18.0,
//             ),
//           ),
//           SizedBox(height: 8.0),
//           Text(
//             widget.description,
//             style: TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(height: 8.0),
//           Text(
//             widget.address,
//             style: TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(height: 8.0),
//           Text(
//             widget.openingHours,
//             style: TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(height: 8.0),
//           Text(
//             widget.contact,
//             style: TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           SizedBox(height: 16.0),
//           Text(
//             'Packages:',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16.0,
//             ),
//           ),
//           SizedBox(height: 8.0),
//           // Display laundry packages
//           Column(
//             children: widget.packages.map((package) {
//               return PackageWidget(package: package);
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PackageWidget extends StatefulWidget {
//   final Map<String, dynamic> package;

//   PackageWidget({required this.package});

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
//             Text(
//               widget.package['name'] ?? '',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//             Text(
//               '\$${(widget.package['price'] * quantity).toStringAsFixed(2)}',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   if (quantity > 0) {
//                     quantity--;
//                   }
//                 });
//               },
//               child: Text('-'),
//             ),
//             SizedBox(width: 16.0),
//             Text(quantity.toString(), style: TextStyle(fontSize: 18.0)),
//             SizedBox(width: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   quantity++;
//                 });
//               },
//               child: Text('+'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
// import 'package:CleanCare/pages/setting.dart'; // Import halaman pengaturan (ProfilePage)
import '../utils/constants.dart';

class AddLaundry extends StatefulWidget {
  const AddLaundry({Key? key}) : super(key: key);

  @override
  _AddLaundryState createState() => _AddLaundryState();
}

// Define the selected outlet
class _AddLaundryState extends State<AddLaundry> {
  final Map<String, dynamic> selectedOutlet = {
    'name': 'Laundry CleanCare',
    'description':
        'Laundry Express tempat terbaik  mencuci pakaian Anda dengan cepat dan efisien.',
    'address': 'Jalan Martadinata !!',
    'openingHours': 'Mon-Sun: 8 AM - 9 PM',
    'contact': 'Phone: (123) 456-7890',
    'packages': [
      {'name': 'Wash & Fold', 'price': 10000, 'quantity': 0},
      {'name': 'Ironing', 'price': 5000, 'quantity': 0},
      {'name': 'Fragrance', 'price': 2000, 'quantity': 0},
      {'name': 'Complete Wash', 'price': 13000, 'quantity': 0},
      {'name': 'Express Wash', 'price': 15000, 'quantity': 0},
      {'name': 'Wash Only', 'price': 7000, 'quantity': 0},
      {'name': 'Ironing with Fragrance', 'price': 7000, 'quantity': 0},
      {'name': 'Ironing without Fragrance', 'price': 5000, 'quantity': 0},
      {'name': 'Fragrance (Soft)', 'price': 5000, 'quantity': 0},
      {'name': 'Fragrance (Flowerist)', 'price': 7000, 'quantity': 0},
      {'name': 'Fragrance (Woody)', 'price': 5000, 'quantity': 0},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0.0,
              top: 10.0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/images/washing_machine_illustration.png",
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: kToolbarHeight,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Laundry Info",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Display selected outlet's information
                    OutletBox(
                      name: selectedOutlet['name'] ?? '',
                      description: selectedOutlet['description'] ?? '',
                      address: selectedOutlet['address'] ?? '',
                      openingHours: selectedOutlet['openingHours'] ?? '',
                      contact: selectedOutlet['contact'] ?? '',
                      packages: selectedOutlet['packages'] ?? [],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutletBox extends StatefulWidget {
  final String name;
  final String description;
  final String address;
  final String openingHours;
  final String contact;
  final List<Map<String, dynamic>> packages;

  const OutletBox({
    super.key,
    required this.name,
    required this.description,
    required this.address,
    required this.openingHours,
    required this.contact,
    required this.packages,
  });

  @override
  _OutletBoxState createState() => _OutletBoxState();
}

class _OutletBoxState extends State<OutletBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.description,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.address,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.openingHours,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.contact,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Packages:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 8.0),
          // Display laundry packages
          Column(
            children: widget.packages.map((package) {
              return PackageWidget(package: package);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class PackageWidget extends StatefulWidget {
  final Map<String, dynamic> package;

  const PackageWidget({super.key, required this.package});

  @override
  _PackageWidgetState createState() => _PackageWidgetState();
}

class _PackageWidgetState extends State<PackageWidget> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.package['name'] ?? '',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
            Text(
              'Rp${(widget.package['price'] * quantity).toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Align buttons at the center
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (quantity > 0) {
                    quantity--;
                  }
                });
              },
              child: const Text('-'),
            ),
            const SizedBox(
                width: 16.0), // Add some space between buttons and quantity
            Text(quantity.toString(), style: const TextStyle(fontSize: 18.0)),
            const SizedBox(
                width: 16.0), // Add some space between quantity and buttons
            ElevatedButton(
              onPressed: () {
                setState(() {
                  quantity++;
                });
              },
              child: const Text('+'),
            ),
          ],
        ),
      ],
    );
  }
}

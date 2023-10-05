import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AddLaundry extends StatefulWidget {
  @override
  _AddLaundryState createState() => _AddLaundryState();
}

class _AddLaundryState extends State<AddLaundry> {
  // List of laundry outlets
  List<Map<String, String>> laundryOutlets = [
    {
      'name': 'Laundry Outlet 1',
      'address': '123 Main St',
      'openingHours': 'Mon-Fri: 8 AM - 6 PM',
    },
    {
      'name': 'Laundry Outlet 2',
      'address': '456 Elm St',
      'openingHours': 'Mon-Fri: 9 AM - 7 PM',
    },
    {
      'name': 'Laundry Outlet 3',
      'address': '789 Oak St',
      'openingHours': 'Mon-Fri: 7 AM - 5 PM',
    },
    {
      'name': 'Laundry Outlet 4',
      'address': '101 Pine St',
      'openingHours': 'Mon-Fri: 10 AM - 8 PM',
    },
    {
      'name': 'Laundry Outlet 5',
      'address': '202 Cedar St',
      'openingHours': 'Mon-Fri: 9 AM - 5 PM',
    },
  ];

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
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kToolbarHeight,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Outlets",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          // Add a widget here to select the outlet or laundry location
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    // Display information about laundry outlets in a ListView
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: laundryOutlets.length,
                      itemBuilder: (context, index) {
                        final outlet = laundryOutlets[index];
                        return OutletBox(
                          name: outlet['name'] ?? '',
                          address: outlet['address'] ?? '',
                          openingHours: outlet['openingHours'] ?? '',
                        );
                      },
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    // Add a form here to input laundry details, such as type, quantity, price, etc.
                    SizedBox(height: 10.0),
                    // Add a button here to submit the laundry order
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

class OutletBox extends StatelessWidget {
  final String name;
  final String address;
  final String openingHours;

  OutletBox({required this.name, required this.address, required this.openingHours});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            address,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            openingHours,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:CleanCare/pages/map.dart';
import 'package:CleanCare/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:CleanCare/pages/add.dart';
import 'package:CleanCare/pages/setting.dart'; // Import halaman pengaturan (ProfilePage)
import '../utils/constants.dart';
import '../widgets/latest_orders.dart';
import '../widgets/location_slider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Track active index
  int activeIndex = 0;

  String fullName = "Pelanggan"; // Inisialisasi nama default

  @override
  void initState() {
    super.initState();
    loadUserName(); // Memuat nama pengguna saat widget diinisialisasi
  }

  Future<void> loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Ambil data nama dari Firestore
      final userData = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        final userName = userData['Full Name'];
        setState(() {
          fullName = userName ?? "Pelanggan";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        items: [
          Icon(
            Icons.home,
            size: 30.0,
            color: activeIndex == 0 ? Colors.white : const Color(0xFFC8C9CB),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                ),
              );
            },
            child: Icon(
              Icons.pin_drop_rounded,
              size: 30.0,
              color: activeIndex == 1 ? Colors.white : const Color(0xFFC8C9CB),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddLaundry(),
                ),
              );
            },
            child: Icon(
              Icons.add,
              size: 30.0,
              color: activeIndex == 2 ? Colors.white : const Color(0xFFC8C9CB),
            ),
          ),
          Icon(
            Icons.history_rounded,
            size: 30.0,
            color: activeIndex == 3 ? Colors.white : const Color(0xFFC8C9CB),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
            child: Icon(
              Icons.person_pin_rounded,
              size: 30.0,
              color: activeIndex == 4 ? Colors.white : const Color(0xFFC8C9CB),
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            activeIndex = index;
          });
        },
      ),
      backgroundColor: Constants.primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0.0,
            top: -20.0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/images/washing_machine_illustration.png",
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                );
                              },
                              child: Icon(
                                IconData(0xf88b, fontFamily: 'MaterialIcons'),
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Welcome Back,\n",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  TextSpan(
                                    text: "$fullName!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/images/user.png",
                              height: 80,
                              width: 80,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 200.0,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Constants.scaffoldBackgroundColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: Text(
                            "New Locations",
                            style: TextStyle(
                              color: Color.fromRGBO(19, 22, 33, 1),
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7.0),
                        SizedBox(
                          height: ScreenUtil().setHeight(100.0),
                          child: const Center(
                            child: LocationSlider(),
                          ),
                        ),
                        LatestOrders(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

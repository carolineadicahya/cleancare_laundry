import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:CleanCare/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:CleanCare/screen/user/create_acc.dart';
import 'package:CleanCare/screen/user/dashboard.dart';
import 'package:CleanCare/screen/user/home.dart';
import 'package:CleanCare/screen/user/login.dart';
import 'package:CleanCare/screen/user/single_order.dart';
import 'package:CleanCare/screen/user/layout.dart';
import 'package:CleanCare/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'CleanCare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Constants.scaffoldBackgroundColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          initialRoute: "/",
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Home();
        // return const LayoutPages();
      });
    case "/login":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Login();
      });
    case "/create-acc":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const CreateAccount();
      });
    case "/layout":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LayoutPages();
      });
    case "/dashboard":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Dashboard();
      });
    case "/single-order":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const SingleOrder();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Home();
      });
  }
}

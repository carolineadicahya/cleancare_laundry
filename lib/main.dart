import 'package:CleanCare/screen/owner/dashboard_admin.dart';
import 'package:CleanCare/screen/owner/layout_admin.dart';
import 'package:CleanCare/screen/owner/order_user(admin).dart';
import 'package:CleanCare/screen/reset_password.dart';
import 'package:CleanCare/screen/user/dashboard_user.dart';
import 'package:CleanCare/screen/user/ganti_email.dart';
import 'package:CleanCare/screen/user/history.dart';
import 'package:CleanCare/screen/user/layout_user.dart';
import 'package:CleanCare/screen/user/order_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:CleanCare/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:CleanCare/screen/page_awal.dart';
import 'package:CleanCare/screen/login.dart';
import 'package:CleanCare/utils/constants.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

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
            primaryColor: Colors.blue,
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
      });
    case "/login":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Login();
      });
    case "/reset":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const ResetPage();
      });
    case "/change-email":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const ChangeEmail();
      });
    case "/user":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LayoutPages();
      });
    case "/dashboard-user":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Dashboard();
      });
    case "/admin":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LayoutAdmin();
      });
    case "/dashboard-admin":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const DashboardAdmin();
      });
    case "/history-card":
      return MaterialPageRoute(builder: (BuildContext context) {
        return HistoryOrder();
      });
    case "/notif-order":
      return MaterialPageRoute(builder: (BuildContext context) {
        return OrderUser();
      });
    case "/notif-status":
      return MaterialPageRoute(builder: (BuildContext context) {
        return OrderPage();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Home();
      });
  }
}

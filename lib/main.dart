import 'package:CleanCare/screen/owner/layout_admin.dart';
import 'package:CleanCare/screen/user/layout_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:CleanCare/firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:CleanCare/screen/page_awal.dart';
import 'package:CleanCare/screen/login.dart';
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
        // return const Home();
        return const LayoutAdmin();
      });
    case "/login":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Login();
      });
    case "/user":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LayoutPages();
      });
    case "/admin":
      return MaterialPageRoute(builder: (BuildContext context) {
        return const LayoutAdmin();
      });
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return const Home();
      });
  }
}

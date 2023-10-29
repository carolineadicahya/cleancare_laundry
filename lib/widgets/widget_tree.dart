import 'package:flutter/material.dart';
import '../controller/auth.dart';
import 'package:CleanCare/screen/user/home.dart';
import 'package:CleanCare/screen/user/login.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const Login();
          }
        });
  }
}

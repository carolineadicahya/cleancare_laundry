// import 'package:CleanCare/screen/owner/navbar.dart';
import 'package:CleanCare/screen/owner/navbar.dart';
import 'package:CleanCare/screen/user/layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controller/auth.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/input_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> signIn() async {
    context.loaderOverlay.show();
    try {
      // ignore: unused_local_variable
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        // Panggil checkRole untuk memeriksa peran pengguna setelah login
        checkRole(context);
      } else {
        showErrorDialog(
            'Email belum diverifikasi. Silakan periksa email Anda.');
      }
    } on FirebaseAuthException catch (e) {
      context.loaderOverlay.hide();
      if (e.code == 'wrong-password') {
        showErrorDialog('Password yang Anda masukkan salah.');
      } else if (e.code == 'user-not-found') {
        showErrorDialog('Akun dengan email tersebut tidak ditemukan.');
      } else {
        showErrorDialog('Terjadi Kesalahan. Mohon Coba Lagi.');
      }
    }
  }

  void checkRole(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .get();

      DocumentSnapshot adminDoc = await FirebaseFirestore.instance
          .collection("admin")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        // User document exists, indicating a regular user.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LayoutPages()),
        );
      } else if (adminDoc.exists) {
        // Admin document exists, indicating an admin.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LayoutAdmin()),
        );
      } else {
        // Neither user nor admin document exists, handle as needed.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const LayoutPages()), // You may want to handle this case differently.
        );
      }
    } else {
      // User is not authenticated, so you may want to navigate to a login page.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayColor: Colors.black12,
        overlayWidget: const Center(
          child: SpinKitCircle(
            color: Colors.black,
            size: 50.0,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            child: Stack(
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Log In",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height,
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 180.0,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InputWidget(
                                  topLabel: "Email",
                                  controller: _controllerEmail,
                                  hintText: "Enter your email address",
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                InputWidget(
                                  topLabel: "Password",
                                  controller: _controllerPassword,
                                  obscureText: true,
                                  hintText: "Enter your password",
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final email = _controllerEmail.text;
                                    final newPassword =
                                        _controllerPassword.text;

                                    if (email.isNotEmpty) {
                                      try {
                                        await Auth()
                                            .resetPasswordAndSaveToFirestore(
                                          email,
                                          newPassword,
                                        );
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Reset Password'),
                                              content: const Text(
                                                  'An email to reset your password has been sent.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        showErrorDialog(
                                            'Error sending password reset email: $e');
                                      }
                                    } else {
                                      showErrorDialog(
                                          'Please enter your email address to reset your password.');
                                    }
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Constants.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                AppButton(
                                  type: ButtonType.PRIMARY,
                                  text: "Log In",
                                  onPressed: signIn,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

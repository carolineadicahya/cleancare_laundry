import 'package:CleanCare/pages/layout.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controller/auth.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/input_widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      User? user = userCredential.user;
      if (user != null && user.emailVerified) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LayoutPages()),
        );
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

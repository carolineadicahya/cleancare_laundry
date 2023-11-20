import 'package:CleanCare/screen/user/layout_user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:CleanCare/screen/page_awal.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:CleanCare/utils/constants.dart';
import 'package:CleanCare/widgets/app_button.dart';
import 'package:CleanCare/widgets/input_widget.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    final db = FirebaseFirestore.instance;

    context.loaderOverlay.show();
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );

      User? user = userCredential.user;

      Map<String, dynamic> body = {
        'name': _controllerFullName.text,
        'email': _controllerEmail.text,
        'role': 'user'
      };

      if (user != null) {
        await user.sendEmailVerification();
        await db
            .collection('user')
            .doc(user!.uid)
            .set(body)
            .onError((e, _) => print("Error writing document: $e"));

        // Show a dialog after email verification is sent
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Email Verifikasi Terkirim'),
              content: const Text(
                  'Email Verifikasi Telah Terkirim. Mohon Verifikasi Email Anda Sebelum Log In.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      context.loaderOverlay.hide();
      if (e.code == 'weak-password') {
        showErrorDialog('Password Terlalu Lemah.');
      } else if (e.code == 'email-already-in-use') {
        showErrorDialog('Akun Telah Terdaftar dengan Email Tersebut.');
      } else {
        showErrorDialog('Terjadi Kesalahan. Mohon Coba Lagi.');
      }
    }
  }

  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kesalahan'),
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
                                "Daftar Akun Saya",
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
                                  topLabel: "Nama Lengkap",
                                  controller: _controllerFullName,
                                  hintText: "Masukkan Nama Lengkap Anda",
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                InputWidget(
                                  topLabel: "Email",
                                  controller: _controllerEmail,
                                  hintText: "Masukkan Email Anda",
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                InputWidget(
                                  topLabel: "Password",
                                  controller: _controllerPassword,
                                  obscureText: true,
                                  hintText: "Masukkan Password Anda",
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                AppButton(
                                    type: ButtonType.PRIMARY,
                                    text: "Daftar Akun Saya",
                                    onPressed: createUserWithEmailAndPassword)
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

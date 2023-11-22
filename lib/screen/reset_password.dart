import 'package:CleanCare/controller/auth.dart';
import 'package:CleanCare/screen/login.dart';
import 'package:CleanCare/widgets/app_button.dart';
import 'package:CleanCare/widgets/input_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../utils/constants.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({Key? key});

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final TextEditingController _controllerEmail = TextEditingController();

  void _showEmailSentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Email Terkirim'),
          content: const Text(
            'Email reset password telah terkirim. Silakan cek email Anda untuk petunjuk selanjutnya.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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

  void resetPassword() async {
    context.loaderOverlay.show();
    try {
      await Auth().sendPasswordResetEmail(_controllerEmail.text);

      _showEmailSentDialog();
    } on FirebaseAuthException catch (e) {
      context.loaderOverlay.hide();
      if (e.code == 'user-not-found') {
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
                                "Reset Password",
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
                                  hintText: "Masukkan Email Anda",
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                AppButton(
                                  type: ButtonType.PRIMARY,
                                  text: "Reset Password",
                                  onPressed: resetPassword,
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

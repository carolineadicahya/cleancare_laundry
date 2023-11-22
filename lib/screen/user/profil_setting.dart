import 'package:CleanCare/screen/user/layout_user.dart';
import 'package:CleanCare/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:loader_overlay/loader_overlay.dart'; // Tambahkan ini untuk mengimpor 'File' yang diperlukan

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}); // Perbaiki 'super.key' menjadi 'Key? key'

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isEditing = false;
  File?
      _selectedImage; // Menambahkan '_selectedImage' sebagai variabel File yang dipilih

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _loadEmailUser();
    _loadUserProfile();
  }

  Future<void> _loadEmailUser() async {
    user = _auth.currentUser;
    final userEmail = await _firestore.collection('user').doc(user!.uid).get();
    if (userEmail.exists) {
      setState(() {
        emailController.text = userEmail['email'] ?? '';
      });
    }
  }

  Future<void> _loadUserProfile() async {
    user = _auth.currentUser;

    final profileData =
        await _firestore.collection('profil').doc(user!.uid).get();
    if (profileData.exists) {
      setState(() {
        nameController.text = profileData['name'] ?? '';
        addressController.text = profileData['address'] ?? '';
        phoneNumberController.text = profileData['phoneNumber'] ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final file = File(pickedImage.path);
      setState(() {
        _selectedImage = file;
      });
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
    Widget saveButton = ElevatedButton(
      onPressed: _saveChanges,
      child: const Text('Simpan Perubahan'),
    );

    Widget editButton = ElevatedButton(
      onPressed: () {
        setState(() {
          isEditing = true;
        });
      },
      child: const Text('Edit Profil'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LayoutPages(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = true;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    child: _selectedImage != null
                        ? CircleAvatar(
                            radius: 60.0,
                            backgroundImage: FileImage(_selectedImage!),
                          )
                        : CircleAvatar(
                            radius: 60.0,
                            backgroundImage:
                                AssetImage("assets/images/user.png"),
                          ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: () {
                        _pickImage();
                      },
                      icon: Icon(
                        Icons.add_a_photo_rounded,
                        color: const Color.fromARGB(255, 93, 90, 90),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Nama',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            isEditing
                ? TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nama Anda',
                    ),
                  )
                : Text(
                    nameController.text,
                    style: const TextStyle(fontSize: 16.0),
                  ),
            const SizedBox(height: 24.0),
            const Text(
              'Alamat',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            isEditing
                ? TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan alamat Anda',
                    ),
                  )
                : Text(
                    addressController.text,
                    style: const TextStyle(fontSize: 16.0),
                  ),
            const SizedBox(height: 24.0),
            const Text(
              'Nomor Telepon',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            isEditing
                ? TextFormField(
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nomor telepon Anda',
                    ),
                  )
                : Text(
                    phoneNumberController.text,
                    style: const TextStyle(fontSize: 16.0),
                  ),
            const SizedBox(height: 16.0),
            if (isEditing) isEditing ? saveButton : editButton,
            const SizedBox(height: 24.0),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/change-email');
              },
              child: Text(
                "Ganti Email?",
                textAlign: TextAlign.right,
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDocRef = _firestore.collection('profil').doc(user.uid);

      if (_selectedImage != null) {
        final storageReference =
            FirebaseStorage.instance.ref().child('profile_images/${user.uid}');
        await storageReference.putFile(_selectedImage!);

        final imageURL = await storageReference.getDownloadURL();

        await userDocRef.set({
          'name': nameController.text,
          'address': addressController.text,
          'phoneNumber': phoneNumberController.text,
          'profileImageURL': imageURL,
        }, SetOptions(merge: true));
      }
      _saveNewEmail();
    }

    setState(() {
      isEditing = false;
      _loadUserProfile();
      _loadEmailUser();
    });
  }

  Future<void> _saveNewEmail() async {
    final user = _auth.currentUser;
    await user?.sendEmailVerification();
    if (user != null) {
      try {
        await user.updateEmail(emailController.text);
        await _firestore
            .collection('user')
            .doc(user.uid)
            .update({'email': emailController.text});

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
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        context.loaderOverlay.hide();
        if (e.code == 'email-already-in-use') {
          showErrorDialog('Akun Telah Terdaftar dengan Email Tersebut.');
        } else {
          showErrorDialog('Terjadi Kesalahan. Mohon Coba Lagi.');
        }
      }
    }

    @override
    void dispose() {
      nameController.dispose();
      addressController.dispose();
      phoneNumberController.dispose();
      emailController.dispose();
      super.dispose();
    }
  }
}

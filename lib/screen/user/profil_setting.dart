import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    user = _auth.currentUser!;
    final userData = await _firestore.collection('user').doc(user!.uid).get();
    if (userData.exists) {
      setState(() {
        nameController.text = userData['Full Name'];
        emailController.text = userData['Email'];
      });
    }

    final profileData =
        await _firestore.collection('profil').doc(user!.uid).get();
    if (profileData.exists) {
      setState(() {
        nameController.text = profileData['name'] ?? nameController.text;
        addressController.text =
            profileData['address'] ?? addressController.text;
        phoneNumberController.text =
            profileData['phoneNumber'] ?? phoneNumberController.text;
        emailController.text = profileData['email'] ?? emailController.text;
      });
    }
  }

  String name = "Nama Pengguna";
  String address = "Alamat Pengguna";
  String phoneNumber = "Nomor Telepon";
  String email = "Email Pengguna";

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
          nameController.text = name;
          addressController.text = address;
          phoneNumberController.text = phoneNumber;
          emailController.text = email;
        });
      },
      child: const Text('Edit Profil'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = true;
                nameController.text =
                    nameController.text; // Initialize with existing data
                addressController.text =
                    addressController.text; // Initialize with existing data
                phoneNumberController.text =
                    phoneNumberController.text; // Initialize with existing data
                emailController.text =
                    emailController.text; // Initialize with existing data
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
              child: GestureDetector(
                onTap: () {
                  // Tambahkan logika untuk memilih atau mengganti gambar profil
                },
                child: const CircleAvatar(
                  radius: 60.0,
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
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
                    nameController.text, // Display the name from the controller
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
                    addressController
                        .text, // Display the address from the controller
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
                    phoneNumberController
                        .text, // Display the phone number from the controller
                    style: const TextStyle(fontSize: 16.0),
                  ),
            const SizedBox(height: 24.0),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            isEditing
                ? TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan email Anda',
                    ),
                  )
                : Text(
                    emailController
                        .text, // Display the email from the controller
                    style: const TextStyle(fontSize: 16.0),
                  ),
            const SizedBox(height: 24.0),
            if (isEditing) isEditing ? saveButton : editButton
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    final userDocRef = _firestore.collection('profil').doc(user!.uid);
    await userDocRef.set({
      'name': nameController.text,
      'address': addressController.text,
      'phoneNumber': phoneNumberController.text,
      'email': emailController.text,
    }, SetOptions(merge: true));
    setState(() {
      isEditing = false;
      name = nameController.text;
      address = addressController.text;
      phoneNumber = phoneNumberController.text;
      email = emailController.text;
    });
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

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User user;

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

    final userDoc = await _firestore.collection('user').doc(user.uid).get();
    if (userDoc.exists) {
      setState(() {
        name = userDoc['fullname'] ?? '';
        address = userDoc['address'] ?? '';
        phoneNumber = userDoc['phoneNumber'] ?? '';
        email = userDoc['email'] ?? '';
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
                nameController.text = name;
                addressController.text = address;
                phoneNumberController.text = phoneNumber;
                emailController.text = email;
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
                    name,
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
                    address,
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
                    phoneNumber,
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
                    email,
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
    final userDocRef = _firestore.collection('user').doc(user.uid);
    await userDocRef.set({
      'name': nameController.text,
      'address': addressController.text,
      'phoneNumber': phoneNumberController.text,
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

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Tambahkan ini untuk mengimpor 'File' yang diperlukan

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
    _loadUserProfile();
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
        emailController.text = profileData['email'] ?? '';
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
              child: GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: _selectedImage != null
                    ? CircleAvatar(
                        radius: 60.0,
                        backgroundImage: FileImage(_selectedImage!),
                      )
                    : CircleAvatar(
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
                    emailController.text,
                    style: const TextStyle(fontSize: 16.0),
                  ),
            const SizedBox(height: 24.0),
            if (isEditing) isEditing ? saveButton : editButton,
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
          'email': emailController.text,
          'profileImageURL': imageURL,
        }, SetOptions(merge: true));
      } else {
        await userDocRef.set({
          'name': nameController.text,
          'address': addressController.text,
          'phoneNumber': phoneNumberController.text,
          'email': emailController.text,
        }, SetOptions(merge: true));
      }

      setState(() {
        isEditing = false;
        _loadUserProfile(); // Memuat ulang data profil
      });
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

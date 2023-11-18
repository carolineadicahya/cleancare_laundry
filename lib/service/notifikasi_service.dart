import 'dart:convert';
// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotifikasiService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Di dalam metode initNotifikasi
  Future<void> initNotifikasi(String uid) async {
    try {
      // Meminta izin notifikasi dari pengguna
      await _firebaseMessaging.requestPermission();

      // Mendapatkan FCM Token
      String? fCMToken = await _firebaseMessaging.getToken();
      FirebaseFirestore.instance.collection('user').doc(uid).update({
        'fcmToken': fCMToken,
      });

      // Mencetak token
      print('Token: $fCMToken');

      // Mendengarkan perubahan token FCM
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        // Callback ini akan dipanggil saat token FCM diperbarui
        print('Token refreshed: $newToken');
        // Anda dapat menangani perbaruan token sesuai kebutuhan aplikasi Anda
        FirebaseFirestore.instance.collection('user').doc(uid).update({
          'fcmToken': fCMToken,
        });
      });

      if (fCMToken != null) {
        // Menginisialisasi push notifications
        initPushNotifications();

        // Inisialisasi flutter_local_notifications
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        final InitializationSettings initializationSettings =
            InitializationSettings(
          android: initializationSettingsAndroid,
        );
        await flutterLocalNotificationsPlugin
            .initialize(initializationSettings);
      } else {
        // Handle case when FCM token is null
        print('Error: Unable to retrieve FCM token.');
      }
    } catch (e) {
      // Handle other potential errors
      print('Error initializing notifications: $e');
    }
  }

  // Menangani pesan
  void handlePesan(RemoteMessage? message) {
    if (message == null) return;

    // Jika aplikasi sedang berjalan (foreground), handle notifikasi di sini
    print('Foreground Notification: ${message.notification?.body}');

    // Show the notification in the system tray
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'clean_care_channel_id', // Replace with your channel ID
      'CleanCare Channel', // Replace with your channel name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  Future<void> initPushNotifications() async {
    // Menangani pesan ketika aplikasi sedang tertutup dan dibuka dari notifikasi
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      // Ganti dengan metode handlePesan atau sesuaikan dengan kebutuhan Anda
      handlePesan(message);
    });

    // Menangani pesan ketika aplikasi sudah terbuka
    FirebaseMessaging.onMessage.listen((message) {
      // Ganti dengan metode handlePesan atau sesuaikan dengan kebutuhan Anda
      handlePesan(message);
    });

    // Menangani pesan ketika aplikasi dibuka dari notifikasi (latar belakang)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Ganti dengan metode handlePesan atau sesuaikan dengan kebutuhan Anda
      handlePesan(message);
    });
  }

  // Mengirim notifikasi ke perangkat pengguna
  Future<void> sendNotification(
    String title,
    String body,
    String userFCMToken,
  ) async {
    await dotenv.load();
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=${dotenv.env['FCM_API_KEY']}',
      },
      body: jsonEncode(<String, dynamic>{
        'to': userFCMToken,
        'notification': {'title': title, 'body': body},
      }),
    );
  }

  Future<String?> getUserFCMTokenByEmail(String userEmail) async {
    // Query the Firestore database where the email field matches the userEmail
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: userEmail)
        .get();

    // Check if the query returns any documents
    if (querySnapshot.docs.isNotEmpty) {
      // If yes, return the FCM token of the first document
      return querySnapshot.docs.first.data()['fcmToken'];
    } else {
      // If no documents are found, return null
      return null;
    }
  }

  Future<void> sendOrderNotification(String userEmail) async {
    // Mendapatkan FCM Token admin
    final adminFCMToken = await getUserFCMTokenByEmail("almaditha22@gmail.com");

    // Memastikan FCM Token admin ditemukan
    if (adminFCMToken != null) {
      // Membuat judul dan isi notifikasi
      final title = 'Order Baru!';
      final body = 'Ada order baru dari $userEmail';

      // Mengirim notifikasi ke perangkat admin
      await sendNotification(title, body, adminFCMToken);

      // Navigasi ke halaman notifikasi order
      // navigateToRoute = '/notif-order';
    }
  }

  Future<void> sendStatusNotification(String userEmail, String status) async {
    // Mendapatkan FCM Token pengguna berdasarkan email
    final userFCMToken = await getUserFCMTokenByEmail(userEmail);

    // Memastikan FCM Token pengguna ditemukan
    if (userFCMToken != null) {
      // Membuat judul dan isi notifikasi
      final title = 'Status Laundry';
      final body = 'Laundry kamu sudah $status';

      // Mengirim notifikasi ke perangkat pengguna
      await sendNotification(title, body, userFCMToken);

      // navigateToRoute = '/notif-status';
    }
  }
}

class Config {
  static Future<String?> getAdminFCMToken() async {
    return 'your_admin_fcm_token';
  }

  static Future<String?> getUserFCMToken() async {
    return 'your_user_fcm_token';
  }
}

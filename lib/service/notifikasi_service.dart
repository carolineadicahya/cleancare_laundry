import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifikasiService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Di dalam metode initNotifikasi
  Future<void> initNotifikasi() async {
    try {
      // Meminta izin notifikasi dari pengguna
      await _firebaseMessaging.requestPermission();

      // Mendapatkan FCM Token
      String? fCMToken = await _firebaseMessaging.getToken();

      // Mencetak token
      print('Token: $fCMToken');

      // Mendengarkan perubahan token FCM
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        // Callback ini akan dipanggil saat token FCM diperbarui
        print('Token refreshed: $newToken');
        // Anda dapat menangani perbaruan token sesuai kebutuhan aplikasi Anda
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

    // Menghapus notifikasi setelah membuka aplikasi
    flutterLocalNotificationsPlugin.cancelAll();

    // Jika aplikasi sedang latar belakang, Anda bisa menavigasi ke layar notifikasi
    // Pastikan Anda memiliki setup Navigator yang benar
    // Navigator.pushNamed('/notification_screen', arguments: message);
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
    // Menyesuaikan pesan notifikasi
    String notificationMessage = body;

    // Mengirim notifikasi ke perangkat pengguna dengan FCM Token
    await _firebaseMessaging.subscribeToTopic(userFCMToken);

    // Konfigurasi notifikasi lokal
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'clean_care_channel_id', // Ganti dengan ID channel yang sesuai
      'CleanCare Channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Tampilkan notifikasi lokal
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      notificationMessage,
      platformChannelSpecifics,
    );

    print('Notification sent: $notificationMessage');
  }

  Future<String?> getUserFCMTokenByEmail(String userEmail) async {
    // Replace this with your logic to get the FCM token based on the user's email
    // For now, using a placeholder method from Config class
    return Config.getUserFCMToken();
  }

  Future<void> sendOrderNotification(String userEmail) async {
    // Mendapatkan FCM Token admin
    final adminFCMToken = await Config.getAdminFCMToken();

    // Memastikan FCM Token admin ditemukan
    if (adminFCMToken != null) {
      // Membuat judul dan isi notifikasi
      final title = 'Order Baru!';
      final body = 'Ada order baru dari $userEmail';

      // Mengirim notifikasi ke perangkat admin
      await sendNotification(title, body, adminFCMToken);
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

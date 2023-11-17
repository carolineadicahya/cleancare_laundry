import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotifikasiService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifikasi() async {
    // request untuk permission dari user
    await _firebaseMessaging.requestPermission();

    // fetch FCM Token
    final fCMToken = await _firebaseMessaging.getToken();

    // print token
    print('Token: $fCMToken');

    initPushNotifications();
  }

  // handle pesan
  void HandlePesan(RemoteMessage? message) {
    if (message == null) return;

    // navigatorKey.currentState
    //     ?.pushNamed('/notification_screen', arguments: message);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(HandlePesan);

    FirebaseMessaging.onMessageOpenedApp.listen(HandlePesan);
  }

  void sendNotification(String status, String userFCMToken) {
    // Customize the notification message based on the status
    String notificationMessage = 'Laundry status: $status';
    print(notificationMessage);
  }
}


// -------------------------------
// local notif
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Initialize notifications
//   Future<void> initNotification() async {
//     AndroidInitializationSettings androidInitializationSettings =
//         const AndroidInitializationSettings('cleancare_logo');

//     var initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }

//   // Define channel details
//   NotificationDetails notificationDetails() {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id', // replace with your channel ID
//       'your_channel_name', // replace with your channel name
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     return NotificationDetails(android: androidPlatformChannelSpecifics);
//   }

//   // Show notification
//   Future<void> showNotification(
//       {required String title, required String body}) async {
//     await notificationsPlugin.show(
//       0, // notification id
//       title, // notification title
//       body, // notification body
//       await notificationDetails(),
//     );
//   }
// }

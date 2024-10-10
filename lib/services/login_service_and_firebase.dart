import 'dart:convert';
import 'package:fltask/services/get_service_key.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AuthService {
  static const String baseUrl = 'https://test.bookinggksm.com/api';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {
        "email": email,
        "password": password,
        "user_type": "4",
        "device_token": "we are taking any device token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['status'] == true) {
        return responseBody;
      } else {
        throw Exception('Failed to login: ${responseBody}');
      }
    } else {
      throw Exception('Failed to login');
    }
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  // function to initialize notifications
  Future<void> initNotifications() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();

    print('FCM Token: $fCMToken');
    // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );
    await _localNotifications.initialize(initializationSettings);

    // Listen for Firebase messages
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });
  }

  Future<void> sendPushNotification(String title, String body) async {
    try {
      String serverkey = await GetServerKey().getServerKeyToken();
      print('server key: ${serverkey}');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverkey'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/fluttertask-ad3db/messages:send'));
      request.body = json.encode({
        "message": {
          "token": await _firebaseMessaging.getToken(),
          "notification": {"body": body, "title": title}
        }
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print('done, we have sent it');
      } else {
        print('we got some error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }
}

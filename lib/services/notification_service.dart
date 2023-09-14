import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('notification_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'channel_id', 'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await saveTokenToDatabase(token);
    }
    _firebaseMessaging.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<AccessCredentials> _getCredentials() async {
    final rawJson =
        await rootBundle.loadString('lib/assets/service_account_key.json');
    final jsonCreds = json.decode(rawJson);
    final client = http.Client();

    final creds = ServiceAccountCredentials.fromJson(jsonCreds);

    final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final credentials =
        await obtainAccessCredentialsViaServiceAccount(creds, scopes, client);

    client.close();

    return credentials;
  }

  Future<void> saveTokenToDatabase(String token) async {
    await _firestore.collection('userDocs').doc(userId).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  Future<void> sendFollowerNotification(
      String targetToken, String followerName) async {
    const String fcmAPI =
        'https://fcm.googleapis.com/v1/projects/toni-case-study/messages:send';

    final credentials = await _getCredentials();
    final authToken = credentials.accessToken.data;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    var request = {
      'message': {
        'token': targetToken,
        'notification': {
          'title': 'Yeni Takip Edilen!',
          'body': '$followerName takip etmeye başladın',
        }
      }
    };

    var response = await http.post(
      Uri.parse(fcmAPI),
      headers: headers,
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      print('Bildirim başarıyla gönderildi!');
    } else {
      print('Bildirim gönderilirken bir hata oluştu: ${response.body}');
    }
  }
}

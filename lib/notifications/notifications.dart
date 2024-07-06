import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _totalNotifications;
  PushNotification _notificationInfo;

  FirebaseMessaging _messaging;
  void registerNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received


        setState(() {
          PushNotification notification = PushNotification(
            title: message.notification.title,
            body: message.notification.body,
            dataTitle: message.data['title'],
            dataBody: message.data['body'],
          );
          _notificationInfo = notification;
          _totalNotifications++;
        });
//        if (_notificationInfo != null) {
//          // For displaying the notification as an overlay
//          showSimpleNotification(
//            Text(_notificationInfo.title),
//            leading: NotificationBadge(totalNotifications: _totalNotifications),
//            subtitle: Text(_notificationInfo.body),
//            background: Colors.cyan.shade700,
//            duration: Duration(seconds: 2),
//          );
//        }
      });
    } else {
      print('User declined or has not accepted permission');
    }


  }
  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification.title,
        body: initialMessage.notification.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification.title,
        body: message.notification.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    });
    checkForInitialMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NotificationBadge(totalNotifications: _totalNotifications),
              Text("Hi"),
            ],
          ),
        ),
      ),
    );
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });
  String title;
  String body;
  String dataTitle;
  String dataBody;
}


class NotificationBadge extends StatelessWidget {
final totalNotifications;
NotificationBadge({this.totalNotifications});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////





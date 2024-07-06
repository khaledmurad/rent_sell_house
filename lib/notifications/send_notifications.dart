import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_mate_app/filter/filter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class SendNotifi {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  User user;
  BuildContext context;
  Future<void> sendNotification(receiver,widget,chatID,body,title)async{
    var token = await getToken(receiver);
    print('token : $token');

    final data = {
      "notification": {"body": "$body", "title": "$title"},
      "priority": "high",
//      "apns":{
//        "payload":{
//          "aps":{
//            "sound":"default"
//          }
//        }
//      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        //"id": "1",
        "status": "done",
        'sound': 'default',
        "screen": widget,
        "chatID": '$chatID',
        "reserverID": '$receiver'
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAqBCgPaY:APA91bGGg-cR37ygBZxISPf5o3RUZfUE7TDuvf5HYXUZRGFpjke3oBcX7HQL4prkqN_7B737n1JmHtQuGAyZfmqxLVeKGDz9zY3L5svc7AMO6zU8SaKYZVWINPGAOWeD9-fea1ovs4b9'
    };
    final postUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

    try {
      final response = await http.post(postUrl,
          body: jsonEncode(data),
          headers: headers);
      if (response.statusCode == 200) {
        print("Hi it's done : 'Request Sent To Driver'");
      } else {
        print('notification sending failed');
// on failure do sth
      }
    }
    catch (e) {
      print('A exception $e');
    }






  }

  Future<String> getToken(userId)async{

    final FirebaseFirestore _db = FirebaseFirestore.instance;


    var token;
    await _db.collection('Users')
        .doc(userId).collection("tokens")
        .get().then((snapshot){
      snapshot.docs.forEach((doc){
        token = doc['token'];
      });
    });

    return token;


  }

}

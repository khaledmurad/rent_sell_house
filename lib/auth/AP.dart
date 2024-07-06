import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate_app/auth/anonumus.dart';
import 'package:home_mate_app/auth/landing.dart';
import 'package:home_mate_app/auth/signup.dart';
import 'package:home_mate_app/screens/profile/profile.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../screens/home.dart';
import 'auth.dart';
import 'login.dart';

class AorP extends StatefulWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  _AorPState createState() => _AorPState();
}

class _AorPState extends State<AorP> {
  _AorPState({this.user});
  User user;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        child: ListView(
          children: [
            StreamBuilder<User>(
                stream: auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    user = snapshot.data;
                    if (user == null ||user.isAnonymous) {
                      return AnonmusPage();
                    } else {
                      return Landing();
                    }
                  } else {
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }


}

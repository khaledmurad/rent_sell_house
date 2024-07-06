import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/auth/login.dart';
import 'package:home_mate_app/auth/signup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../alert_widget/show_exception_alert_dialog.dart';
import 'auth.dart';

class AnonmusPage extends StatefulWidget {
  @override
  _AnonmusPageState createState() => _AnonmusPageState();
  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(context,
        title: 'Sign UP failed', exception: exception);
  }
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  List<String> users_emails = List<String>();
  u(){
    FirebaseFirestore.instance.collection("Users").get().then((value){
      value.docs.forEach((element) {
        users_emails.add(element['email']);
      });
    });
    print("users emails : ${users_emails.length}");
  }
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      u();
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithGoogle();
      print('${user.uid}');
      Random rnd = Random();
      if(users_emails.contains(user.email)) {
        FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
      }else {
        FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          "email": FirebaseAuth.instance.currentUser.email,
          "id": FirebaseAuth.instance.currentUser.uid,
          "name_f": FirebaseAuth.instance.currentUser.displayName.split(' ')[0],
          "name_l": FirebaseAuth.instance.currentUser.displayName.split(' ')[1],
          'birthday': '',
          'gender': '',
          'address': '',
          'city': '',
          'country': '',
          'postcode': '',
          'c_code': '',
          'phone_code': '',
          'lastlogin': FirebaseAuth.instance.currentUser.metadata
              .lastSignInTime,
          'sginupdate': FirebaseAuth.instance.currentUser.metadata.creationTime,
          'phone': '',
          'user_info': '',
          'image': FirebaseAuth.instance.currentUser.photoURL
        });
      }
      _messaging.getToken().then((t){
        print("token is $t");
        FirebaseFirestore.instance.collection("Users").doc(user.uid)
            .collection("tokens").doc("token").set({
          "token": t,
          "createdTime":DateTime.now(),
          "userID":user.uid
        });
      });
      Navigator.pop(context);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Landing()),(route)=>false);
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInWithFacebook();
      print('${user.uid}');
      Random rnd = Random();
      // FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
      //   "email": FirebaseAuth.instance.currentUser.email,
      //   "id": FirebaseAuth.instance.currentUser.uid,
      //   "name_f": FirebaseAuth.instance.currentUser.displayName.split(' ')[0],
      //   "name_l": FirebaseAuth.instance.currentUser.displayName.split(' ')[1],
      //   'birthday': '',
      //   'gender': '',
      //   'address': '',
      //   'city': '',
      //   'country': '',
      //   'c_code': '',
      //   'phone_code': '',
      //   'postcode': '',
      //   'lastlogin': FirebaseAuth.instance.currentUser.metadata.lastSignInTime,
      //   'sginupdate': FirebaseAuth.instance.currentUser.metadata.creationTime,
      //   'phone': '',
      //   'user_info': '',
      //   'image': FirebaseAuth.instance.currentUser.photoURL,
      //
      // });
      if(users_emails.contains(user.email)) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();
      }else{
        FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          "email": FirebaseAuth.instance.currentUser.email,
          "id": FirebaseAuth.instance.currentUser.uid,
          "name_f": FirebaseAuth.instance.currentUser.displayName.split(' ')[0],
          "name_l": FirebaseAuth.instance.currentUser.displayName.split(' ')[1],
          'birthday': '',
          'gender': '',
          'address': '',
          'city': '',
          'country': '',
          'c_code': '',
          'phone_code': '',
          'postcode': '',
          'lastlogin': FirebaseAuth.instance.currentUser.metadata.lastSignInTime,
          'sginupdate': FirebaseAuth.instance.currentUser.metadata.creationTime,
          'phone': '',
          'user_info': '',
          'image': FirebaseAuth.instance.currentUser.photoURL,

        });
      }
      _messaging.getToken().then((t){
        print("token is $t");
        FirebaseFirestore.instance.collection("Users").doc(user.uid)
            .collection("tokens").doc("token").set({
          "token": t,
          "createdTime":DateTime.now(),
          "userID":user.uid
        });
      });
      Navigator.pop(context);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Landing()),(route)=>false);
    } on Exception catch (e) {
      _showSignInError(context, e);
      print("signup facebook error : $e");
    }
  }
}

class _AnonmusPageState extends State<AnonmusPage> {

  Widget _buildGoogle() {
    // bool emailValid = widget.emailVaildator.isValid(_email);
    return GestureDetector(
      onTap: (){widget._signInWithGoogle(context);},
      child: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          shape: BoxShape.circle
        ),
        height: MediaQuery.of(context).size.height*0.05,
        width: MediaQuery.of(context).size.width * .12,
        child:Center(child: Expanded(flex: 1,child: Icon(
          FontAwesomeIcons.google,color: Colors.white,
        size: MediaQuery.of(context).size.width * 0.05,))),
      ),
    );
  }
  Widget _buildFacebook() {
    // bool emailValid = widget.emailVaildator.isValid(_email);
    return GestureDetector(
      onTap: (){widget._signInWithFacebook(context);},
      child: Container(
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle
        ),
        height: MediaQuery.of(context).size.height*0.05,
        width: MediaQuery.of(context).size.width * .12,
        child:Center(child: Expanded(flex: 1,child: Icon(
          FontAwesomeIcons.facebookF,color: Colors.white,
        size: MediaQuery.of(context).size.width * 0.05,))),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //padding: EdgeInsets.only(top: size.height*0.08, left: size.width*0.07 , right: size.width*0.07),
            children: [
              SizedBox(height: size.height * 0.1,),
              Image.asset("assets/images/a.png",
                  height:  size.height*0.3,width:  size.width,),
              SizedBox(height: size.height * 0.1,),
              Text(AppLocalizations.of(context).your_profile,
                style: TextStyle(fontSize: size.width * .06,
                  fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold',
              color: Theme.of(context).primaryColor),),
              SizedBox(height: size.height*0.02,),
              Text(AppLocalizations.of(context).login_to_start_plan,
                style: TextStyle(fontSize: size.width * .035,
                    fontWeight: FontWeight.bold,
                  fontFamily: 'poppins'),),
              SizedBox(height: size.height*0.05,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      => LoginPage()));
                    },
                    child: Container(
                      width: size.width * .3,
                      height: size.height * .05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor
                      ),
                      child: Center(
                          child: Text(
                            AppLocalizations.of(context).login,
                            style: TextStyle(
                                fontSize: size.width*0.045,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinsbold',
                                color: Colors.white),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      => SignupPage()));
                    },
                    child: Container(
                      width: size.width * .3,
                      height: size.height * .05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1
                          )
                      ),
                      child: Center(
                          child: Text(
                            AppLocalizations.of(context).signup,
                            style: TextStyle(
                                fontSize: size.width*0.045,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinsbold',
                                color: Theme.of(context).primaryColor),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height*0.05,),
              // Row(
              //   children: [
              //     Text(AppLocalizations.of(context).dont_have_account,style: TextStyle(fontSize: 17),),
              //     SizedBox(width: size.width*0.01,),
              //     InkWell(onTap: (){
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (context)=>SignupPage())
              //       );
              //     }, child: Text(AppLocalizations.of(context).signup,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
              //         decoration: TextDecoration.underline,decorationThickness: 5
              //     )),)
              //
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoogle(),
                  SizedBox(width: size.width*0.1,),
                  Text(AppLocalizations.of(context).or,style: TextStyle(fontSize: size.width * .04,fontFamily: 'poppins'),),
                  SizedBox(width: size.width*0.1,),
                  _buildFacebook(),
                ],
              ),

            ],
          ),
      );
  }
}

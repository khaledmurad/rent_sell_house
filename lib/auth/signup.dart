import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/alert_widget/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'auth.dart';
import 'landing.dart';

class SignupPage extends StatefulWidget {

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

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _FNController = TextEditingController();
  final TextEditingController _LNController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _Fname => _FNController.text;
  String get _Lname => _LNController.text;
  bool _submitted = false;
  String emailwrong,passwrong,fname,lname;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void _submit(BuildContext context) async {
    _submitted = true;

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.CreateUserWithEmailandPassword(_email, _password);
      Random rnd = Random();
      FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser.uid)
          .set({
        "id": auth.currentUser.uid,
        "email": _email,
        'birthday': '',
        'gender': '',
        'address': '',
        'city': '',
        'country': '',
        'c_code': '',
        'postcode': '',
        'lastlogin': FirebaseAuth.instance.currentUser.metadata.lastSignInTime,
        'sginupdate': FirebaseAuth.instance.currentUser.metadata.creationTime,
        'phone': '',
        'phone_code': '',
        'image': '',
        'name_f': capitalize(_Fname),
        'name_l': capitalize(_Lname),
        'user_info':''
      });
      widget._messaging.getToken().then((t){
        print("token is $t");
        FirebaseFirestore.instance.collection("Users").doc(auth.currentUser.uid)
            .collection("tokens").doc("token").set({
          "token": t,
          "createdTime":DateTime.now(),
          "userID":auth.currentUser.uid
        });
      });
      Navigator.pop(context);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Landing()), (route)=>false);
    } catch (e) {
      print(e.toString());
     if(e.toString() == "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
       setState(() {
         emailwrong = "1";
       });
     }else if(e.toString() == "[firebase_auth/invalid-email] The email address is badly formatted."){
       setState(() {
         emailwrong = "2";
       });
     }
    }

  }

  Widget _buildEmailTF() {
    // bool emailValid = widget.emailVaildator.isValid(_email);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: 0.5,color: Theme.of(context).primaryColor)
      ),
      height: MediaQuery.of(context).size.height*0.075,
      child: TextField(
        controller:  _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'poppins',
        ),
        onChanged: (v){
          setState(() {
            emailwrong = "";
          });
        },
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).email,
          border: InputBorder.none,
          labelStyle: TextStyle(
            // color: Colors.black,
            fontFamily: 'poppins',color: Theme.of(context).primaryColor
          ),
        ),
      ),
    );
  }
  Widget _buildFirstNameTF() {
    // bool emailValid = widget.emailVaildator.isValid(_email);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: 0.5,color: Theme.of(context).primaryColor)
      ),
      height: MediaQuery.of(context).size.height*0.075,
      child: TextField(
        controller:  _FNController,
        keyboardType: TextInputType.text,
        onChanged: (v){
          setState(() {
            fname = "";
          });
        },
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'poppins',
        ),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).first_name,
          border: InputBorder.none,
          labelStyle: TextStyle(
            // color: Colors.black,
            fontFamily: 'poppins',color: Theme.of(context).primaryColor
          ),
        ),
      ),
    );
  }
  Widget _buildSorNameTF() {
    // bool emailValid = widget.emailVaildator.isValid(_email);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: 0.5,color: Theme.of(context).primaryColor)
      ),
      height: MediaQuery.of(context).size.height*0.075,
      child: TextField(
        controller:  _LNController,
        onChanged: (v){
          setState(() {
            lname = "";
          });
        },
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'poppins',
        ),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).last_name,
          border: InputBorder.none,
          labelStyle: TextStyle(
            // color: Colors.black,
            fontFamily: 'poppins',color: Theme.of(context).primaryColor
          ),
        ),
      ),
    );
  }
  Widget _buildPasswordTF() {
    //bool passwordValid = widget.passwordVaildator.isValid(_password);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(width: 0.5,color: Theme.of(context).primaryColor)
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: true,
        onChanged: (v){
          setState(() {
            passwrong = "";
          });
        },
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'poppins',
        ),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).password,
          border: InputBorder.none,
          labelStyle: TextStyle(
            // color: Colors.black,
            fontFamily: 'poppins',color: Theme.of(context).primaryColor
          ),
        ),
      ),
    );
  }
  bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
    password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= minLength;

    return (hasDigits &
    (hasUppercase ||
        hasLowercase) &
    hasSpecialCharacters &
    hasMinLength)||(hasDigits &
    (hasUppercase ||
        hasLowercase) &
    hasMinLength);
  }
  Widget _bottun() {
    Size size = MediaQuery.of(context).size;
    return  RaisedButton(
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: size.height*0.065,
        width: size.width,
        child: Center(
            child: Text(
              AppLocalizations.of(context).signup,
              style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      ),
      onPressed: () {

        if(!_Fname.contains(new RegExp(r'[A-Z]')) && !_Fname.contains(new RegExp(r'[a-z]'))){
          setState(() {
            fname = "1";
          });
        }
        if(!_Lname.contains(new RegExp(r'[A-Z]')) && !_Lname.contains(new RegExp(r'[a-z]'))){
          setState(() {
            lname = "1";
          });
        }
        if (isPasswordCompliant(_password) == true) {
          try {
            setState(() {
              passwrong ="";
            });
          } on Exception catch (e) {
            print(e);
          }
        }else{
          setState(() {
            passwrong ="1";
          });
        }
        if(fname==""&&lname==""&&passwrong==""&&emailwrong==""){
          _submit(context);
        }
        },
    );
  }
  Widget _lineor(){
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height:size.height*0.0005,
          width:size.width*0.35,
          color:Colors.black,),
        Text(AppLocalizations.of(context).or,style: TextStyle(fontSize: 15,fontFamily: 'poppins'),),
        Container(
          height:size.height*0.0005,
          width:size.width*0.35,
          color:Colors.black,),
      ],
    );
  }
  Widget _buildGoogle() {
    // bool emailValid = widget.emailVaildator.isValid(_email);
    return GestureDetector(
      onTap: (){widget._signInWithGoogle(context);},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 45),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(width: 0.5,color: Colors.black)
        ),
        height: MediaQuery.of(context).size.height*0.075,
        child:Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(flex: 1,child: Icon(FontAwesomeIcons.google)),
            Expanded(flex: 3,child: Text(AppLocalizations.of(context).continue_with_Google,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'poppins'),))
          ],
        ),
      ),
    );
  }
  Widget _buildFacebook() {
    // bool emailValid = widget.emailVaildator.isValid(_email);
    return GestureDetector(
      onTap: (){widget._signInWithFacebook(context);},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 45),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(width: 0.5,color: Colors.black)
        ),
        height: MediaQuery.of(context).size.height*0.075,
        child:Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(flex: 1,child: Icon(FontAwesomeIcons.facebookF,color: Colors.blue,)),
            Expanded(flex: 3,child: Text(AppLocalizations.of(context).continue_with_Facebook,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'poppins'),))
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        child: ListView(
          padding: EdgeInsets.only(top: size.height*0.08, left: size.width*0.07 , right: size.width*0.07),
          children: [
            SizedBox(height: size.height * 0.03,),
            Text(AppLocalizations.of(context).your_profile,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'poppinsbold',
            color: Theme.of(context).primaryColor),),
            SizedBox(height: size.height * 0.02,),
            Image.asset("assets/images/c.png",
              height:  size.height*0.275,width:  size.width,),
            SizedBox(height: size.height * 0.03,),
            _buildFirstNameTF(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (fname =="1")?
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                    child:Text("Incorrect",style: TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.bold),)
                ):Container(height: 0,width: 0,),
              ],
            ),
            SizedBox(height: size.height*0.02,),
            _buildSorNameTF(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (lname =="1")?
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                    child:Text("Incorrect",style: TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.bold),)
                ):Container(height: 0,width: 0,),
              ],
            ),
            SizedBox(height: size.height*0.02,),
            _buildEmailTF(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (emailwrong =="1")?
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                    child:Text("The email is used",style: TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.bold),)
                ):Container(height: 0,width: 0,),
                (emailwrong =="2")?
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                    child:Text("Email is incorrect",style: TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.bold),)
                ):Container(height: 0,width: 0,),
              ],
            ),
            SizedBox(height: size.height*0.02,),
            _buildPasswordTF(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (passwrong =="1")?
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                    child:Text("Password will be min 6, and contain letters and numbers",style: TextStyle(fontSize: 12,color: Colors.red,fontWeight: FontWeight.bold),)
                ):Container(height: 0,width: 0,),
              ],
            ),
            SizedBox(height: size.height*0.02,),
            _bottun(),
            // SizedBox(height: size.height*0.04,),
            // _lineor(),
            // SizedBox(height: size.height*0.04,),
            // _buildGoogle(),
            // SizedBox(height: size.height*0.02,),
            // _buildFacebook(),
          ],
        ),
      ),
    );
  }
}

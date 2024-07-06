import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:home_mate_app/alert_widget/show_exception_alert_dialog.dart';
import 'package:home_mate_app/controllers/users.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/models/users.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'auth.dart';
import 'landing.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _showSignInError(BuildContext context,Exception exception){
    if(exception is FirebaseException && exception.code == 'ERROR_ABORTED_BY_USER'){
      return;
    }
    showExceptionAlertDialog(context, title: 'Sign in failed', exception: exception);
  }
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FToast fToast;
  String wrongemailorpass = "";

  List<String> users_emails = List<String>();
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    FirebaseFirestore.instance.collection("Users").get().then((value){
      value.docs.forEach((element) {
        users_emails.add(element['email']);
      });
    });
    print("users emails : ${users_emails.length}");
    a();
  }
  Future<void> a() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));

  }


  Future<void> _signInWithGoogle(BuildContext context) async {
    try{
      setState(()=> _isLoading = true);
      final auth = Provider.of<AuthBase>(context,listen: false);
      final user = await  auth.signInWithGoogle();
      print('${user.uid}');
      Random rnd = Random();

      if(users_emails.contains(user.email)) {
        FirebaseFirestore.instance.collection("Users").doc(user.uid).get();
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
          'postcode': '',
          'c_code': '',
          'phone_code': '',
          'lastlogin': FirebaseAuth.instance.currentUser.metadata.lastSignInTime,
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
      ObjectDescription(user: user,);
      Navigator.pop(context);
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Landing()),(route)=>false);

    }on Exception catch(e){
      _showSignInError(context, e);
      print("google signing error : $e");
    } finally {
      setState(()=> _isLoading = false);
    }
  }
  bool _isLoading = false;
  String ForgetPassword;
  Future<void> _signInWithFacebook(BuildContext context) async {
    try{
      final auth = Provider.of<AuthBase>(context,listen: false);
      final user = await  auth.signInWithFacebook();
      print('${user.uid}');
      Random rnd = Random();
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

    }on Exception catch(e){
      _showSignInError(context, e);
      print("signing facebook error : $e");
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var _formkey = GlobalKey<FormState>();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  Widget _buildForgotPasswordBtn() {
    return Container(

      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
         showDialog(context: context,
           builder: (context) => AlertDialog(
             title: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(AppLocalizations.of(context).forget_password,style: TextStyle(
                     fontFamily: 'poppinsbold',color: Theme.of(context).primaryColor),),
               ],
             ),
             content:Form(
               key: _formkey,
               child: Container(
                 height:MediaQuery.of(context).size.height*0.125 ,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Text(
                       AppLocalizations.of(context).email,
                       style: TextStyle(
                         fontSize: 15,
                         color: Theme.of(context).primaryColor,
                         fontWeight: FontWeight.bold,
                         fontFamily: 'poppins',
                       ),
                     ),
                     SizedBox(height: MediaQuery.of(context).size.height*0.01),
                     Container(
                       padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.025),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(10.0),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black,
                             //blurRadius: 3.0,
                             //offset: Offset(0, 1),
                           ),
                         ],
                       ),
                       height: MediaQuery.of(context).size.height*0.075,
                       child: TextField(
                         keyboardType: TextInputType.emailAddress,
                         onChanged: (v){
                           ForgetPassword = v ;
                         },
                         style: TextStyle(
                           color: Colors.black,
                           fontFamily: 'poppins',
                         ),
                         decoration: InputDecoration(
                           border: InputBorder.none,
                          // contentPadding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.014),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ) ,
             actions: <Widget>[
               Container(
                 padding: EdgeInsets.all(5),
                 child: GestureDetector(
                     child: Text(
                       AppLocalizations.of(context).send,
                       style: TextStyle(
                         fontFamily: 'poppins',color: Theme.of(context).primaryColor,
                       fontSize: 12.5),
                     ),
                     onTap:() {
                       if(_formkey.currentState.validate()){
                         FirebaseAuth.instance.sendPasswordResetEmail(email: ForgetPassword).then((value) => print("check your mail"));
                         Navigator.of(context).pop(true);
                         setState(() {
                           fToast.showToast(
                             child: Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25.0),
                                   color: Colors.black,
                                 ),
                                 child: Text(AppLocalizations.of(context).see_your_Email_box,style: TextStyle(
                                   color: Colors.white,
                                     fontFamily:'poppinsbold',fontWeight: FontWeight.bold),)),
                             gravity: ToastGravity.BOTTOM,

                             toastDuration: Duration(seconds: 3),
                           );
                         });
                       }
                     }),
               ),
               Container(
                 padding: EdgeInsets.all(5),
                 child: GestureDetector(
                   child: Text(AppLocalizations.of(context).cancel,
                       style: TextStyle(
                         fontSize: 12.5,color: Theme.of(context).primaryColor,
                         fontFamily: 'poppins')),
                   onTap: () =>
                       Navigator.of(context).pop(true),
                 ),
               ),
             ],
           ),
         );
        },
        //Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPass())),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          AppLocalizations.of(context).forget_password,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'poppins',
          ),
        ),
      ),
    );
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
            wrongemailorpass = "0";
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
        onChanged: (v){
          setState(() {
            wrongemailorpass = "0";
          });
        },
        controller: _passwordController,
        obscureText: true,
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
  void _submit(BuildContext context) async{
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signInWithEmailandPassword(_email, _password);
     // final user = await auth.signInWithEmailandPassword(_email, _password);
      _messaging.getToken().then((t){
        print("token is $t");
        FirebaseFirestore.instance.collection("Users").doc(auth.currentUser.uid)
            .collection("tokens").doc("token").set({
          "token": t,
          "createdTime":DateTime.now(),
          "userID":auth.currentUser.uid
        });
      });
      Navigator.pop(context);
    //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Landing()),(route)=>false);
    } on FirebaseAuthException catch(e){
      print(e.toString());
     if(e.toString() == "[firebase_auth/unknown] Given String is empty or null"||
         e.toString()=="[firebase_auth/invalid-email] The email address is badly formatted."||
         e.toString()=="[firebase_auth/wrong-password] The password is invalid or the user does not have a password."||
         e.toString()=="[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."){
       setState(() {
         wrongemailorpass ="1";
       });
     }
     // showExceptionAlertDialog(
     //     context ,
     //     title: 'Sign In Failed',
     //     exception: e
     // );
    }
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
              AppLocalizations.of(context).login,
              style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      ),
      onPressed: () {_submit(context);},
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
      onTap: (){
        _signInWithGoogle(context);
        print("users emails : ${users_emails.length}");
        },
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
      onTap: (){_signInWithFacebook(context);},
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
            Text(AppLocalizations.of(context).welcome_back,
              style: TextStyle(fontSize: size.width * 0.055,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppinsbold'),),
            SizedBox(height: size.height * 0.02,),
            Image.asset("assets/images/b.png",
              height:  size.height*0.3,width:  size.width,),
            SizedBox(height: size.height * 0.05,),
            _buildEmailTF(),
            SizedBox(height: size.height*0.02,),
            _buildPasswordTF(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (wrongemailorpass =="1")?
                Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                    child:Text("Email or password your entered is incorrect",style: TextStyle(fontSize: 12.5,color: Colors.red,fontWeight: FontWeight.bold,fontFamily: 'poppinslight'),)
                ):Container(height: 0,width: 0,),
              ],
            ),
            _buildForgotPasswordBtn(),
            SizedBox(height: size.height*0.02,),
            _bottun(),
            SizedBox(height: size.height*0.04,),
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

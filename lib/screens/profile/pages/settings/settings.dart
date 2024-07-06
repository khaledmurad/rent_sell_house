import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_mate_app/auth/auth.dart';
import 'package:home_mate_app/main.dart';
import 'package:home_mate_app/screens/profile/pages/settings/languages.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  User user;
  SettingsPage({this.user});
  Future<void> _signOut(BuildContext context) async {

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  ll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    L = prefs.getString("mainLang");
  }

  @override
  Widget build(BuildContext context) {
    ll();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: size.height * 0.08,
            left: size.width * 0.07,
            right: size.width * 0.07),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 25,width: 25,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
              ),
              SizedBox(
                height: size.height * 0.035,
              ),
              Text(
                AppLocalizations.of(context).settings,
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
              SizedBox(
                height: size.height * 0.075,
              ),
              GestureDetector(
                onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>
                 LanguagesPage(user: widget.user,lang: L,)));
                },
                child: InkWell(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(LineAwesomeIcons.language,color: Colors.black,size: 25,),
                      SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                      Text(AppLocalizations.of(context).language,style: TextStyle(fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   height: size.height * 0.02,
              // ),
              //
              // SizedBox(
              //   height: size.height * 0.05,
              // ),
              // Column(
              //   children: [
              //     GestureDetector(
              //       onTap: (){
              //         showDialog(
              //             context: context,
              //             builder: (context) => AlertDialog(
              //               title: Text('Delete account',
              //                   style: TextStyle(
              //                       fontSize: 17.5,
              //                       fontWeight: FontWeight.bold,
              //                       fontFamily: 'poppins')),
              //               content: Container(
              //                 height: size.height * 0.1,
              //                 child: Text(
              //                     "Are you sure you wanna delete your account",
              //                     style: TextStyle(
              //                         fontSize: 15,
              //                         fontWeight: FontWeight.bold,
              //                         fontFamily: 'poppins')),
              //               ),
              //               actions: [
              //                 FlatButton(
              //                     onPressed: () {
              //                       //TODO
              //                       main();
              //                       widget._signOut(context);
              //                       FirebaseFirestore.instance
              //                       .collection('Users')
              //                       .doc(widget.user.uid)
              //                       .delete();
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text(AppLocalizations.of(context).sure,
              //                         style: TextStyle(
              //                             fontSize: 12.5,
              //                             fontWeight: FontWeight.bold,
              //                             fontFamily: 'poppins'))),
              //                 FlatButton(
              //                     onPressed: () {
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text(AppLocalizations.of(context).back,
              //                         style: TextStyle(
              //                             fontSize: 12.5,
              //                             fontWeight: FontWeight.bold,
              //                             fontFamily: 'poppins'))),
              //               ],
              //             ));
              //       },
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              //         width: size.width,
              //         decoration: BoxDecoration(
              //             color: Colors.red,
              //             borderRadius: BorderRadius.circular(20)
              //         ),
              //         child: Center(
              //           child: Text(AppLocalizations.of(context).dELETE_ACCOUNT,style: TextStyle(fontFamily: 'poppinsbold',
              //               color: Colors.white,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold)),
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: size.height*0.05,)
              //   ],
              // ),
            ],
          ),
        ),
      ),

    );
  }
String L;
  @override
  Future<void> initState() async {
    super.initState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    L = prefs.getString("mainLang");
  }
}

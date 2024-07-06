import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class NotificationsPage extends StatefulWidget {
  User user;
  NotificationsPage({this.user});
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool Notistatus ;
  @override
  void initState(){
    super.initState();
    _getNotiState();
  }
  _getNotiState() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Notistatus = prefs.getBool("noti_state");
    print("noti_state => $Notistatus");

    return Notistatus;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: _getNotiState(),
          builder: (context ,noti){
            return (noti.hasData)?
            Padding(
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
                      child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    Text(
                      AppLocalizations.of(context).notifications,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinsbold'),
                    ),
                    SizedBox(
                      height: size.height * 0.075,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).notifications,
                          style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins'),
                        ),
                        CupertinoSwitch(
                          value: (noti.data == null)?true:noti.data,
                          onChanged: (value) {
                            setState(() {
                              Notistatus = value;
                              NotificatioState(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ):
            Center(
                child: SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: size.height*0.05,
                )
            );
          }),
    );
  }

  NotificatioState(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("noti_state", state);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/screens/inbox/pages/chats.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Notifications extends StatefulWidget {
  User user;
  Notifications({this.user});
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  _line(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height:  size.height*0.03,
        ),
        SizedBox(
          height:  size.height*0.0015,
          width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(1,0),
                      spreadRadius: 0.5
                  )
                ]
            ),
          ),
        ),
        SizedBox(
          height:  size.height*0.03,
        ),
      ],
    );
  }
  _line1(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height:  size.height*0.03,
        ),
        SizedBox(
          height:  size.height*0.0005,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height:  size.height*0.03,
        ),
      ],
    );
  }
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("notifications")
        .where("reciever",isEqualTo: widget.user.uid)
        .get().then((snapshot){
      snapshot.docs.forEach((element) {
        element.reference.update(<String, dynamic>{
          "read" : "0" ,
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).notifications,
          style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'poppinsbold'),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: EdgeInsets.only(
            top: size.height * 0.03,
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("notifications")
                .where("reciever",isEqualTo: widget.user.uid)
                .orderBy("time",
                descending: true)
                .snapshots(),
            builder: (context,snapshot){
              return (snapshot.hasData)?
              ListView(
                children: snapshot.data.docs.map<Widget>((doc){
                  // ignore: deprecated_member_use
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    width: size.width,
                    padding:  EdgeInsets.only(left: size.width * 0.07,
                  right: size.width * 0.07),
                    margin:  EdgeInsets.only(bottom: size.height * 0.005),
                    height: size.height*0.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doc['notification'],
                          style: TextStyle(
                            color: Colors.black,
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppinsbold'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              doc['time'],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinsbold'),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ):
                  Container(height: 0,);
            },
          )
      ),
    );
  }
}

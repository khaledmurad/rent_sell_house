import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/screens/inbox/pages/chats.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'notifications.dart';

class InboxPage extends StatefulWidget {
  User user;
  InboxPage({this.user});
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  String active = "message";
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Padding(
        padding: EdgeInsets.only(
            top: size.height * 0.02,
            ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: size.width * 0.07,
                    right: size.width * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).messages,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinsbold'),
                    ),
                    // (widget.user!=null)?
                    // StreamBuilder(
                    //   stream: FirebaseFirestore.instance.collection("notifications")
                    //       .where("reciever",isEqualTo: widget.user.uid)
                    //       .orderBy("time",
                    //       descending: true)
                    //       .limit(1)
                    //       .snapshots(),
                    //   builder: (context , snap){
                    //     return (snap.hasData)?
                    //     Column(
                    //       children: snap.data.docs.map<Widget>((doc){
                    //         return (doc['read']=="0")?
                    //         IconButton(icon: Icon(FontAwesomeIcons.bell),
                    //           onPressed: (){
                    //             Navigator.push(context, MaterialPageRoute(builder:
                    //                 (context)=>Notifications(user: widget.user,)));
                    //           },
                    //           highlightColor: Colors.white54,
                    //           splashRadius: 20,)
                    //             :Stack(
                    //           children: [
                    //             IconButton(icon: Icon(FontAwesomeIcons.bell),
                    //               onPressed: (){
                    //                 Navigator.push(context, MaterialPageRoute(builder:
                    //                     (context)=>Notifications(user: widget.user,)));
                    //               },
                    //               highlightColor: Colors.white54,
                    //               splashRadius: 20,),
                    //             Positioned(
                    //               right: size.width*0.02,
                    //               top: size.height*0.0125,
                    //               child: Align(
                    //                 alignment: Alignment.topLeft,
                    //                 child: Container(
                    //                   height: size.height*0.0125,
                    //                   width: size.width*0.025,
                    //                   decoration: BoxDecoration(
                    //                       color: Theme.of(
                    //                           context)
                    //                           .primaryColor,
                    //                       borderRadius:
                    //                       BorderRadius
                    //                           .circular(
                    //                           30)),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         );
                    //       }).toList(),
                    //     )
                    //         :Container(height: 0,);
                    //   },
                    // ):
                        Container(height: 0,)
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.035,
              ),
              ChatsPage(user: widget.user,)
            ],
          ),
        )
      ),
    );
  }
}

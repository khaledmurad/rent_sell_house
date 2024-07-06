import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/notifications/send_notifications.dart';


class MessageHost extends StatefulWidget {
  final Oid;
  final hostid;
  User user;
  MessageHost({this.Oid,this.hostid,this.user});

  @override
  _MessageHostState createState() => _MessageHostState();
}

class _MessageHostState extends State<MessageHost> {
  String hostedName;
  String userName;
  String hostedID;
  String userPhoto;
  String hostedinfo;
  String mesj="";
  FToast fToast;
  String GruopChatID;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.hostid).snapshots().listen((v) {
      v.docs.forEach((element) {
        hostedName = element["name_f"];
        hostedinfo = element['user_info'];
        hostedID = element['id'];
        userPhoto = element['image'];
      });
    });
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.user.uid).snapshots().listen((v) {
      v.docs.forEach((element) {
        userName = element["name_f"];
      });
    });

  }
  _line(BuildContext context) {
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Objects").doc(widget.Oid).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
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
                          child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),
                        ),
                        SizedBox(
                          height: size.height * 0.035,
                        ),
                        Text(
                          "${AppLocalizations.of(context).contact_with} ${hostedName}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppinsbold'),
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Text("${snapshot.data['objname']}",style: TextStyle(fontSize: 15, fontFamily: 'poppinslight'),),
                        SizedBox(height: size.height*0.005,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("${snapshot.data["type"]} . ${snapshot.data['city']}",style: TextStyle(fontSize: 12.5, fontFamily: 'poppinslight'),),
                              ],
                            ),
                            Container(
                              height: size.height*0.125,
                              width: size.width*0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(snapshot.data['image']),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ],
                        ),
                        _line(context),
                        Text(
                          AppLocalizations.of(context).message_the_host,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppinsbold'),
                        ),
                        SizedBox(height: size.height*0.02,),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 0.75,
                                  color: Colors.black45
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
                            child: TextFormField(
                              initialValue: mesj,
                              onChanged: (v) {
                                setState(() {
                                  mesj = v;
                                });
                              },
                              maxLines: 10,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'poppinslight',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    if (widget.user.uid.hashCode <= hostedID.hashCode) {
                      GruopChatID = '${widget.user.uid}-$hostedID';
                    } else {
                      GruopChatID = '$hostedID-${widget.user.uid}';
                    }
                    if(mesj.length>9){
                      Random rnd = Random();
                      var rnd1 = rnd.nextInt(500000000).toString();
                      var msgNO = rnd.nextInt(500000000).toString();
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(GruopChatID)
                          .collection(GruopChatID)
                          .doc(rnd1)
                          .set({
                        "is_read":"0",
                        "id":"$rnd1",
                        "type":0,
                        "send_ID":widget.user.uid,
                        'reserver_ID': hostedID,
                        'msg':mesj,
                        'msgTime':DateTime.now().millisecondsSinceEpoch.toString()
                      });
                      SendNotifi().sendNotification(hostedID,"chat",GruopChatID,mesj,userName);
                      FirebaseFirestore.instance.collection('chats').
                          doc(GruopChatID).set({
                        "chat_id":GruopChatID,
                        "users":[widget.user.uid, hostedID
                        ],
                        'lastTime':DateTime.now().millisecondsSinceEpoch.toString()
                      });
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(GruopChatID)
                          .get().then((value) {
                        value.reference.update(<String,dynamic>{
                          'lastTime':DateTime.now().millisecondsSinceEpoch.toString()
                        });
                      });
                      Navigator.pop(context);
                      fToast.showToast(
                        child: Padding(
                          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                          child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Theme.of(context).highlightColor,
                              ),
                              child: Text(AppLocalizations.of(context).thankU,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                        ),
                        gravity: ToastGravity.TOP,

                        toastDuration: Duration(seconds: 2),
                      );
                    }
                  },
                  child:(mesj.length>9)? Container(
                    width: size.width*0.25,
                    height: size.height*0.06,
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(7.5),
                        border: Border.all(
                            width: 0.5,
                            color: Colors.black54
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Center(
                          child: Text(AppLocalizations.of(context).send_message,style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 15,fontWeight: FontWeight.bold),)),
                    ),
                  ): Container(
                    width: size.width*0.25,
                    height: size.height*0.06,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(7.5),
                        border: Border.all(
                            width: 0.5,
                            color: Colors.black54
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Center(
                          child: Text(AppLocalizations.of(context).send_message,style: TextStyle(
                              fontFamily: 'poppins',color: Colors.white,
                              fontSize: 15,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ),
              ),
            );
          }else{return Container();}
        }
    );
  }
}

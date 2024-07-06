import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate_app/auth/auth.dart';
import 'package:home_mate_app/auth/login.dart';
import 'package:home_mate_app/screens/inbox/pages/msgScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatsPage extends StatefulWidget {
  User user;
  ChatsPage({this.user});
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  String GroupChatID;
  List chats = [];
  String HostID;
  String isRead="1";

  QuerySnapshot querySnapshot;

  @override
  void initState() {
    super.initState();
    _W();
    print("chats ${chats}");
    HostID = null;
  }
  _line(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height:  size.height*0.0005,
          width: MediaQuery.of(context).size.width*0.8,
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
  _W() async {
    return await FirebaseFirestore.instance
        .collection("chats")
        .where("users", arrayContains: widget.user.uid)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        setState(() {
          for (int i = 0; i <= 1; ++i) {
            if (element['users'][i] == widget.user.uid) {
               chats.add(element['users'][i]);
              //HostID = element['users'][i];
            }
          }
        });
      });
    });
  }

  Color color;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            widget.user = snapshot.data;
            if (widget.user == null || widget.user.isAnonymous) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(
                      horizontal: size.width*0.07
                    ),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _line(context),
                          Text(AppLocalizations.of(context).login_read_messages_notifications,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width: size.width * 0.25,
                            height: size.height * 0.075,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child: Text(AppLocalizations.of(context).login,style: TextStyle(
                                  color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return _widgetchats();
            }
          } else {
            return Container(
              height: 0,
              width: 0,
            );
          }
        })

    ;
  }

  _widgetchats(){
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _ww(),
      builder: (context, snapshot){
        return ListTile(
          title: (chats.length >0)?StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .where("users", arrayContains: widget.user.uid).orderBy("lastTime",descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return (snapshot.hasData)
                //TODO make sure if it need ListView
                    ? SingleChildScrollView(
                  child: Column(
                    children: snapshot.data.docs.map<Widget>((msg) {
                      for (int i = 0; i <= 1; ++i) {
                        if (msg['users'][i] != widget.user.uid) {
                          HostID = msg['users'][i];
                        }
                      }
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Users")
                              .where("id", isEqualTo: HostID)
                              .snapshots(),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              // ignore: deprecated_member_use
                              return FlatButton(
                                highlightColor: Colors.black12,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MessageScreen(
                                            user: widget.user,
                                            hostID: (msg['users'][0] ==
                                                widget.user.uid)
                                                ? msg['users'][1]
                                                : msg['users'][0],
                                            chatID: msg["chat_id"],
                                          )));

                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.01,
                                      vertical: size.height * 0.01),
                                  child: Column(
                                    children: snap.data.docs.map<Widget>((host) {
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children:[
                                          Row(
                                            children: [
                                              CircleAvatar(backgroundColor: Colors.white,
                                                  radius: 27.5,
                                                  backgroundImage: (host[
                                                  'image'] ==
                                                      "" ||
                                                      host['image'] == null)
                                                      ? AssetImage(
                                                      'assets/images/5.jpg')
                                                      : NetworkImage(
                                                      host['image'])),
                                              SizedBox(
                                                width: size.width * 0.05,
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "${host['name_f']} ${host['name_l']}",
                                                        style: TextStyle(
                                                            fontFamily: 'poppins',
                                                            color: Colors.black,
                                                            fontSize: 17.5,
                                                            fontWeight:
                                                            FontWeight.bold)),
                                                    StreamBuilder(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection("chats")
                                                            .doc(msg["chat_id"])
                                                            .collection(
                                                            "${msg["chat_id"]}")
                                                            .orderBy("msgTime",
                                                            descending: true)
                                                            .limit(1)
                                                            .snapshots(),
                                                        builder: (context, s) {
                                                          if (s.hasData) {
                                                            return Column(
                                                              children: s
                                                                  .data.docs
                                                                  .map<Widget>(
                                                                      (lastMSG) {
                                                                    isRead =
                                                                    "${lastMSG['type']}";
                                                                    return Column(
                                                                      children: [
                                                                        (lastMSG['send_ID'] ==
                                                                            widget
                                                                                .user
                                                                                .uid)
                                                                            ? (lastMSG['type'] ==
                                                                            0)
                                                                            ? (lastMSG['msg'].length > 30)
                                                                            ? Text("${AppLocalizations.of(context).you}: ${lastMSG['msg'].substring(0, 25) + '...'}",maxLines: 1, style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                            : Text("${AppLocalizations.of(context).you}: ${lastMSG['msg']}", maxLines: 1,style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                            : Text("${AppLocalizations.of(context).you}: ${AppLocalizations.of(context).image}", style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                            : (lastMSG['type'] == 0)
                                                                            ? (lastMSG['msg'].length > 30)
                                                                            ? Text("${lastMSG['msg'].substring(0, 25) + '...'}", maxLines: 1,style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                            : Text("${lastMSG['msg']}",maxLines: 1, style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                            : Text("${AppLocalizations.of(context).image}", style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                      ],
                                                                    );
                                                                  }).toList(),
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        })
                                                  ]),
                                            ],
                                          ),
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection("chats")
                                                  .doc(msg["chat_id"])
                                                  .collection("${msg["chat_id"]}")
                                                  .orderBy("msgTime",
                                                  descending: true)
                                                  .limit(1)
                                                  .snapshots(),
                                              builder: (context, s) {
                                                if (s.hasData) {
                                                  return Column(children:
                                                  s.data.docs.map<Widget>(
                                                        (lastMSG) {
                                                      return (lastMSG['is_read'] == "0"&&lastMSG['reserver_ID']==widget.user.uid)
                                                          ? Container(
                                                        height: 12,
                                                        width: 12,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                context)
                                                                .primaryColor,
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                30)),
                                                      )
                                                          : Container(
                                                        height: 0,
                                                        width: 0,
                                                      );
                                                    },
                                                  ).toList());
                                                } else {
                                                  return Container(
                                                    height: 0,
                                                    width: 0,
                                                  );
                                                }
                                              })
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    }).toList(),
                  ),
                )
                    : Container();
              }):
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Image.asset("assets/images/nom.png",height: 200,width: 200,),
                SizedBox(height: 10,),
                Center(child: Text(AppLocalizations.of(context).no_messages,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'poppins',),)),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Widget> _ww() async {
    Size size = MediaQuery.of(context).size;
    if(chats.length >0){
      await new Future.delayed(const Duration(seconds: 5));
      return  StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .where("users", arrayContains: widget.user.uid).orderBy("lastTime",descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? SingleChildScrollView(
              child: Column(
                children: snapshot.data.docs.map<Widget>((msg) {
                  for (int i = 0; i <= 1; ++i) {
                    if (msg['users'][i] != widget.user.uid) {
                      HostID = msg['users'][i];
                    }
                  }
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .where("id", isEqualTo: HostID)
                          .snapshots(),
                      builder: (context, snap) {
                        if (snap.hasData) {
                          // ignore: deprecated_member_use
                          return FlatButton(
                            highlightColor: Colors.black12,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MessageScreen(
                                        user: widget.user,
                                        hostID: (msg['users'][0] ==
                                            widget.user.uid)
                                            ? msg['users'][1]
                                            : msg['users'][0],
                                        chatID: msg["chat_id"],
                                      )));

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.01,
                                  vertical: size.height * 0.01),
                              child: Column(
                                children: snap.data.docs.map<Widget>((host) {
                                  return Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 27.5,
                                              backgroundImage: (host[
                                              'image'] ==
                                                  "" ||
                                                  host['image'] == null)
                                                  ? AssetImage(
                                                  'assets/images/5.jpg')
                                                  : NetworkImage(
                                                  host['image'])),
                                          SizedBox(
                                            width: size.width * 0.05,
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${host['name_f']} ${host['name_l']}",
                                                    style: TextStyle(
                                                        fontFamily: 'poppins',
                                                        color: Colors.black,
                                                        fontSize: 17.5,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                                StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection("chats")
                                                        .doc(msg["chat_id"])
                                                        .collection(
                                                        "${msg["chat_id"]}")
                                                        .orderBy("msgTime",
                                                        descending: true)
                                                        .limit(1)
                                                        .snapshots(),
                                                    builder: (context, s) {
                                                      if (s.hasData) {
                                                        return Column(
                                                          children: s
                                                              .data.docs
                                                              .map<Widget>(
                                                                  (lastMSG) {
                                                                isRead =
                                                                "${lastMSG['type']}";
                                                                return Column(
                                                                  children: [
                                                                    (lastMSG['send_ID'] ==
                                                                        widget
                                                                            .user
                                                                            .uid)
                                                                        ? (lastMSG['type'] ==
                                                                        0)
                                                                        ? (lastMSG['msg'].length > 30)
                                                                        ? Text("${AppLocalizations.of(context).you}: ${lastMSG['msg'].substring(0, 25) + '...'}",maxLines: 1, style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                        : Text("${AppLocalizations.of(context).you}: ${lastMSG['msg']}", maxLines: 1,style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                        : Text("${AppLocalizations.of(context).you}: ${AppLocalizations.of(context).image}", style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                        : (lastMSG['type'] == 0)
                                                                        ? (lastMSG['msg'].length > 30)
                                                                        ? Text("${lastMSG['msg'].substring(0, 25) + '...'}", maxLines: 1,style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                        : Text("${lastMSG['msg']}",maxLines: 1, style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                        : Text("${AppLocalizations.of(context).image}", style: TextStyle(fontFamily: 'poppinslight', color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.bold))
                                                                  ],
                                                                );
                                                              }).toList(),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    })
                                              ]),
                                        ],
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("chats")
                                              .doc(msg["chat_id"])
                                              .collection("${msg["chat_id"]}")
                                              .orderBy("msgTime",
                                              descending: true)
                                              .limit(1)
                                              .snapshots(),
                                          builder: (context, s) {
                                            if (s.hasData) {
                                              return Column(children:
                                              s.data.docs.map<Widget>(
                                                    (lastMSG) {
                                                  return (lastMSG['is_read'] == "0"&&lastMSG['reserver_ID']==widget.user.uid)
                                                      ? Container(
                                                    height: 12,
                                                    width: 12,
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(
                                                            context)
                                                            .primaryColor,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            30)),
                                                  )
                                                      : Container(
                                                    height: 0,
                                                    width: 0,
                                                  );
                                                },
                                              ).toList());
                                            } else {
                                              return Container(
                                                height: 0,
                                                width: 0,
                                              );
                                            }
                                          })
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      });
                }).toList(),
              ),
            )
                : Container();
          });
    }else{
      return Center(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Image.asset("assets/images/nom.png",height: 50,width: 50,),
            SizedBox(height: 10,),
            Center(child: Text(AppLocalizations.of(context).no_result,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'poppins',),)),
          ],
        ),
      );}
  }
}

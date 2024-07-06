import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/notifications/send_notifications.dart';
import 'package:home_mate_app/screens/profile/pages/main_profile/MainProfile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MessageScreen extends StatefulWidget {
  User user;
  final chatID;
  final hostID;
  MessageScreen({this.user,this.chatID,this.hostID});
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  DateTime date;
  DateTime today=DateTime.now();
  String NM,_date;
  final TextEditingController newMsg = new TextEditingController();
  String get _newMsg => newMsg.text;
  String HostName;
  String userName;
  String Hostimage;
  File _image;
  final picker = ImagePicker();
  String mesj;
  Color color;
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo: widget.hostID).snapshots().listen((e){
      e.docs.forEach((element) {
        HostName = "${element['name_f']} ${element['name_l']}";
        Hostimage = "${element['image']}";
      });
    });
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo: widget.user.uid).snapshots().listen((e){
      e.docs.forEach((element) {
        userName = "${element['name_f']}";
      });
    });
    FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatID)
        .collection(widget.chatID)
        .where("reserver_ID",isEqualTo: widget.user.uid).get().then((snapshot){
      snapshot.docs.forEach((element) {
        element.reference.update(<String, dynamic>{
          "is_read" : "1" ,
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chats")
          .doc(widget.chatID)
          .collection(widget.chatID)
          .orderBy("msgTime",descending: true)
          .snapshots(),
        builder: (context,snapshot){
        if(snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding:  EdgeInsets.only(left: size.width*0.02 ),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,color: Colors.black,),
                ),
              ),
              title: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MainProfile(
                    user: widget.user,Guser: widget.hostID,
                  )));
                },
                highlightColor: Colors.white10,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        radius:17.5,
                        backgroundImage:
                        (Hostimage == ""||Hostimage == null)?
                        AssetImage(
                            'assets/images/5.jpg'):
                        NetworkImage(Hostimage)),
                    SizedBox(width: size.width*0.025,),
                    Text("$HostName",style: TextStyle(fontFamily: 'poppins',
                      color: Colors.black,
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold)),
                  ],
                ),
              ),backgroundColor: Colors.white,),
            body: Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
                      width: size.width*0.8,
                      //  height: size.height*0.06,
                      decoration: BoxDecoration(
                          color: Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              width: 0.5,
                              color: Colors.black54
                          )
                      ),
                      child:TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: newMsg,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'poppinslight',
                            fontWeight: FontWeight.bold
                        ),
                        decoration: InputDecoration(
                          suffixIcon:IconButton(
                            icon: Icon(FontAwesomeIcons.image), onPressed: () {_addMsgImage();},
                            highlightColor: Colors.grey,splashRadius: 20,color: Theme.of(context).highlightColor,
                          ),
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context).new_message,
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'poppinslight',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width*0.02,),
                    GestureDetector(
                      onTap: (){
                        Random r=Random();
                        int _seed= r.nextInt(999999999);
                        if(_newMsg.length>0&&(_newMsg.contains(new RegExp(r'[A-Z]'))||_newMsg.contains(new RegExp(r'[\u0600-\u06FF]'))||_newMsg.contains(new RegExp(r'[0-9]'))
                            ||_newMsg.contains(new RegExp(r'[a-z]'))||_newMsg.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')))){
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(widget.chatID)
                              .collection(widget.chatID)
                              .doc("$_seed")
                              .set({
                            "is_read":"0",
                            "id":"$_seed",
                            "type":0,
                            "send_ID":widget.user.uid,
                            'reserver_ID': widget.hostID,
                            'msg':capitalize(_newMsg),
                            'msgTime':DateTime.now().millisecondsSinceEpoch.toString()
                          });

                          SendNotifi().sendNotification(widget.hostID,"chat",widget.chatID,_newMsg,userName);
                          FirebaseFirestore.instance
                              .collection('chats')
                              .doc(widget.chatID)
                              .get().then((value) {
                            value.reference.update(<String,dynamic>{
                              'lastTime':DateTime.now().millisecondsSinceEpoch.toString()
                            });
                          });
                          newMsg.clear();
                        }
                      },
                      child: Container(
                        height: size.height*0.06,
                        width: size.width*0.125,
                        decoration: BoxDecoration(
                            color:Theme.of(context).highlightColor,
                            borderRadius: BorderRadius.circular(35)
                        ),
                        child: Icon(FontAwesomeIcons.solidPaperPlane,size: 20,),
                      ),
                    )
                  ],
                ),
              ),
              body: ListView(
                reverse: true,
                children: snapshot.data.docs.map<Widget>((msgs){
                      date =DateTime.fromMillisecondsSinceEpoch(int.parse(msgs['msgTime']));
                      return GestureDetector(
                        onTap: (){
                          if(msgs["type"]==1){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> openImage(msgs['image'])));
                          }
                        },
                        onLongPress:(msgs["send_ID"]==widget.user.uid)? (){
                          showModalBottomSheet(context: context,
                              builder: (BuildContext context){
                            return _SheetMsgs(msgs['id'],msgs['msg']);
                          });
                        }:(){
                          showModalBottomSheet(context: context,
                              builder: (BuildContext context){
                                return _SheetMsgsaway(msgs['msg']);
                              });
                        },
                        child: Container(
                          padding:(msgs["send_ID"]==widget.user.uid)? EdgeInsets.only(top: size.height*0.01,bottom: 1,
                              right: size.width*0.02,left: size.width*0.015):
                          EdgeInsets.only(top: size.height*0.01,bottom: 1,right: size.width*0.015,left: size.width*0.02),
                          width: size.width,
                          alignment: (msgs["send_ID"]==widget.user.uid)?Alignment.centerRight:Alignment.centerLeft,
                          child:(msgs["send_ID"]==widget.user.uid)?
                          Container(
                              padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.025),
                              decoration: BoxDecoration(
                                  color:Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft:Radius.circular(15) ,topRight: Radius.circular(15),bottomLeft: Radius.circular(15)
                                  )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (msgs['type']!=1)?
                                  Text("${msgs["msg"]}",style: TextStyle(fontFamily: 'poppinslight',
                                      color: Colors.black,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold)):
                                  Container(
                                      height: size.height*0.25,
                                      width: size.width*0.35,
                                      child: Image.network(msgs["image"],fit: BoxFit.cover,)),

                                  SizedBox(width: size.width*0.02,),
                                  Text("${_MonthsName(date.month)}${date.day} - ${DateFormat('HH:mm').format(date)}",style: TextStyle(fontFamily: 'poppinslight',
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                                ],
                              )):Container(
                                  padding: EdgeInsets.symmetric(vertical: size.height*0.01,horizontal: size.width*0.025),
                                  decoration: BoxDecoration(
                                      color:Color(0xFFEEEEEE),
                                      borderRadius:BorderRadius.only(
                                          topLeft:Radius.circular(15) ,topRight: Radius.circular(15),bottomRight: Radius.circular(15)
                                      )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      (msgs['type']!=1)?
                                      Text("${msgs["msg"]}",style: TextStyle(fontFamily: 'poppinslight',
                                          color: Colors.black,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold)):
                                      Container(
                                          height: size.height*0.25,
                                          width: size.width*0.35,
                                          child: Image.network(msgs["image"],fit: BoxFit.cover,)),
                                      SizedBox(width: size.width*0.02,),
                                      Text("${_MonthsName(date.month)}${date.day} - ${DateFormat('kk:mm').format(date)}",style: TextStyle(fontFamily: 'poppinslight',
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                    ],
                                  )),
                        ),
                      );
                    }).toList(),
              ),
            ),
          );
        }else{return Container();}
        });
  }

  _MonthsName(int d){
    switch(d){
      case 1 :return "Jan";break;
      case 2 :return "Feb";break;
      case 3 :return "Mar";break;
      case 4 :return "Apr";break;
      case 5 :return "May";break;
      case 6 :return "Jun";break;
      case 7 :return "Jul";break;
      case 8 :return "Aug";break;
      case 9 :return "Sep";break;
      case 10 :return "Oct";break;
      case 11 :return "Nov";break;
      case 12 :return "Des";break;

    }
  }
Random rnd=Random();
  String Homeimg;
 Future _addMsgImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        Random r=Random();
        int _seed= r.nextInt(999999999);
        _image = File(pickedFile.path);
        int _sed= rnd.nextInt(999999999);
        Reference ref = FirebaseStorage.instance.ref().child("${widget.chatID}/$_sed.png");
        final UploadTask UPloadTask = ref.putFile(_image);
        UPloadTask.whenComplete(() async {
          Homeimg = await UPloadTask.snapshot.ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatID)
            .collection(widget.chatID)
            .doc(DateTime.now().millisecondsSinceEpoch.toString())
            .set({
          "is_read":"0",
          "id":"$_seed",
          "type":1,
          "send_ID":widget.user.uid,
          'reserver_ID': widget.hostID,
          'image':Homeimg,
          'msgTime':DateTime.now().millisecondsSinceEpoch.toString()
        });
        });
        SendNotifi().sendNotification(widget.hostID,"chat",widget.chatID,AppLocalizations.of(context).sent_photo,userName);
        FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatID)
            .get().then((value) {
          value.reference.update(<String, dynamic>{
            'lastTime': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString()
          });
          });
      } else {
        print('No image selected.');
      }
    });
  }


  _SheetMsgs(id,msg){
   Size size=MediaQuery.of(context).size;
   return Container(
     width: size.width,
     height: size.height*0.07,
     // ignore: deprecated_member_use
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: [
         GestureDetector(
           onTap: (){
             Clipboard.setData(new ClipboardData(text: msg));
             Navigator.pop(context);
           }, child: Text(AppLocalizations.of(context).copy,style: TextStyle(fontFamily: 'poppins',
             color: Colors.black,
             fontSize: 17.5,
             fontWeight: FontWeight.bold)),
           ),
         GestureDetector(
             onTap: (){
               FirebaseFirestore.instance
                   .collection('chats')
                   .doc(widget.chatID)
                   .collection(widget.chatID)
                   .doc(id).delete();
               Navigator.pop(context);
             }, child: Text(AppLocalizations.of(context).delete,style: TextStyle(fontFamily: 'poppins',
             color: Colors.black,
             fontSize: 17.5,
             fontWeight: FontWeight.bold)),
         ),
       ],
     ),
   );
  }

  _SheetMsgsaway(msg){
    Size size=MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height*0.07,
      // ignore: deprecated_member_use
      child: Center(
        child: GestureDetector(
          onTap: (){
            Clipboard.setData(new ClipboardData(text: msg));
            Navigator.pop(context);
          }, child: Text(AppLocalizations.of(context).copy,style: TextStyle(fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 17.5,
            fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
class openImage extends StatefulWidget {
  final image;
  openImage(this.image);
  @override
  _State createState() => _State();
}

class _State extends State<openImage> {
  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white,title: Text("Image",style: TextStyle(fontFamily: 'poppins',
            color: Colors.black,
            fontSize: 17.5,
            fontWeight: FontWeight.bold)),),
        body: Container(
          width: size.width,
          height: size.height,
          child: Image.network(widget.image,fit: BoxFit.fill,),
        )
    );
  }

}


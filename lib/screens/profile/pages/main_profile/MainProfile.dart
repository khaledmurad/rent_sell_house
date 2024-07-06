import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:home_mate_app/controllers/reviews_controller.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/models/reviews.dart';
import 'package:home_mate_app/screens/profile/pages/main_profile/report_user.dart';
import 'package:intl/intl.dart';

class MainProfile extends StatefulWidget {
  User user;
  final Guser;
  MainProfile({this.user,this.Guser});
  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {

  String hostedName,userPhoto,phone,userInfo,mesj="",GruopChatID;
  DateTime joined;
  List<String> objects;
  FToast fToast;
  final Future<Widget> _calculation = Future<Widget>.delayed(
      const Duration(seconds: 1),
          () {
        return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF3EBACE),
            ));
      }
  );
  @override
  void initState() {
    super.initState();
    setState(() {
      objects =[];
      fToast = FToast();
      fToast.init(context);
      FirebaseFirestore.instance
          .collection("Users")
          .where("id", isEqualTo: widget.Guser)
          .snapshots()
          .listen((v) {
        v.docs.forEach((element) {
          hostedName = "${element["name_f"]} ${element["name_l"]}";
          userPhoto = element['image'];
          phone = element['phone'];
          userInfo = element['user_info'];
          joined = element['sginupdate'].toDate();

        });
      });
      FirebaseFirestore.instance.collection("Objects")
          .where("objState",isEqualTo: "Active")
          .where("ADID",isEqualTo: widget.Guser)
          .snapshots()
          .listen((v) {
        v.docs.forEach((element) {
          objects.add("id");
        });
      });
    });
  }
  var reviews = List<Review>();
  final reviewcontroller = Get.put(reviewController());
  List<dynamic> Listrate = [];
  var allrate = [];
  double sumRate = 0.0;
  _buildRatingStars(double rating, double persons) {
    String stars = '${(rating / persons).toStringAsFixed(1)}';
    stars.trim();
    return Row(
      children: [
        Icon(Icons.star , color: Colors.amber,size: 17.5,),
        Text(
            stars,
            style:TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'poppins')
        ),
      ],
    );
  }
  Widget _widgetRate(id) {
//      return _buildRatingStars( sumRate.toDouble(),Listrate.length.toDouble());
    //Listrate.clear();
    sumRate=0.0;
    reviews =
        reviewcontroller.review.where((e) => (e.hostID == id))
            .toList();

    Listrate = allrate.where((element) {
      // sumRate = sumRate +element['rate'];
      return (element['id'] == id);
    }).toList();
    for(int i=0 ;i<reviews.length;i++){
      sumRate = sumRate +reviews[i].rate;
    }
    //return ;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: _calculation,
        builder: (context , fut){
         return (fut.hasData)?
         Column(
           children: [
             Padding(
               padding: EdgeInsets.only(
                   left: size.width * 0.07,
                   right: size.width * 0.07),
               child: Container(
                 height: size.height,
                 child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     SizedBox(
                       height: size.height * 0.05,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         GestureDetector(
                             onTap: () {
                               Navigator.of(context).pop();
                             },
                             child: Container(
                               height: 25,width: 25,
                               decoration: BoxDecoration(
                                   color: Colors.transparent,
                                   borderRadius: BorderRadius.circular(50)
                               ),
                               child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,
                                 color: Colors.black,),)
                         ),
                         PopupMenuButton(
                             icon: Icon(FontAwesomeIcons.stream,size: 17.5,
                               color: Colors.black,),
                             itemBuilder: (context)=><PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                 value: 'report',
                                 child: Text(AppLocalizations.of(context).report_user,style: TextStyle(fontFamily: 'poppins',
                                     color: Colors.black,
                                     fontSize: 15,
                                     )),
                               ),
                             ],
                           iconSize: 17.5,
                           elevation: 20,
                           onSelected: (String result) {
                             switch (result) {
                               case 'report':
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportUserPage(user: widget.user,
                                 hostid: widget.Guser,)));
                                 break;
                               default:
                             }
                           },
                         )
                       ],
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             SizedBox(
                               height: size.height * 0.01,
                             ),
                             Container(
                               height: size.height*0.1,width: size.width*0.2,
                               child: CircleAvatar(
                                   radius:30,
                                   backgroundImage:
//                                null == photoUrl
//                                    ? ((snapshot.data["image"] == "")
//                                    ?
                                   (userPhoto == ""||userPhoto == null)?
                                   AssetImage(
                                       'assets/images/5.jpg'):
                                   NetworkImage(userPhoto)),
                             ),
                             SizedBox(
                               height: size.height * 0.01,
                             ),
                             Text("$hostedName",style: TextStyle(fontFamily: 'poppinsbold',
                                 color: Colors.black,
                                 fontSize: 20,
                                 fontWeight: FontWeight.bold),),
                               (phone != ""&&phone!=null)?
                                   Column(
                                     children: [
                                       SizedBox(
                                         height: size.height * 0.007,
                                       ),
                                       Row(
                                         children: [
                                           Text("+90 $phone",style: TextStyle(fontFamily: 'poppinsbold',
                                               color: Colors.black,
                                               fontSize: 17.5,
                                               fontWeight: FontWeight.bold),),
                                           IconButton(
                                             onPressed: (){
                                               Clipboard.setData(new ClipboardData(text: "+90$phone"));
                                               fToast.showToast(
                                                 child: Padding(
                                                   padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                                                   child: Container(
                                                       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                                       decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(25.0),
                                                         color: Colors.black,
                                                       ),
                                                       child: Text(AppLocalizations.of(context).copied_to_Clipboard,
                                                         style: TextStyle(
                                                             color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                                                 ),
                                                 gravity: ToastGravity.BOTTOM,

                                                 toastDuration: Duration(seconds: 2),
                                               )
                                               ;
                                             },
                                             icon: Icon(Icons.copy),
                                             highlightColor: Colors.black12,
                                             splashRadius: 20,
                                           ),
                                         ],
                                       ),
                                     ],
                                   ):Container(height: 0,width: 0,)
                           ],
                         ),
                       ],
                     ),
                     SizedBox(
                       height: size.height * 0.015,
                     ),
                     (userInfo != "" || userInfo !=null)?
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("$userInfo",style: TextStyle(fontFamily: 'poppins',
                             color: Colors.black,
                             fontSize: 15,
                             fontWeight: FontWeight.bold),),
                         SizedBox(
                           height: size.height * 0.015,
                         ),
                       ],
                     ):
                     Container(height: 0,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         InkWell(
                           borderRadius: BorderRadius.circular(12.5),
                           highlightColor: Colors.white70,
                           onTap: (){
                             setState(() {
                               (widget.user!=null)?
                               showModalBottomSheet<void>(
                                 isScrollControlled: true,
                                 enableDrag: true,
                                 //useRootNavigator: true,
                                 context: context,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                 ),
                                 builder: (BuildContext context) {
                                   return _showModalBottomSheetContainer();
                                 },
                               ):fToast.showToast(
                                 child: Padding(
                                   padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                                   child: Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(25.0),
                                         color: Theme.of(context).primaryColor,
                                       ),
                                       child: Text(AppLocalizations.of(context).login_first,
                                         style: TextStyle(
                                             color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                                 ),
                                 gravity: ToastGravity.BOTTOM,

                                 toastDuration: Duration(seconds: 2),
                               )
                               ;
                             });
                           },
                           child: Container(
                             width: size.width*0.8,
                             padding: EdgeInsets.symmetric(horizontal: size.width*0.01,vertical: size.height*0.0075),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(7.5),
                                 color: Theme.of(context).primaryColor
                             ),
                             child: Center(
                               child: Text(
                                 AppLocalizations.of(context).message,
                                 style: TextStyle(fontFamily: 'poppinsbold',color: Colors.white,
                                     fontWeight: FontWeight.bold, fontSize: 17.5),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                     (objects.length>0)?
                         _WidgetObjects():
                         Container(height: 0,)
                   ],
                 ),
               ),
             ),
           ],
         )
             :Center(
             child: SpinKitChasingDots(
               color: Theme.of(context).primaryColor,
               size: size.height*0.05,
             ));
        },
      ),
    );
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
  _showModalBottomSheetContainer(){
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
        builder: (context ,StateSetter setState)
    {
      return Container(
        margin: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom),
        padding: EdgeInsets.only(top: size.height * 0.03,),
        width: size.width,
        height: size.height * 0.55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      FontAwesomeIcons.times,
                      size: 15,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Text(
                    "Message",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            SizedBox(
              height: size.height * 0.001,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                color: Colors.black54,
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.07,
                  right: size.width * 0.07),
              child: Text(
                "Message",
                style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
            ),
            SizedBox(height: size.height * 0.015,),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.07,
                  right: size.width * 0.07),
              child: Text(
                "contect with",
                style: TextStyle(fontFamily: 'poppinslight',
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(height: size.height * 0.025,),
            Padding(
                padding: EdgeInsets.only(left: size.width * 0.07,
                    right: size.width * 0.07),
                child: Row(
                  children: [
                    Container(
                      //  height: size.height*0.07,width: size.width*0.2,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                          (userPhoto == "" || userPhoto == null) ?
                          AssetImage(
                              'assets/images/5.jpg') :
                          NetworkImage(userPhoto)
                      ),
                    ),
                    SizedBox(width: size.width * 0.035,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$hostedName', style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.5,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold),),
                        Text("Joined in ${_MonthsName(joined.month)} ${joined
                            .year}", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 12.5,
                            fontFamily: 'poppinslight'))
                      ],
                    )
                  ],
                )
            ),
            SizedBox(height: size.height * 0.02,),
            Padding(
                padding: EdgeInsets.only(left: size.width * 0.07,
                    right: size.width * 0.07),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 0.75,
                          color: Colors.black45
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 1),
                    child: TextFormField(
                      initialValue: mesj,
                      onChanged: (v) {
                        setState(() {
                          mesj = v;
                        });
                      },
                      maxLines: 4,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'poppins',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Hi $hostedName ...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  ),
                )
            ),
            SizedBox(height: size.height * 0.02,),
            Padding(
                padding: EdgeInsets.only(left: size.width * 0.07,
                    right: size.width * 0.07),
                child: GestureDetector(
                  onTap: () {
                    if (widget.user.uid.hashCode <= widget.Guser.hashCode) {
                      GruopChatID = '${widget.user.uid}-${widget.Guser}';
                    } else {
                      GruopChatID = '${widget.Guser}-${widget.user.uid}';
                    }
                    if (mesj.length > 0) {
                      Random rnd = Random();
                      var rnd1 = rnd.nextInt(500000000).toString();
                      var msgNO = rnd.nextInt(500000000).toString();
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(GruopChatID)
                          .collection(GruopChatID)
                          .doc(rnd1)
                          .set({
                        "is_read": "0",
                        "id": "$rnd1",
                        "type": 0,
                        "send_ID": widget.user.uid,
                        'reserver_ID': widget.Guser,
                        'msg': mesj,
                        'msgTime': DateTime
                            .now()
                            .millisecondsSinceEpoch
                            .toString()
                      });
                      FirebaseFirestore.instance.collection('chats').
                      doc(GruopChatID).set({
                        "chat_id": GruopChatID,
                        "users": [widget.user.uid, widget.Guser
                        ],
                        'lastTime': DateTime
                            .now()
                            .millisecondsSinceEpoch
                            .toString()
                      });
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(GruopChatID)
                          .get().then((value) {
                        value.reference.update(<String, dynamic>{
                          'lastTime': DateTime
                              .now()
                              .millisecondsSinceEpoch
                              .toString()
                        });
                      });
                      Navigator.pop(context);
                      fToast.showToast(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery
                              .of(context)
                              .size
                              .height * .025),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Theme
                                    .of(context)
                                    .primaryColor,
                              ),
                              child: Text("Message sent", style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins'),)),
                        ),
                        gravity: ToastGravity.TOP,

                        toastDuration: Duration(seconds: 2),
                      );
                    }
                  },
                  child: (mesj.length > 0) ? Container(
                    width: size.width,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Center(
                          child: Text("Send message", style: TextStyle(
                              fontFamily: 'poppins', color: Colors.white,
                              fontSize: 15, fontWeight: FontWeight.bold),)),
                    ),
                  ) : Container(
                    width: size.width,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(7.5),

                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Center(
                          child: Text("Send message", style: TextStyle(
                              fontFamily: 'poppins', color: Colors.white,
                              fontSize: 15, fontWeight: FontWeight.bold),)),
                    ),
                  ),
                )
            ),
          ],
        ),
      );
    });
  }

  _WidgetObjects(){
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Objects")
          .where("objState",isEqualTo: "Active")
          .where("ADID",isEqualTo: widget.Guser).snapshots(),
      builder: (context , snapshot){
        if(snapshot.hasData){
          return Padding(
            padding: EdgeInsets.only(bottom: size.height*0.05),
            child: Column(
              children: snapshot.data.docs
                  .map<Widget>((doc){
                _widgetRate(doc["id"]);
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDescription(id: doc['id'],objOwner: doc['ADID'],
                      user: widget.user,)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(top:20),
                    height: size.height*0.4,width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                    image: NetworkImage(doc['image']),
                                    fit: BoxFit.cover
                                )
                            ),
                          ),
                        ),
                        SizedBox(height: size.height*0.01,),
                        (reviews.length != 0)?
                        _buildRatingStars(sumRate, double.parse("${reviews.length}")):
                        Container(height: 0,),
                        SizedBox(height: size.height*0.01,),
                        Text("${doc["type"]} . ${doc['city']}",style: TextStyle(fontFamily: 'poppins',fontSize: 20,fontWeight: FontWeight.w600),),
                        SizedBox(height: size.height*0.005,),
                        Text("${doc['objname']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,fontFamily: 'poppins'),),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }else{
          return Container();
        }
      },
    );
  }
}
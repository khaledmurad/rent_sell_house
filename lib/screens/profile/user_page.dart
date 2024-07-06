import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/auth/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_mate_app/auth/signup.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_mate_app/main.dart';
import 'package:home_mate_app/screens/profile/pages/contactus/contact_us.dart';
import 'package:home_mate_app/screens/profile/pages/contactus/send_msj_to_admin.dart';
import 'package:home_mate_app/screens/profile/pages/feedback.dart';
import 'package:home_mate_app/screens/profile/pages/notification.dart';
import 'file:///C:/AndroidStudioProjects/home_mate_app/lib/screens/profile/pages/addCC/payments.dart';
import 'package:home_mate_app/screens/profile/pages/personal_info.dart';
import 'file:///C:/AndroidStudioProjects/home_mate_app/lib/screens/profile/pages/reserv_app/reserv_application.dart';
import 'file:///C:/AndroidStudioProjects/home_mate_app/lib/screens/profile/pages/reservations/reservation.dart';
import 'package:home_mate_app/screens/profile/pages/saved.dart';
import 'package:home_mate_app/screens/profile/pages/waiting_approve/waiting_approved.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'file:///C:/AndroidStudioProjects/home_mate_app/lib/screens/profile/pages/offers/your_offers.dart';
import 'package:provider/provider.dart';
import 'pages/settings/settings.dart';

import '../home.dart';


class UserPage extends StatefulWidget {
  User user;
  UserPage({@required this.user});
  Future<void> _signOut(BuildContext context) async {

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  _line(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height:  size.height*0.015,
        ),
        SizedBox(
          height:  size.height*0.0005,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height:  size.height*0.015,
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
    // TODO: implement initState
    super.initState();
    _imageLoding = false;
    _stutes ='';
    imagePicker = ImagePicker();
    // print("pro ${widget.user}");
    print("there's no problem in initstate");
  }
  PickedFile _image;
  ImagePicker imagePicker;
  bool _imageLoding;
  String _stutes, photoUrl;
  _buttonn(String logo) {
    return GestureDetector(
        onTap: () {
          _img =null;
          FirebaseFirestore.instance.collection("Users").where("id", isEqualTo: widget.user.uid).get().then((snapshot){
            snapshot.docs.first.reference.update(<String, dynamic>{
              "image" : "" ,
            });
          });
          Navigator.pop(context);
        },
        child: Container(

          child: Text(logo,style: TextStyle(fontSize: 15,fontFamily: 'poppins',color: Colors.black),),

        ));

  }
  Random rnd = Random();
  _button(String logo, ImageSource imageSource) {
    return GestureDetector(
        onTap: () async {
          setState(() {
            _imageLoding = true;
          });
          await _Lodingimage(imageSource);
          int _sed= rnd.nextInt(999999999);
          setState(() async {
            _imageLoding = false;
            _stutes = 'Loaded';
            final Reference firebaseStorageRef =
            FirebaseStorage.instance
                .ref()
                .child("profileImages/${widget.user.uid}/$_sed");
            final UploadTask task =
            firebaseStorageRef.putFile(_img);
            task.whenComplete(() async {
              photoUrl = await task.snapshot.ref.getDownloadURL();
              FirebaseFirestore.instance.collection("Users").where("id", isEqualTo: widget.user.uid).get().then((snapshot){
                snapshot.docs.first.reference.update(<String, dynamic>{
                  "image" : photoUrl ,
                });
              });

            });
          });

          Navigator.pop(context);

        },
        child: Container(
          child: Text(logo,style: TextStyle(fontSize: 15,fontFamily: 'poppins',color: Colors.black),),
        ));
  }
  FirebaseStorage storage = FirebaseStorage.instance;
  File _img;
  Future<PickedFile> _Lodingimage(ImageSource imageSource) async {
    final file = await imagePicker.getImage(source: imageSource);
    setState(() {
      if (file != null) {
        _img = File(file.path) ;
      } else {
        print('No image selected.');
      }
    });
  }
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return Padding(
                padding: EdgeInsets.only(top:size.height*0.035),
                child: ListView(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       AppLocalizations.of(context).profile,
                    //       style: TextStyle(
                    //           fontSize: 25,
                    //           color: Theme.of(context).primaryColor,
                    //           fontWeight: FontWeight.bold,
                    //           fontFamily: 'poppinsbold'),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: size.height*0.03,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width*.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: size.height*0.15,width: size.width*0.3,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                    radius:size.height*0.075,
                                    backgroundImage:
                                    (_img ==null)?
                                    (snapshot.data['image'] == ""||snapshot.data['image'] == null)?
                                    AssetImage(
                                        'assets/images/5.jpg'):
                                    NetworkImage(snapshot.data['image']):
                                    FileImage(_img)
                                ),
                                // Align(
                                //   alignment: Alignment.bottomRight,
                                //   child: GestureDetector(
                                //     onTap: (){
                                //       showModalBottomSheet<void>(
                                //           shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.only(
                                //                 topLeft: Radius.circular(15.0),
                                //                 topRight: Radius.circular(15.0)),
                                //           ),
                                //           context: context,
                                //           builder: (BuildContext context) {
                                //             return Container(
                                //               height: size.height*0.225,
                                //               padding: EdgeInsets.all(15),
                                //               decoration: BoxDecoration(
                                //                   color: Colors.white,
                                //                   borderRadius: BorderRadius.only(
                                //                       topLeft: Radius.circular(60),
                                //                       topRight: Radius.circular(60)
                                //                   )
                                //               ),
                                //               child: Column(
                                //                 crossAxisAlignment: CrossAxisAlignment.start,
                                //                 children: [
                                //                   Text(AppLocalizations.of(context).change_pp,style: TextStyle(
                                //                       fontSize: 15,
                                //                       fontFamily: 'poppins',
                                //                       color: Colors.black
                                //                   ),),
                                //                   _line(context),
                                //                   _button(
                                //                       AppLocalizations.of(context).take_new_photo,
                                //                       ImageSource.camera),
                                //                   SizedBox(height: size.height*0.01,),
                                //                   _button(
                                //                       AppLocalizations.of(context).choose_gallery,
                                //                       ImageSource.gallery),
                                //                   SizedBox(height: size.height*0.01,),
                                //                   _buttonn(AppLocalizations.of(context).delete_photo,)
                                //                 ],
                                //               ),
                                //             );
                                //           });
                                //     },
                                //     child: Container(
                                //       height: size.height*0.05,
                                //       width: size.width*0.1,
                                //       decoration: BoxDecoration(
                                //         color: Theme.of(context).primaryColor,
                                //         shape: BoxShape.circle,
                                //       ),
                                //       child: Center(
                                //         child: Icon(
                                //           FontAwesomeIcons.camera,
                                //           color: Colors.white,
                                //           size: size.height*0.02,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: size.width * .03),
                            height: size.height * .05,
                            width: size.width * .35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    width: 1
                                )
                            ),
                            child: Center(child: Text("Edit Profile Photo",style: TextStyle(
                              fontSize: size.width * .035,fontFamily: 'poppinsbold',fontWeight: FontWeight.w600
                            ),)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height*0.015,),
                    Text("${capitalize(snapshot.data['name_f'])} ${capitalize(snapshot.data['name_l'])}",
                      style: TextStyle(fontFamily: 'poppinsbold',
                        color: Colors.black,
                        fontSize: 17.5,
                        //  fontWeight: FontWeight.bold
                      ),),
                    SizedBox(height: size.height*0.015,),
                    Padding(
                      padding: EdgeInsets.only(right: size.height*0.025, left:size.height*0.025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context).aCCOUNT_SETTINGS,style: TextStyle(fontFamily: 'poppinslight',
                              color: Colors.grey,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold)),
                          SizedBox(height: size.height*0.025,),
                          _Widgets(AppLocalizations.of(context).personal_Information, FontAwesomeIcons.user, Personal_Info(user: widget.user,)),
                          //  _Widgets("Payments", FontAwesomeIcons.moneyBillAlt, PaymentPage(user: widget.user,)),
//                      Text("RESERVATION",style: TextStyle(fontFamily: 'poppinslight',
//                          color: Colors.grey,
//                          fontSize: 12.5,
//                          fontWeight: FontWeight.bold)),
//                      SizedBox(height: size.height*0.025,),
                          _Widgets(AppLocalizations.of(context).my_list, FontAwesomeIcons.list, OwnOffers(user: widget.user,)),
                          _Widgets(AppLocalizations.of(context).your_waiting, FontAwesomeIcons.chartArea, WaitingApproved(user: widget.user,)),
//                      _Widgets("Your reservations", FontAwesomeIcons.avianex, ReservationPage(user: widget.user,)),
//                      _Widgets("Reservation applications", FontAwesomeIcons.book, Reservation_App(user: widget.user,)),
                          Text(AppLocalizations.of(context).sUPPORT,style: TextStyle(fontFamily: 'poppinslight',
                              color: Colors.grey,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold)),
                          SizedBox(height: size.height*0.05,)
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }else{
              print("none");
              return Container(
                height: 0,width: 0,
              );
            }
          }
      ),
    );
  }


  _Widgets(String tit,IconData i,Widget widget){
    print("_Widgets");
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => widget));
          },
          child: InkWell(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(i,color: Colors.black54,size: 20,),
                SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                Text(tit,style: TextStyle(fontFamily: 'poppinslight',
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        _line1(context),
      ],
    );
  }
}
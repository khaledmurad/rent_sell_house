import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/screens/profile/pages/main_profile/MainProfile.dart';
import 'package:intl/intl.dart';

class AppDes extends StatefulWidget {
  User user;
  final reservID;
  final objectID;
  final clintID;
  AppDes({this.user,this.reservID,this.objectID,this.clintID});
  @override
  _AppDesState createState() => _AppDesState();
}

class _AppDesState extends State<AppDes> {
  DateTime DateFrom,DateTo,ReservDate;
  String hostedName,joined,hostedinfo,userPhoto;
  String name,image,city,state,street,reservState;

  String _confirmed;



  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.clintID).snapshots().listen((v) {
      v.docs.forEach((element) {
        hostedName = "${element["name_f"]} ${element["name_l"]}";
        userPhoto  = element['image'];
      });
    });
    FirebaseFirestore.instance.collection("Objects").where("id",isEqualTo:widget.objectID).snapshots().listen((v) {
      v.docs.forEach((element) {
        name = element["objname"];
        city = element["city"];
        street = element["address"];
        state = element["state"];
        image  = element['image'];
      });
    });

    FirebaseFirestore.instance.collection("Reservation").where("id",isEqualTo:widget.reservID).snapshots().listen((v) {
      v.docs.forEach((element) {
        reservState = element["reservationState"];

      });
    });

  }

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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: _calculation,
        builder: (context,fut){
          return (fut.hasData)?
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
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      FontAwesomeIcons.arrowLeft,
                      size: 17.5,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    "$name",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsbold'),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Reservation").where("id",isEqualTo: widget.reservID).snapshots(),
                      builder: (context,snapshot){
                        return (!snapshot.hasData)?Container(height: 0,width: 0,):
                        Column(
                          children: snapshot.data.docs.map<Widget>((des){
                            DateFrom = des['reserv_date_from'].toDate();
                            DateTo = des['reserv_date_to'].toDate();
                            ReservDate = des['reserv_date'].toDate();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Date from",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins'),),
                                    Text("${DateFormat("d/M/yyyy").format(DateFrom)}",
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppins')),
                                  ],
                                ),
                                SizedBox(height: size.height*0.01,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Date to",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins'),),
                                    Text("${DateFormat("d/M/yyyy").format(DateTo)}",
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppins')),
                                  ],
                                ),
                                SizedBox(height: size.height*0.01,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Guests number",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins'),),
                                    Text("${des['guestsNo']}",
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppins')),
                                  ],
                                ),
                                SizedBox(height: size.height*0.01,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Booking date",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins'),),
                                    Text("${DateFormat("d/M/yyyy").format(ReservDate)}",
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppins')),
                                  ],
                                ),
                                SizedBox(height: size.height*0.01,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total price",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins'),),
                                    Text("${des['total_price']} ${des['priceType']}",
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppins')),
                                  ],
                                ),
                                SizedBox(height: size.height*0.05,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Booking state",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins'),),
                                    Text("\" ${des['reservationState']} \"",
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppins')),
                                  ],
                                ),
                                SizedBox(height: size.height*0.01,),
                                InkWell(
                                  onTap:(){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MainProfile(
                                      user: widget.user,Guser: widget.clintID,
                                    )));
                                  },
                                  highlightColor: Colors.white70,
                                  borderRadius: BorderRadius.circular(5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Guest info",
                                        style: TextStyle(
                                            fontSize: 17.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppins'),),
                                      SizedBox(height: size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("$hostedName",
                                              style: TextStyle(
                                                  fontSize: 17.5,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'poppins')),
                                          Container(
                                            height: size.height*0.07,width: size.width*0.2,
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
                                          )
                                        ],
                                      ),
                                      SizedBox(height: size.height*0.01,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Guest phone",
                                            style: TextStyle(
                                                fontSize: 17.5,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'poppins'),),
                                          Text("+90 ${des['clientPhoneNO']}",
                                              style: TextStyle(
                                                  fontSize: 17.5,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'poppins')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height*0.125,),
                                InkWell(
                                  onTap:(){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDescription(
                                      user: widget.user,objOwner: widget.user.uid,id: widget.objectID,
                                    )));
                                  },
                                  child: Container(
                                    width: size.width,
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
                                          child: Text("House Page",style: TextStyle(
                                              fontFamily: 'poppins',color: Colors.white,
                                              fontSize: 17.5,fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height*0.01,),
                                InkWell(
                                  onTap: (){
                                    if(des['reservationState'] == "Waiting"){
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return _Alert();
                                          }
                                      );
                                    }
                                  },
                                  child:(des['reservationState'] == "Waiting")? Container(
                                    width: size.width,
                                    height: size.height*0.06,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
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
                                          child: Text("Confirmation",style: TextStyle(
                                              fontFamily: 'poppins',color: Colors.white,
                                              fontSize: 17.5,fontWeight: FontWeight.bold),)),
                                    ),
                                  ):Container(
                                    width: size.width,
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
                                          child: Text("Confirmation",style: TextStyle(
                                              fontFamily: 'poppins',color: Colors.white,
                                              fontSize: 17.5,fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height*0.01,),
                                InkWell(
                                  onTap: (){
                                   // Navigator.pop(context);

                                    print(_confirmed);
                                  },
                                  child: Container(
                                    width: size.width,
                                    height: size.height*0.06,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
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
                                          child: Text("Back",style: TextStyle(
                                              fontFamily: 'poppins',color: Colors.white,
                                              fontSize: 17.5,fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height*0.01,),
                              ],
                            );
                          }).toList(),
                        );
                      })
                ],
              ),
            ),
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

  _Alert(){
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
        builder: (context ,StateSetter setState){
          return Container(
            child: AlertDialog(
              title: Text("Confirme application",style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins')),
              content: Container(
                height: size.height*0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Be sure you\'ll not change it after confirmed ?",style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins')),
                    SizedBox(height: size.height*0.01,),
                    InkWell(
                      highlightColor: Colors.white70,
                      onTap: (){
                        setState(() {
                          _confirmed = "Confirmed";
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Confirme",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                          Container(
                            height: size.height*0.035,
                            width: size.width*0.075,
                            decoration: BoxDecoration(
                                color: (_confirmed == "Confirmed")?Theme.of(context).primaryColor:Colors.white,
                                border: Border.all(
                                    width: size.width*0.005,
                                    color: (_confirmed == "Confirmed")?Theme.of(context).primaryColor:Colors.black54
                                ),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child:(_confirmed == "Confirmed")? Icon(FontAwesomeIcons.check,color: Colors.white,size: 15.5,):Container(height: 0,width: 0,),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: size.height*0.01,),
                    InkWell(
                      highlightColor: Colors.white70,
                      onTap: (){
                        setState(() {
                          _confirmed = "Refused";
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Refuse",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                          Container(
                            height: size.height*0.035,
                            width: size.width*0.075,
                            decoration: BoxDecoration(
                                color: (_confirmed == "Refused")?Theme.of(context).primaryColor:Colors.white,
                                border: Border.all(
                                    width: size.width*0.005,
                                    color: (_confirmed == "Refused")?Theme.of(context).primaryColor:Colors.black54
                                ),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Center(
                              child:(_confirmed == "Refused")? Icon(FontAwesomeIcons.check,color: Colors.white,size: 15.5,):Container(height: 0,width: 0,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                    onPressed: (){
                      //TODO

                      setState((){
                        if(_confirmed == "Refused"){
                          FirebaseFirestore.instance.collection("Reservation").doc(widget.reservID).get().then((value){
                            value.reference.update(<String,dynamic>{
                              "reservationState":"Refused",
                            });
                          });
                        }else if(_confirmed == "Confirmed"){
                          FirebaseFirestore.instance.collection("Reservation").doc(widget.reservID).get().then((value){
                            value.reference.update(<String,dynamic>{
                              "reservationState":"Confirmed",
                            });
                          });
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Done",style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins'))),
                FlatButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Back",style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins'))),
              ],
            ),
          );
        });
  }
}

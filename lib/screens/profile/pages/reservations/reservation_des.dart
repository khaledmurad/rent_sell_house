import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:intl/intl.dart';

class ReservDes extends StatefulWidget {
  User user;
  final reservID;
  final objectID;
  final hostID;
  ReservDes({this.user,this.reservID,this.objectID,this.hostID});
  @override
  _ReservDesState createState() => _ReservDesState();
}

class _ReservDesState extends State<ReservDes> {
  String mesj = "";
  DateTime DateFrom,DateTo,ReservDate,today = DateTime.now();
  String hostedName,joined,hostedinfo,userPhoto;
  String name,image,city,state,street;
  double rate= 3.0;
  FToast fToast;

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
  void initState() {
    super.initState();
    fToast =FToast();
    fToast.init(context);
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.hostID).snapshots().listen((v) {
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

  }

  final Future<Widget> _calculation = Future<Widget>.delayed(
      const Duration(seconds: 1),
          () {
            return Container(height: 0,);
      }
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: _calculation,
        builder: (context,f){
          return (f.hasData)?
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
//                                Row(
//                                  children: [
//                                    Container(
//                                      height: size.height*0.2,width: size.width*0.45,
//                                      decoration: BoxDecoration(
//                                          borderRadius: BorderRadius.circular(12.0),
//                                          image: DecorationImage(
//                                              image: NetworkImage(image),
//                                              fit: BoxFit.cover
//                                          )
//                                      ),
//                                    ),
//                                    SizedBox(width: size.width*0.05,),
//
//                                  ],
//                                )
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
                                    Text("Hostname",
                                      style: TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins'),),
                                    Text("$hostedName",
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
                                SizedBox(height: size.height*0.01,),
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
                                (des['reservationState'] == "Confirmed")?
                                Column(
                                  children: [
                                    _line(context),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Review your trip",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppinsbold'),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              showModalBottomSheet<void>(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                                ),
                                                builder: (BuildContext context) {
                                                  return _showModalBottomSheetContainer();
                                                },
                                              );
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: size.width*0.0075),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(7.5),
                                                border: Border.all(
                                                    width: size.width*0.005,color: Theme.of(context).primaryColor
                                                )
                                            ),
                                            child: Text(
                                              'Rate',
                                              style: TextStyle(fontFamily: 'poppinsbold',
                                                  fontWeight: FontWeight.bold, fontSize: 17.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ):Container(height: 0,)


                              ],
                            );
                          }).toList(),
                        );
                      })
                ],
              ),
            ),
          ):
          Center(
              child: SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
                size: size.height*0.05,
              ));
        },
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.only(
            top: size.height * 0.005,
            left: size.width * 0.07,
            right: size.width * 0.07,
          bottom: size.height * 0.005
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDescription(
                  user: widget.user,objOwner: widget.hostID,id: widget.objectID,
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
                showDialog(
                    context: context,
                    builder: (context)=>AlertDialog(
                      title: Text("Cancel booking",style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins')),
                      content: Container(
                        height: size.height*0.125,
                        child: Text("Are you sure you want cancel this booking ?",style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins')),
                      ),
                      actions: [
                        FlatButton(
                            onPressed: (){
                              //TODO
                            },
                            child: Text("Cancel booking",style: TextStyle(
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
                    ));
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
                      child: Text("Cancel booking",style: TextStyle(
                          fontFamily: 'poppins',color: Colors.white,
                          fontSize: 17.5,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
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
    return Container(
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: EdgeInsets.only(top: size.height*0.03),
      width: size.width,height: size.height*0.475,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
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
                  "Rate place",
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
            height:  size.height*0.001,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.black54,
            ),
          ),
          SizedBox(
            height: size.height * 0.025,
          ),
          Padding(
            padding:  EdgeInsets.only(left: size.width * 0.07,
                right: size.width * 0.07),
            child: Text(
              "Rate place and write review",
              style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppinsbold'),
            ),
          ),
          SizedBox(height: size.height*0.015,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: rate,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rate = rating;
                  });
                },
              )
            ],
          ),
          SizedBox(height: size.height*0.02,),
          Padding(
              padding:  EdgeInsets.only(left: size.width * 0.07,
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
                  padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
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
                      hintText: "Great place to stay",
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
          SizedBox(height: size.height*0.02,),
          Padding(
              padding:  EdgeInsets.only(left: size.width * 0.07,
                  right: size.width * 0.07),
              child: GestureDetector(
                onTap: (){
                    Random rnd = Random();
                    var rnd1 = rnd.nextInt(500000000).toString();
                    var msgNO = rnd.nextInt(500000000).toString();
                    FirebaseFirestore.instance
                        .collection('review')
                        .doc(rnd1)
                        .set({
                      "id":rnd1,
                      "hostID":widget.objectID,
                      "reviewer":widget.user.uid,
                      "rate":rate,
                      "msg":mesj,
                      "month":"${_MonthsName(today.month)}",
                      "year":"${today.year}",

                    });

                    Navigator.pop(context);
                    fToast.showToast(
                      child: Padding(
                        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text("Thank you",style: TextStyle(
                                color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                      ),
                      gravity: ToastGravity.TOP,

                      toastDuration: Duration(seconds: 2),
                    );

                },
                child:Container(
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
                        child: Text("Review",style: TextStyle(
                            fontFamily: 'poppins',color: Colors.white,
                            fontSize: 15,fontWeight: FontWeight.bold),)),
                  ),
                )
                ),
          ),



        ],
      ),
    );
  }

}
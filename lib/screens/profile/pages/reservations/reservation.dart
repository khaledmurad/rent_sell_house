import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/screens/profile/pages/reservations/reservation_des.dart';
import 'package:intl/intl.dart';

class ReservationPage extends StatefulWidget {
  User user;
  ReservationPage({this.user});
  @override
  _ReservationPageState createState() => _ReservationPageState();
}
enum SingingCharacter {suggestion, complaint }

class _ReservationPageState extends State<ReservationPage> {


  List<String> offers;
  @override
  void initState() {
    super.initState();
    offers=[];
    FirebaseFirestore.instance.collection("Reservation")
        .where("clientID",isEqualTo: widget.user.uid)
        .snapshots().listen((v) {
      v.docs.forEach((element) {
        offers.add(element['id']);
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
                left: size.width * 0.07,
                right: size.width * 0.07),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 25,width: 25,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                  ),
                  SizedBox(
                    height: size.height * 0.035,
                  ),
                  Text(
                    "Your reservations",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsbold'),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  FutureBuilder(
                    future: _ww(),
                    builder: (context, snapshot){
                      return ListTile(
                        title: (offers.length >0)?_WidgetReservation():_WidgetNoOffers(),
                      );
                    },
                  )
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
    );
  }

  Future<Widget> _ww() async {
    if(offers.length >0){
      await new Future.delayed(const Duration(seconds: 5));
      return  _WidgetReservation();
    }else{ return _WidgetNoOffers();}
  }

  _WidgetReservation(){
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        //   height: size.height,
        width: size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Reservation").where("clientID",isEqualTo: widget.user.uid)
              .orderBy("reserv_date",descending: false)
              .snapshots(),
          builder:(context , reserv){
            return (!reserv.hasData)?
      Container(height: 0,width: 0,):
      Column(
        children: reserv.data.docs.map<Widget>((d){
          DateTime DateFrom,DateTo;
          DateFrom = d['reserv_date_from'].toDate();
          DateTo = d['reserv_date_to'].toDate();
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Objects").where("id",isEqualTo: d['objID']).snapshots(),
            builder: (context , snapshot){
              if(snapshot.hasData){
                return Column(
                  children: snapshot.data.docs
                      .map<Widget>((doc){
                    return InkWell(
                      highlightColor: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReservDes(
                          objectID: doc['id'],reservID: d['id'],hostID: d['hostID'],
                          user: widget.user,)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top:size.height*0.01,bottom: size.height*0.01,left: size.width*0.025),
                        height: size.height*0.175,width: size.width,
                        child: Row(
                          children: [
                            Container(
                              height: size.height*0.175,width: size.width*0.35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  image: DecorationImage(
                                      image: NetworkImage(doc['image']),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            SizedBox(width: size.width*0.05,),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${doc['objname']}",style: TextStyle(fontSize: 12.5,fontWeight: FontWeight.w600,fontFamily: 'poppinslight'),),
                                  SizedBox(height: size.height*0.01,),
                                  Text("${DateFormat('d-M-yy').format(DateFrom)} to ${DateFormat('d-M-yy').format(DateTo)}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 12.5,fontWeight: FontWeight.w600),),
                                  SizedBox(height: size.height*0.01,),
                                  Text("Total price: ${d['total_price']} ${d['priceType']}",style: TextStyle(fontSize: 12.5,fontWeight: FontWeight.w600,fontFamily: 'poppinslight'),),
                                  SizedBox(height: size.height*0.01,),
                                  Text("State: ${d['reservationState']}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'poppinslight'),),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }else{
                return Container();
              }
            },
          );
        }).toList(),
      );
      }
        ),
      ),
    );
  }

  _WidgetNoOffers(){
    Size size=MediaQuery.of(context).size;
    return Text('You haven\'t made any reservation',style: TextStyle(fontSize: 17.5,fontWeight: FontWeight.bold,fontFamily: 'poppins',),);
  }
}

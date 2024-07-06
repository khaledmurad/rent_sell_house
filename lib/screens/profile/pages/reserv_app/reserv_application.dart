import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'appDes.dart';

class Reservation_App extends StatefulWidget {
  User user;
  Reservation_App({this.user});
  @override
  _Reservation_AppState createState() => _Reservation_AppState();
}
enum SingingCharacter {suggestion, complaint }

class _Reservation_AppState extends State<Reservation_App> {
  List<String> apps;
  @override
  void initState() {
    super.initState();
    apps=[];
    FirebaseFirestore.instance.collection("Reservation")
        .where("hostID",isEqualTo: widget.user.uid)
        .snapshots().listen((v) {
      v.docs.forEach((element) {
        apps.add(element['id']);
      });
    });
print(apps);
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
                      "Reservation applications",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
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
                          title: (apps.length >0)?_WidgetOffers():_WidgetNoOffers(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ):Center(
                child: SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: size.height*0.05,
                ));
          },
        )
    );
  }


  Future<Widget> _ww() async {
    if(apps.length >0){
      await new Future.delayed(const Duration(seconds: 5));
      return  _WidgetOffers();
    }else{ return _WidgetNoOffers();}
  }

  _WidgetOffers(){
    Size size=MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
          width: size.width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Reservation").where("hostID",isEqualTo: widget.user.uid).snapshots(),
            builder: (context , snap){
              return (snap.hasData)?
              Column(
                children: snap.data.docs.map<Widget>((app){
                  DateTime DateFrom,DateTo;
                  DateFrom = app['reserv_date_from'].toDate();
                  DateTo = app['reserv_date_to'].toDate();
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Objects").where("id",isEqualTo: app['objID']).snapshots(),
                    builder: (context , snapshot){
                      if(snapshot.hasData){
                        return Column(
                          children: snapshot.data.docs
                              .map<Widget>((doc){
                            return InkWell(
                              highlightColor: Colors.black54,
                              borderRadius: BorderRadius.circular(30),
                              onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AppDes(
                          user: widget.user,objectID: doc['id'],reservID: app['id'],clintID: app['clientID'],
                        )));
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
                                          Text("Total price: ${app['total_price']} ${app['priceType']}",style: TextStyle(fontSize: 12.5,fontWeight: FontWeight.w600,fontFamily: 'poppinslight'),),
                                          SizedBox(height: size.height*0.01,),
                                          Text("State: ${app['reservationState']}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'poppinslight'),),
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
              )
                  :Container(height: 0,);
            },
          )
      ),
    );
  }

  _WidgetNoOffers(){
    Size size=MediaQuery.of(context).size;
    return Text('There\'s no applications until now',style: TextStyle(fontSize: 17.5,fontWeight: FontWeight.bold,fontFamily: 'poppins',),);
  }
}

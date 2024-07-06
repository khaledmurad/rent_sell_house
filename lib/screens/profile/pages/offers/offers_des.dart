import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/screens/profile/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OffersDes extends StatefulWidget {
  User user;
  final objectID;
  OffersDes({this.user, this.objectID});
  @override
  _OffersDesState createState() => _OffersDesState();
}

class _OffersDesState extends State<OffersDes> {
  String hostedName, joined, hostedinfo, userPhoto;
  String name, image, city, state, street, objState;

  @override
  void initState() {
    super.initState();
    setState(() {
      FirebaseFirestore.instance
          .collection("Users")
          .where("id", isEqualTo: widget.user.uid)
          .snapshots()
          .listen((v) {
        v.docs.forEach((element) {
          hostedName = "${element["name_f"]} ${element["name_l"]}";
          userPhoto = element['image'];
        });
      });
      FirebaseFirestore.instance
          .collection("Objects")
          .where("id", isEqualTo: widget.objectID)
          .snapshots()
          .listen((v) {
        v.docs.forEach((element) {
          name = element["objname"];
          city = element["city"];
          street = element["address"];
          objState = element["objState"];
          state = element["state"];
          image = element['image'];
        });
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
        builder: (context ,s){
          return (s.hasData)?Padding(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: size.height * 0.2,
                            width: size.width *.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                    image: NetworkImage(image), fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).city,
                            style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                          Text("$city",
                              style: TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins')),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).state,
                            style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                          Text("$state",
                              style: TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins')),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).address,
                            style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                          Text("$street",
                              style: TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins')),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).ads_state,
                            style: TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                          Text("$objState",
                              style: TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins')),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDescription(
                            user: widget.user,objOwner: widget.user.uid,id: widget.objectID,
                          )));
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              borderRadius: BorderRadius.circular(7.5),
                              border:
                              Border.all(width: 0.5, color: Colors.black54)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: Center(
                                child: Text(
                                  AppLocalizations.of(context).house_Page,
                                  style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.white,
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(AppLocalizations.of(context).convert,
                                    style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'poppins')),
                                content: Container(
                                  height: size.height * 0.125,
                                  child: Text(
                                      (objState == "Active")?
                                      AppLocalizations.of(context).sure_you_want_convert
                                          :AppLocalizations.of(context).sure_you_want_not_convert,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins')),
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        //TODO
                                        setState(() {
                                          if(objState == "Active"){
                                            objState = "Not active";
                                            FirebaseFirestore.instance.collection("Objects").doc(widget.objectID).get().then((value){
                                              value.reference.update(<String,dynamic>{
                                                "objState":"Not active",
                                              });
                                            });
                                          }else{
                                            objState = "Active";
                                            FirebaseFirestore.instance.collection("Objects").doc(widget.objectID).get().then((value){
                                              value.reference.update(<String,dynamic>{
                                                "objState":"Active",
                                              });
                                            });
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context).sure,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppins'))),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context).back,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppins'))),
                                ],
                              ));
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(7.5),
                              border:
                              Border.all(width: 0.5, color: Colors.black54)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: Center(
                                child: Text((objState=="Active")? AppLocalizations.of(context).convert_not_active
                                    :AppLocalizations.of(context).convert_active
                                  ,style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.white,
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(AppLocalizations.of(context).delete,
                                    style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'poppins')),
                                content: Container(
                                  height: size.height * 0.125,
                                  child: Text(
                                      AppLocalizations.of(context).sure_you_want_delete_ads,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppins')),
                                ),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        //TODO
                                        FirebaseFirestore.instance.collection("Objects").doc(widget.objectID)
                                            .delete();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context).delete,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppins'))),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context).back,
                                          style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppins'))),
                                ],
                              ));
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(7.5),
                              border:
                              Border.all(width: 0.5, color: Colors.black54)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: Center(
                                child: Text(
                                  AppLocalizations.of(context).delete_this_ADS,
                                  style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.white,
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.06,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(7.5),
                              border:
                              Border.all(width: 0.5, color: Colors.black54)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            child: Center(
                                child: Text(
                                  AppLocalizations.of(context).back,
                                  style: TextStyle(
                                      fontFamily: 'poppins',
                                      color: Colors.white,
                                      fontSize: 17.5,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ) :Center(
              child: SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
                size: size.height*0.05,
              ));
        },
      ),
    );
  }
}

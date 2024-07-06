import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_mate_app/controllers/reviews_controller.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/models/reviews.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterPage extends StatefulWidget {
  User user;
  FilterPage({this.user});
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String page = "f";
  List<dynamic> all_obj = [];
  var all_objcts = [];
  _line(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.03,
        ),
        SizedBox(
          height: size.height * 0.0005,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
      ],
    );
  }

  int i = 1, bedroomNO = 0, bathroomNo = 0;
  String hostkind, roomCount, cityID, stateID;
  String max, min;
  bool Balcony = false,
      amenwifi = false,
      amensmokealarm = false,
      amenbedroom = false,
      amenheating = false,
      amenarecondition = false,
      amenTV = false,
      amenParking = false,
      amenSecurityCamnira = false,
      amenGarden = false,
      amenPool = false,
      amenHomeSafty = false,
      amenPets = false;
  String hosttypeSR;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (page == "f") ? _filterPage() : _filterResultPage();
  }

  CollectionReference objectC =
      FirebaseFirestore.instance.collection("Objects");

  _filterPage() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: size.width * 0.07),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: size.height * 0.08,
              left: size.width * 0.07,
            ),
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
                  AppLocalizations.of(context).filters,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppinsbold'),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).house_kind} :",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<String>(
                          hint: Text(AppLocalizations.of(context).select,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight')),
                          value: hostkind,
                          items: <DropdownMenuItem<String>>[
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).entire_house,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Entire house',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).cabins_Cattages,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Cabins and Cattages',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).apartment,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Apartment',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).hotel,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Hotel',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).villa,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Villa',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).tiny_house,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Tiny house',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).housemate,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Housemate',
                            )
                          ],
                          onChanged: (String value) {
                            setState(() {
                              hostkind = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).house_For} :",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<String>(
                          hint: Text(AppLocalizations.of(context).select,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight')),
                          value: hosttypeSR,
                          items: <DropdownMenuItem<String>>[
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).for_sale,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'For sale',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).for_rent,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'For rent',
                            ),
                            new DropdownMenuItem(
                              child: new Text(
                                  AppLocalizations.of(context).daily_rentals,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'Daily rentals',
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              hosttypeSR = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).count_house_rooms} :",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton<String>(
                          hint: Text(AppLocalizations.of(context).select,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight')),
                          value: roomCount,
                          items: <DropdownMenuItem<String>>[
                            new DropdownMenuItem(
                              child: new Text('0+1',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '0+1',
                            ),
                            new DropdownMenuItem(
                              child: new Text('1+1',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '1+1',
                            ),
                            new DropdownMenuItem(
                              child: new Text('2+1',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '2+1',
                            ),
                            new DropdownMenuItem(
                              child: new Text('3+1',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '3+1',
                            ),
                            new DropdownMenuItem(
                              child: new Text('3+2',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '3+2',
                            ),
                            new DropdownMenuItem(
                              child: new Text('4+1',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '4+1',
                            ),
                            new DropdownMenuItem(
                              child: new Text('4+2',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '4+2',
                            ),
                            new DropdownMenuItem(
                              child: new Text('4+3',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '4+3',
                            ),
                            new DropdownMenuItem(
                              child: new Text('5+1',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '5+1',
                            ),
                            new DropdownMenuItem(
                              child: new Text('5+2',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '5+2',
                            ),
                            new DropdownMenuItem(
                              child: new Text('5+3',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: '5+3',
                            ),
                            new DropdownMenuItem(
                              child: new Text(AppLocalizations.of(context).more,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: 'More',
                            ),
                          ],
                          onChanged: (String value) {
                            setState(() {
                              roomCount = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).city} :",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: new DropdownButtonHideUnderline(
                        child: new StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("city")
                                .orderBy("user")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: SingleChildScrollView(
                                    child: new DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          hint: Text(
                                              AppLocalizations.of(context)
                                                  .select,
                                              style: TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'poppinslight')),
                                          value: cityID,
                                          items: snapshot.data.docs
                                              .map<DropdownMenuItem<String>>(
                                                  (DocumentSnapshot doc) {
                                            return DropdownMenuItem<String>(
                                              value: doc["user"].toString(),
                                              child: Text("${doc["user"]}",
                                                  style: TextStyle(
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          'poppinslight')),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              cityID = value;
                                              stateID = null;
                                            });
                                          }),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 0,
                                  height: 0,
                                );
                              }
                            }),
                      ),
                    ),
                  ],
                ),
                (cityID == null)
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppLocalizations.of(context).state} :",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                          Container(
                            width: size.width * 0.4,
                            child: new DropdownButtonHideUnderline(
                              child: new StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("state")
                                      .where("city", isEqualTo: cityID)
                                      .orderBy('state')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        child: SingleChildScrollView(
                                          child:
                                              new DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                                hint: Text(
                                                    AppLocalizations.of(context)
                                                        .select,
                                                    style: TextStyle(
                                                        fontSize: 12.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'poppinslight')),
                                                value: stateID,
                                                isDense: true,
                                                items: snapshot.data.docs.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (DocumentSnapshot doc) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value:
                                                        doc["state"].toString(),
                                                    child: Text(
                                                        "${doc["state"]}",
                                                        style: TextStyle(
                                                            fontSize: 12.5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'poppinslight')),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    stateID = value;
                                                  });
                                                }),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        width: 0,
                                        height: 0,
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                _line(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).bedroom} :",
                      style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              bedroomNO = bedroomNO + 1;
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Theme.of(context).highlightColor,
                              size: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Text(
                          "${bedroomNO}",
                          style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppinslight'),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (bedroomNO >= 1) {
                                bedroomNO = bedroomNO - 1;
                              }
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: Theme.of(context).highlightColor,
                              size: 25,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).bathroom} :",
                      style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              bathroomNo = bathroomNo + 1;
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Theme.of(context).highlightColor,
                              size: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        Text(
                          "${bathroomNo}",
                          style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppinslight'),
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (bathroomNo >= 1) {
                                bathroomNo = bathroomNo - 1;
                              }
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.remove_circle_outline,
                              color: Theme.of(context).highlightColor,
                              size: 25,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).balcony} :",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: Balcony,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            Balcony = v;
                            print(Balcony);
                          });
                        })
                  ],
                ),
                _line(context),
                Text(
                  AppLocalizations.of(context).amenities,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppins'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).wiFi,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenwifi,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenwifi = v;
                            print(amenwifi);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).bedroom,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenbedroom,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenbedroom = v;
                            print(amenbedroom);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).tV,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenTV,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenTV = v;
                            print(amenTV);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).garden,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenGarden,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenGarden = v;
                            print(amenGarden);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).heating,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenheating,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenheating = v;
                            print(amenheating);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).air_condition,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenarecondition,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenarecondition = v;
                            print(amenarecondition);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).house_safety,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenHomeSafty,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenHomeSafty = v;
                            print(amenHomeSafty);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).parking,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenParking,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenParking = v;
                            print(amenParking);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).pool,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenPool,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenPool = v;
                            print(amenPool);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).secure_camera,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenSecurityCamnira,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenSecurityCamnira = v;
                            print(amenSecurityCamnira);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).smoke_alarm,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amensmokealarm,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amensmokealarm = v;
                            print(amensmokealarm);
                          });
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).pets,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Checkbox(
                        value: amenPets,
                        activeColor: Theme.of(context).highlightColor,
                        onChanged: (v) {
                          setState(() {
                            amenPets = v;
                            print(amenPets);
                          });
                        })
                  ],
                ),
                _line(context),
                Text(
                  AppLocalizations.of(context).price,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppins'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).max,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.5, color: Colors.black54)),
                      width: size.width * 0.3,
                      child: TextFormField(
                        initialValue: (max == null) ? "" : "$max",
                        onChanged: (v) {
                          setState(() {
                            max = v;
                          });
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.0075,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).min,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.01),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.5, color: Colors.black54)),
                      width: size.width * 0.3,
                      child: TextFormField(
                        initialValue: (min == null) ? "" : "$min",
                        onChanged: (v) {
                          setState(() {
                            min = v;
                          });
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.0075),
        child: InkWell(
          onTap: () {
            setState(() {
              all_obj = all_objcts
                  .where((e) => e['awaiting_approval'] == 'Approval')
                  .where((e) => e['objState'] == 'Active')
                  .where((e) =>
                      (hostkind != null) ? e['HostKind'] == hostkind : true)
                  .where((element) => (hosttypeSR != null)
                      ? (hosttypeSR == "For sale")
                          ? element['hosttypeSR'] == hosttypeSR
                          : (hosttypeSR == "For rent")
                              ? element['rent_time_for'] == "Yearly"
                              : element['rent_time_for'] == "Monthly"
                      : true)
                  .where((element) => (roomCount != null)
                      ? element['roomCount'] == roomCount
                      : true)
                  .where((element) =>
                      (cityID != null) ? element['cityID'] == cityID : true)
                  .where((element) =>
                      (stateID != null) ? element['stateID'] == stateID : true)
                  .where((element) => (bedroomNO != 0)
                      ? element['bedroomNO'] == bedroomNO
                      : true)
                  .where((element) => (bathroomNo != 0)
                      ? element['bathroomNo'] == bathroomNo
                      : true)
                  .where((element) => (min != null && min != "")
                      ? int.parse(element['price']) >= int.parse(min)
                      : true)
                  .where((element) => (max != null && max != "")
                      ? int.parse(element['price']) <= int.parse(max)
                      : true)
                  .where((element) =>
                      (max != null && max != "" && min != null && min != "")
                          ? (int.parse(element['price']) <= int.parse(max)) &&
                              (int.parse(element['price']) >= int.parse(min))
                          : true)
                  .where((element) => (Balcony == true)
                      ? element['Balcon'] == "Available"
                      : true)
                  .where((element) =>
                      (amenwifi == true) ? element['amenwifi'] == true : true)
                  .where((element) =>
                      (amenPool == true) ? element['amenPool'] == true : true)
                  .where((element) => (amensmokealarm == true)
                      ? element['amensmokealarm'] == true
                      : true)
                  .where((element) => (amenbedroom == true)
                      ? element['amenbedroom'] == true
                      : true)
                  .where((element) => (amenheating == true)
                      ? element['amenheating'] == true
                      : true)
                  .where((element) => (amenarecondition == true)
                      ? element['amenarecondition'] == true
                      : true)
                  .where((element) =>
                      (amenTV == true) ? element['amenTV'] == true : true)
                  .where((element) => (amenParking == true) ? element['amenParking'] == true : true)
                  .where((element) => (amenSecurityCamnira == true) ? element['amenSecurityCamira'] == true : true)
                  .where((element) => (amenGarden == true) ? element['amenGarden'] == true : true)
                  .where((element) => (amenHomeSafty == true) ? element['amenHomeSafty'] == true : true)
                  .where((element) => (amenPets == true) ? element['amenPets'] == true : true)
                  .toList();

              all_obj.shuffle();
              print(all_obj.length);
              page = "r";
              _calculation();
            });

            //Navigator.push(context, MaterialPageRoute(builder: (context)=>FR(fr: filter_result,)));
          },
          child: Container(
            width: double.infinity,
            height: size.height * 0.065,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(169, 176, 185, 0.42),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context).apply_filter,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppins'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _calculation() async {
    await new Future<Widget>.delayed(const Duration(seconds: 2));

    return all_obj;
  }

  bool showAD;
  Future getBannerWidget() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-6540722261762138/3821284491',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        print("Ad loading $ad");
        showAD = true;
      }, onAdFailedToLoad: (ad, loadError) {
        print("Ad loading error $loadError");
        showAD = false;
        ad.dispose();
      }),
    );

    await myBanner.load();

    return (showAD == true)
        ? Container(
            child: AdWidget(
              ad: myBanner,
            ),
          )
        : null;
  }

  BannerAd myBanner;
  _filterResultPage() {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
            size: 17.5,
          ),
          splashRadius: 22.5,
          highlightColor: Theme.of(context).primaryColor,
          onPressed: () {
            setState(() {
              page = "f";
            });
          },
        ),
        title: Text(
          AppLocalizations.of(context).filter_results,
          style: TextStyle(
              color: Colors.black, fontFamily: 'poppins', fontSize: 17.5),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: _calculation(),
          builder: (context, f) {
            return (f.hasData)
                ? WillPopScope(
                    // ignore: missing_return
                    onWillPop: () {
                      setState(() {
                        page = "f";
                      });
                    },
                    child: (all_obj.isNotEmpty)
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: size.height,
                                  width: size.width,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: size.height * 0.075),
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                          bottom: size.height * 0.05,
                                          left: 25,
                                          right: 25,
                                        ),
                                        itemCount: all_obj.length,
                                        itemBuilder: (context, obj) {
                                          _widgetRate(all_obj[obj]["id"]);
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ObjectDescription(
                                                            id: all_obj[obj]
                                                                ['id'],
                                                            objOwner:
                                                                all_obj[obj]
                                                                    ['ADID'],
                                                            user: widget.user,
                                                          )));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(top: 20),
                                              height: size.height * 0.4,
                                              width: size.width,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  all_obj[obj][
                                                                      'image']),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.01,
                                                  ),
//                                  Row(
//                                    children: [
//                                      Icon(Icons.star , color: Theme.of(context).primaryColor,size: 15,),
//                                      Text("4.5",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'poppins'),),
//                                    ],
//                                  ),
                                                  (reviews.length != 0)
                                                      ? _buildRatingStars(
                                                          sumRate,
                                                          double.parse(
                                                              "${reviews.length}"))
                                                      : Container(
                                                          height: 0,
                                                        ),
                                                  SizedBox(
                                                    height: size.height * 0.01,
                                                  ),
                                                  Text(
                                                    "${all_obj[obj]["HostKind"]} . ${all_obj[obj]['cityID']}",
                                                    style: TextStyle(
                                                        fontFamily: 'poppins',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.005,
                                                  ),
                                                  Text(
                                                    "${all_obj[obj]['name']}",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'poppins'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                // SizedBox(height: size.height*0.2,)
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.1,
                                ),
                                Image.asset(
                                  "assets/images/error.png",
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                    child: Text(
                                  AppLocalizations.of(context).no_result,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppins',
                                  ),
                                )),
                              ],
                            ),
                          ),
                  )
                : Center(
                    child: SpinKitChasingDots(
                    color: Theme.of(context).primaryColor,
                    size: size.height * 0.05,
                  ));
          }),
      bottomNavigationBar: FutureBuilder(
          future: getBannerWidget(),
          builder: (context, f) {
            return (f.hasData)
                ? Container(
                    height: size.height * 0.065,
                    width: size.width,
                    child: f.data)
                : Container(
                    height: 0,
                  );
          }),
    );
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
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 17.5,
        ),
        Text(stars,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'poppins')),
      ],
    );
  }

  Widget _widgetRate(id) {
//      return _buildRatingStars( sumRate.toDouble(),Listrate.length.toDouble());
    //Listrate.clear();
    sumRate = 0.0;
    reviews = reviewcontroller.review.where((e) => (e.hostID == id)).toList();

    Listrate = allrate.where((element) {
      // sumRate = sumRate +element['rate'];
      return (element['id'] == id);
    }).toList();
    for (int i = 0; i < reviews.length; i++) {
      sumRate = sumRate + reviews[i].rate;
    }
    //return ;
  }

  @override
  void initState() {
    super.initState();
    // myBanner.load();
    FirebaseFirestore.instance.collection("Objects").get().then((value) {
      value.docs.forEach((d) {
        all_objcts.add({
          "id": d['id'],
          "image": d['image'],
          "HostKind": d['type'],
          "amenwifi": d["amenWIFI"],
          "amensmokealarm": d["amensmoke"],
          "amenbedroom": d["amenbedroom"],
          "amenheating": d["amenheating"],
          "amenarecondition": d["amenAirCondition"],
          "amenTV": d["amenTV"],
          "amenParking": d["amenparking"],
          "amenSecurityCamira": d["amensecureCamera"],
          "amenGarden": d["amengarden"],
          "amenPool": d["amenpool"],
          "amenHomeSafty": d["amenHomesafty"],
          "amenPets": d["amenpets"],
          "roomCount": d["roomNO"],
          "cityID": d["city"],
          "stateID": d["state"],
          "hosttypeSR": d["hosr_sale_rent"],
          "bedroomNO": d["bedroomNO"],
          "Balcon": d["balcony"],
          "bathroomNo": d["bathroomNO"],
          "ADID": d["ADID"],
          "ADowner": d["ADowner"],
          "name": d["objname"],
          "objState": d["objState"],
          "awaiting_approval": d["awaiting_approval"],
          "price": d["price"],
          "rent_time_for": d["rent_time_for"],
        });
      });
    });
  }
}

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timelines/timelines.dart';
import 'package:toggle_switch/toggle_switch.dart';


class NewDescription extends StatefulWidget {
  User user;
  String hostO , hostrentT , hostfor,roomNO,hostKind,city,state;
  NewDescription({this.user,this.city,this.hostfor,this.hostKind,this.hostO,this.hostrentT,this.roomNO,this.state});
  @override
  _NewDescriptionState createState() => _NewDescriptionState();
}

class _NewDescriptionState extends State<NewDescription> {
  ////////for FP
  int Balcon = 0,HS = 0,HN=0;
  String ADNAME,Balcony,hostspace;
  int bedroomNO=1;int floorNO = 0,bathroomNo=1;
  var maxpeople="1";
  /////////for THP
  int CIN = 0,COUT = 0,AP=0,AS=0,MAD=0,priceSALE=0;
  bool amenwifi = false,amensmokealarm = false,amenbedroom = false,amenheating = false,amenarecondition = false,amenTV = false,
      amenParking = false,amenSecurityCamnira = false,amenGarden = false,amenPool = false,amenHomeSafty = false,amenPets = false;
  String Homeimg , checkin,checkout,allowpets,allowsmoking, tameen= "0", comsyon= "0",DorTL,
  price;
  int dollarORtl = 0;
  //////////////for FRP
  int DES =0 , MIMG =0;
  String Description;
  ////////////for FIP
  int IMGS=0;
  String img;
  String photoUrl;
  ImagePicker imagePicker;
  File _image , PFL;
  List<File> _pickFileList = [];
  final picker = ImagePicker();

/////////////////////fot SIP
  int ST =0 ,PC =0;
  String street , postcode;
  int w = 1,i=0;

  FToast fToast;


  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _Widget(w)
    );
  }
  _Widget(w){
    if(w == 1){
      return _FirstPage();
    }else if(w == 2){
      return _SecondPage();
    }else if(w == 3){
      return _ThirdPage();
    }else if(w == 4){
      return _ForthPage();
    }else if(w == 5){
      return _FifthPage();
    }else if(w == 6){
      return _SixthPage();
    }else if(w == 7){
      return _ThanksPage();
    }
  }
  Widget _FirstPage(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: size.height * 0.04,
            left: size.width * 0.07,
            bottom: size.height*0.025,
            right: size.width * 0.07),
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height*0.05,),
                  Text(
                    AppLocalizations.of(context).host_Description,
                    style: TextStyle(
                        fontSize:17.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinslight'),
                  ),
                  (widget.hostfor == 'For rent')?
                  Text(
                    "- ${widget.hostfor} (${widget.hostrentT})",
                    style: TextStyle(
                        fontSize:12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinslight'),
                  ):
                  Text(
                    "- ${widget.hostfor}",
                    style: TextStyle(
                        fontSize:12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinslight'),
                  ),
                  Text(
                    "- ${widget.hostKind} (${widget.roomNO})",
                    style: TextStyle(
                        fontSize:12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinslight'),
                  ),
                  Text(
                    "- ${widget.hostfor}",
                    style: TextStyle(
                        fontSize:12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinslight'),
                  ),
                  Text(
                    "- ${widget.state} . ${widget.city}",
                    style: TextStyle(
                        fontSize:12.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinslight'),
                  ),
                  SizedBox(height: size.height*0.05,),
                  Row(
                    children: [
                      (HN ==1)?
                      Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                      Text(
                        "${AppLocalizations.of(context).ad_Name} :",
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                    ],
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
                      child: TextFormField(
                        onChanged: (v) {
                          setState(() {
                            ADNAME = v;
                          });
                        },
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),

                          ),
                          labelText: AppLocalizations.of(context).host_name,
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.025,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations.of(context).bedroom} :",
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                bedroomNO = bedroomNO + 1;
                              });
                            },
                            child: Container(
                              child: Icon(Icons.add_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          ) ,
                          SizedBox(width: size.width*0.05,),
                          Text(
                            "${bedroomNO}",
                            style: TextStyle(
                                fontSize:17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                          SizedBox(width: size.width*0.05,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(bedroomNO >1){
                                  bedroomNO = bedroomNO -1;
                                }
                              });
                            },
                            child: Container(
                              child: Icon(Icons.remove_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: size.height*0.025,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations.of(context).bathroom} :",
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                bathroomNo = bathroomNo + 1;
                              });
                            },
                            child: Container(
                              child: Icon(Icons.add_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          ) ,
                          SizedBox(width: size.width*0.05,),
                          Text(
                            "${bathroomNo}",
                            style: TextStyle(
                                fontSize:17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                          SizedBox(width: size.width*0.05,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(bathroomNo >1){
                                  bathroomNo = bathroomNo -1;
                                }
                              });
                            },
                            child: Container(
                              child: Icon(Icons.remove_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: size.height*0.025,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations.of(context).mmax_people} :",
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(int.parse(maxpeople) >=1 && int.parse(maxpeople)<=7){
                                  maxpeople =(int.parse(maxpeople)+1).toString();
                                }else if(int.parse(maxpeople)  == 8){
                                  maxpeople = "more";
                                }
                              });
                            },
                            child: Container(
                              child: Icon(Icons.add_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          ) ,
                          SizedBox(width: size.width*0.05,),
                          Text(
                            maxpeople,
                            style: TextStyle(
                                fontSize:17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                          SizedBox(width: size.width*0.05,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(maxpeople == "more"){
                                  maxpeople = "8";
                                }else if(int.parse(maxpeople)>1 &&int.parse(maxpeople)<=8){
                                  maxpeople = (int.parse(maxpeople)  -1).toString();
                                }
                              });
                            },
                            child: Container(
                              child: Icon(Icons.remove_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: size.height*0.025,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations.of(context).floor_Number} :",
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                floorNO = floorNO + 1;
                              });
                            },
                            child: Container(
                              child: Icon(Icons.add_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          ) ,
                          SizedBox(width: size.width*0.05,),
                          Text(
                            "${floorNO}",
                            style: TextStyle(
                                fontSize:17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                          SizedBox(width: size.width*0.05,),
                          InkWell(
                            onTap: (){
                              setState(() {
                                if(floorNO >-1){
                                  floorNO = floorNO -1;
                                }
                              });
                            },
                            child: Container(
                              child: Icon(Icons.remove_circle_outline,color: Theme.of(context).highlightColor,size: 25,),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: size.height*0.025,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          (HS ==1)?
                          Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                          Text(
                            "${AppLocalizations.of(context).host_space} :",
                            style: TextStyle(
                                fontSize:17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: size.height*0.05,
                            width: size.width*0.35,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
                              child: TextFormField(
                                onChanged: (v) {
                                  setState(() {
                                    hostspace = v;
                                  });
                                },
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppinslight'
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey
                                    )
                                  ),
                                  hintText: AppLocalizations.of(context).space,
                                  hintStyle: TextStyle(
                                     color: Colors.grey,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context).mm,
                            style: TextStyle(
                                fontSize:15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: size.height*0.025,),
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              (Balcon ==1)?
                              Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                              Text(
                                "${AppLocalizations.of(context).balcony} :",
                                style: TextStyle(
                                    fontSize:15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppinslight'),
                              ),
                            ],
                          ),
                          Container(
                            width: size.width*0.4,
                            height: size.height*0.02,
                            child: new DropdownButtonHideUnderline(
                              child: new DropdownButton<String>(
                                hint: Text(AppLocalizations.of(context).select,
                                    style: TextStyle(
                                        fontSize:12.5,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'poppinslight')),
                                value: Balcony,
                                items: <DropdownMenuItem<String>>[
                                  new DropdownMenuItem(
                                    child: new Text(AppLocalizations.of(context).available,
                                        style: TextStyle(
                                            fontSize:12.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppinslight')),
                                    value: 'Available',
                                  ),
                                  new DropdownMenuItem(
                                    child: new Text(AppLocalizations.of(context).not_available,
                                        style: TextStyle(
                                            fontSize:12.5,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'poppinslight')),
                                    value: 'Not available',
                                  ),
                                ],
                                onChanged: (String value) {
                                  setState(() {
                                    Balcony = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: size.height*0.025,),
                ],
              ),
            ),
            Positioned(
                left:- size.width*0.04,
                top:- size.height*0.01,
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,width: 50,
                    child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                )),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  if(Balcony == null){
                    Balcon = 1;
                  }else{Balcon = 0;}
                  if(hostspace == null){
                    HS = 1;
                  }else{HS = 0;}
                  if(ADNAME == null){
                    HN = 1;
                  }else{HN = 0;}
                  if(Balcony != null && hostspace != null && ADNAME != null ) {
                    w = 2;
                  }
                });
              },
              child: Container(
                width: size.width*0.25,
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
                      child: Text(AppLocalizations.of(context).next,style: TextStyle(
                          fontFamily: 'poppinslight',
                          fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _SecondPage(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          setState(() {
            w=1;
          });
        },
        child: Container(
          padding: EdgeInsets.only(
              top: size.height * 0.04,
              left: size.width * 0.07,
              bottom: size.height*0.025,
              right: size.width * 0.07),
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height*0.025,),
                    Text(
                      AppLocalizations.of(context).amenities,
                      style: TextStyle(
                          fontSize:17.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).wiFi,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenwifi,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenwifi = v;
                                print(amenwifi);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).bedroom,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenbedroom,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenbedroom = v;
                                print(amenbedroom);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).tV,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenTV,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenTV = v;
                                print(amenTV);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).garden,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenGarden,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenGarden = v;
                                print(amenGarden);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).heating,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenheating,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenheating = v;
                                print(amenheating);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).air_condition,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenarecondition,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenarecondition = v;
                                print(amenarecondition);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).house_safety,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenHomeSafty,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenHomeSafty = v;
                                print(amenHomeSafty);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).parking,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenParking,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenParking = v;
                                print(amenParking);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).pool,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenPool,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenPool = v;
                                print(amenPool);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).secure_camera,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenSecurityCamnira,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenSecurityCamnira = v;
                                print(amenSecurityCamnira);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).smoke_alarm,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amensmokealarm,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amensmokealarm = v;
                                print(amensmokealarm);
                              });
                            }
                        )
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context).pets,style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'
                        ),),
                        Checkbox(
                            value: amenPets,
                            activeColor: Theme.of(context).highlightColor,
                            onChanged: (v){
                              setState(() {
                                amenPets = v;
                                print(amenPets);
                              });
                            }
                        )
                      ],),
                  ],
                ),
              ),
              Positioned(
                  left:- size.width*0.04,
                  top:- size.height*0.01,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        w=1;
                      });
                    },
                    child: Container(
                      height: 50,width: 50,
                      child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                  )),
              Positioned(
                  right: size.width*0.01,
                  top:- size.height*0.01,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,width: 50,
                      child: Center(
                        child: Text(AppLocalizations.of(context).exit,style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 15,fontWeight: FontWeight.bold)),
                      ),),
                  )),
            ],
          )
          ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
w=3;
                });
              },
              child: Container(
                width: size.width*0.25,
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
                      child: Text(AppLocalizations.of(context).next,style: TextStyle(
                          fontFamily: 'poppinslight',
                          fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _ThirdPage(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          setState(() {
            w=2;
          });
        },
        child: Container(
            padding: EdgeInsets.only(
                top: size.height * 0.04,
                left: size.width * 0.07,
                bottom: size.height*0.025,
                right: size.width * 0.07),
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                (widget.hostfor == "For rent")?
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.025,),
                      Text(
                        AppLocalizations.of(context).house_Rules,
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              (CIN ==1)?
                              Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                              Text(AppLocalizations.of(context).checkin,
                                style: TextStyle(
                                    fontSize:15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppinslight'),),
                            ],
                          ),
                          new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              hint: Text(AppLocalizations.of(context).select,
                                style: TextStyle(
                                    fontSize:15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppinslight'),),
                              value: checkin,
                              items: <DropdownMenuItem<String>>[
                                new DropdownMenuItem(
                                  child: new Text('00:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '00:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('01:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '01:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('02:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '02:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('03:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '03:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('04:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '04:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('05:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '05:00',
                                ),new DropdownMenuItem(
                                  child: new Text('06:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '06:00',
                                ),new DropdownMenuItem(
                                  child: new Text('07:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '07:00',
                                ),new DropdownMenuItem(
                                  child: new Text('08:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '08:00',
                                ),new DropdownMenuItem(
                                  child: new Text('09:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '09:00',
                                ),new DropdownMenuItem(
                                  child: new Text('10:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '10:00',
                                ),new DropdownMenuItem(
                                  child: new Text('11:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '11:00',
                                ),new DropdownMenuItem(
                                  child: new Text('12:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '12:00',
                                ),new DropdownMenuItem(
                                  child: new Text('13:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '13:00',
                                ),new DropdownMenuItem(
                                  child: new Text('14:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '14:00',
                                ),new DropdownMenuItem(
                                  child: new Text('15:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '15:00',
                                ),new DropdownMenuItem(
                                  child: new Text('16:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '16:00',
                                ),new DropdownMenuItem(
                                  child: new Text('17:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '17:00',
                                ),new DropdownMenuItem(
                                  child: new Text('18:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '18:00',
                                ),new DropdownMenuItem(
                                  child: new Text('19:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '19:00',
                                ),new DropdownMenuItem(
                                  child: new Text('20:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '20:00',
                                ),new DropdownMenuItem(
                                  child: new Text('21:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '21:00',
                                ),new DropdownMenuItem(
                                  child: new Text('22:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '22:00',
                                ),new DropdownMenuItem(
                                  child: new Text('23:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '23:00',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  checkin = value;
                                  print(checkin);
                                });
                              },
                            ),
                          ),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              (COUT ==1)?
                              Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                              Text(AppLocalizations.of(context).checkout,
                                  style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                            ],
                          ),
                          new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              hint: Text(AppLocalizations.of(context).select,
                                  style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: checkout,
                              items: <DropdownMenuItem<String>>[
                                new DropdownMenuItem(
                                  child: new Text('00:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '00:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('01:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '01:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('02:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '02:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('03:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '03:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('04:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '04:00',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('05:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '05:00',
                                ),new DropdownMenuItem(
                                  child: new Text('06:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '06:00',
                                ),new DropdownMenuItem(
                                  child: new Text('07:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '07:00',
                                ),new DropdownMenuItem(
                                  child: new Text('08:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '08:00',
                                ),new DropdownMenuItem(
                                  child: new Text('09:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '09:00',
                                ),new DropdownMenuItem(
                                  child: new Text('10:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '10:00',
                                ),new DropdownMenuItem(
                                  child: new Text('11:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '11:00',
                                ),new DropdownMenuItem(
                                  child: new Text('12:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '12:00',
                                ),new DropdownMenuItem(
                                  child: new Text('13:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '13:00',
                                ),new DropdownMenuItem(
                                  child: new Text('14:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '14:00',
                                ),new DropdownMenuItem(
                                  child: new Text('15:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '15:00',
                                ),new DropdownMenuItem(
                                  child: new Text('16:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '16:00',
                                ),new DropdownMenuItem(
                                  child: new Text('17:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '17:00',
                                ),new DropdownMenuItem(
                                  child: new Text('18:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '18:00',
                                ),new DropdownMenuItem(
                                  child: new Text('19:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '19:00',
                                ),new DropdownMenuItem(
                                  child: new Text('20:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '20:00',
                                ),new DropdownMenuItem(
                                  child: new Text('21:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '21:00',
                                ),new DropdownMenuItem(
                                  child: new Text('22:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '22:00',
                                ),new DropdownMenuItem(
                                  child: new Text('23:00',
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '23:00',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  checkout = value;
                                  print(checkout);
                                });
                              },
                            ),
                          ),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              (AP ==1)?
                              Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                              Text(AppLocalizations.of(context).allow_pets,
                                  style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                            ],
                          ),
                          new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              hint: Text(AppLocalizations.of(context).select,
                                  style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: allowpets,
                              items: <DropdownMenuItem<String>>[
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).yes,
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'yes',
                                ),
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).no,
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'no',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  allowpets = value;
                                });
                              },
                            ),
                          ),
                        ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              (AS ==1)?
                              Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                              Text(AppLocalizations.of(context).allow_smoking,
                                  style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                            ],
                          ),
                          new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              hint: Text(AppLocalizations.of(context).select,
                                  style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: allowsmoking,
                              items: <DropdownMenuItem<String>>[
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).yes,
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'yes',
                                ),
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).no,
                                      style: TextStyle(
                                          fontSize:15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'no',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  allowsmoking = value;
                                });
                              },
                            ),
                          ),
                        ],),
                      SizedBox(height: size.height*0.025,),
                      Text(
                        AppLocalizations.of(context).price,
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins'),
                      ),

                      (widget.hostrentT == "Yearly")?
                          Column(
                            children: [
                              TextFormField(
                                initialValue:(price!=null)?price:"",
                                onChanged: (v) {
                                  setState(() {
                                    price = v;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                      )
                                  ),
                                  labelText:
                                  (MAD ==1)?
                                  "*  ${AppLocalizations.of(context).mmonthly}":
                                  AppLocalizations.of(context).mmonthly,
                                  labelStyle: TextStyle(
                                    color:
                                    (MAD ==1)?
                                    Colors.red:
                                    Colors.grey,
                                    fontFamily: 'poppinslight',
                                  ),
                                ),
                              ),
                              TextFormField(
                                // controller:  _tameenController,
                                initialValue: tameen,
                                onChanged: (v) {
                                  setState(() {
                                    tameen = v;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                      )
                                  ),
                                  labelText: AppLocalizations.of(context).deposit,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'poppinslight',
                                  ),
                                ),
                              ),
                              TextFormField(
                                // controller:  _comsyonController,
                                initialValue: comsyon,
                                onChanged: (v) {
                                  setState(() {
                                    comsyon = v;
                                    print(comsyon);
                                  });
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'OpenSans',
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                      )
                                  ),
                                  labelText: AppLocalizations.of(context).commission,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'poppinslight',
                                  ),
                                ),
                              )
                            ],
                          ):Column(
                        children: [
                          TextFormField(
                            initialValue:(price!=null)?price:"",
                            onChanged: (v) {
                              setState(() {
                                price = v;
                              });
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'OpenSans',
                            ),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey
                                  )
                              ),
                              labelText:
                              (MAD ==1)?
                              "*  ${AppLocalizations.of(context).dayly}":
                              AppLocalizations.of(context).dayly,
                              labelStyle: TextStyle(
                                color:
                                (MAD ==1)?
                                Colors.red:
                                Colors.grey,
                                fontFamily: 'poppinslight',
                              ),
                            ),
                          ),
                        ],
                      )
//                      TextFormField(
//                        initialValue:priceforsale,
//                        onChanged: (v) {
//                          setState(() {
//                            priceforsale = v;
//                          });
//                        },
//                        keyboardType: TextInputType.number,
//                        style: TextStyle(
//                          color: Colors.black,
//                          fontFamily: 'OpenSans',
//                        ),
//                        decoration: InputDecoration(
//                          focusedBorder: UnderlineInputBorder(
//                              borderSide: BorderSide(
//                                  color: Colors.grey
//                              )
//                          ),
//                          labelText:
//                          "Price",
//                          labelStyle: TextStyle(
//                            color:
//                            Colors.grey,
//                            fontFamily: 'poppinslight',
//                          ),
//                        ),
//                      )
                      ,
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).price_type,
                          style: TextStyle(
                              fontSize:15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppinslight'),
                        ),
                        ToggleSwitch(
                            fontSize: 15,
                            minWidth: size.width * 0.15,
                            minHeight: size.height*0.035,
                            cornerRadius: 20,
                            activeBgColor: Theme.of(context).highlightColor,
                            onToggle: (i) {
                              dollarORtl = i;
                            },
                            labels: ["TL", "\$"])
                      ],)
                    ],
                  ),
                ):
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.025,),
                      Text(
                        AppLocalizations.of(context).price,
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins'),
                      ),

                      TextFormField(
                        initialValue:(price!=null)?price:"",
                        onChanged: (v) {
                          setState(() {
                            price = v;
                          });
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          ),
                          labelText:
                          (priceSALE ==1)?
                          "*  ${AppLocalizations.of(context).price}":
                          AppLocalizations.of(context).price,
                          labelStyle: TextStyle(
                            color:
                            (priceSALE ==1)?
                            Colors.red:
                            Colors.grey,
                            fontFamily: 'poppinslight',
                          ),
                        ),
                      )
                      ,
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context).price_type,
                            style: TextStyle(
                                fontSize:15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),
                          ),
                          ToggleSwitch(
                              fontSize: 15,
                              minWidth: size.width * 0.15,
                              minHeight: size.height*0.035,
                              cornerRadius: 20,
                              activeBgColor: Theme.of(context).highlightColor,
                              onToggle: (i) {
                                dollarORtl = i;
                              },
                              labels: ["TL", "\$"])
                        ],)
                    ],
                  ),
                )
                ,
                Positioned(
                    left:- size.width*0.04,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          w=2;
                        });
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                    )),
                Positioned(
                    right: size.width*0.01,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Center(
                          child: Text(AppLocalizations.of(context).exit,style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 15,fontWeight: FontWeight.bold)),
                        ),),
                    )),
              ],
            )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {

                  if(checkin == null){
                    CIN = 1;
                  }else{CIN = 0;}
                  if(checkout == null){
                    COUT = 1;
                  }else{COUT = 0;}
                  if(allowpets == null){
                    AP = 1;
                  }else{AP = 0;}
                  if(allowsmoking == null){
                    AS = 1;
                  }else{AS = 0;}
                  if(price ==  null || price == "0"|| price == ""){
                    priceSALE = 1;
                  }else{priceSALE = 0;}
                  if((price == null || price == "0"|| price == "") ){
                    MAD = 1;
                  }else{MAD = 0;}
                  if(widget.hostfor == "For rent") {
                    if (checkin != null && checkout != null &&
                        allowpets != null && allowsmoking != null &&
                        ((price != null && price != "0" &&
                            price != "") )) {
                      w = 4;
                    }
                  }else{
                    if(price !=  null && price != "0"&& price != "") {
                      w = 4;
                    }
                  }
                });
              },
              child: Container(
                width: size.width*0.25,
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
                      child: Text(AppLocalizations.of(context).next,style: TextStyle(
                          fontFamily: 'poppinslight',
                          fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _ForthPage(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          setState(() {
            w=3;
          });
        },
        child: Container(
            padding: EdgeInsets.only(
                top: size.height * 0.04,
                left: size.width * 0.07,
                bottom: size.height*0.025,
                right: size.width * 0.07),
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.045,),
                      Row(
                        children: [
                          (DES ==1)?
                          Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                          Text(
                            AppLocalizations.of(context).description,
                            style: TextStyle(
                                fontSize:17.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.02,),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1,
                                color: Colors.black
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
                          child: TextFormField(
                            initialValue: Description,
                            onChanged: (v) {
                              setState(() {
                                Description = v;
                              });
                            },
                            maxLines: 16,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'OpenSans',
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context).write_here,
                              hintStyle: TextStyle(
                                // color: Colors.black,
                                fontFamily: 'poppinslight',
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              (MIMG ==1)?
                              Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                              Text(
                                AppLocalizations.of(context).main_Image,
                                style: TextStyle(
                                    fontSize:17.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppins'),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              if(_image == null) {
                                getImage();
                              }else{}
                            },
                            child: Container(
                              width: size.width*0.2,
                              height: size.height*0.04,
                              decoration: BoxDecoration(
                                  color:(_image ==null)? Theme.of(context).primaryColor:Colors.grey,
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
                                    child: Text(AppLocalizations.of(context).upload,style: TextStyle(
                                        fontFamily: 'poppinslight',color: Colors.white,
                                        fontSize: 15,fontWeight: FontWeight.bold),)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.01,),
                      Container(
                        height: size.height*0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1,
                                color: Colors.black
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
                          child: Center(child:
                          _image == null
                              ? Text(AppLocalizations.of(context).nothing_here,
                            style: TextStyle(
                                fontSize:15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppinslight'),)
                              : Stack(children: [
                                Image.file(_image,fit: BoxFit.cover,),
                            Positioned(
                                right: size.width*0.025,
                                top: 0,
                                child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                    child:Container(
                                      height: size.height*0.03,width: size.width*0.05,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Center(child:Icon(Icons.remove_circle,
                                        color: Theme.of(context).primaryColor
                                        ,size: 25,),),
                                    )
                                )),
                          ])
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left:- size.width*0.04,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          w=3;
                        });
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                    )),
                Positioned(
                    right: size.width*0.01,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Center(
                          child: Text(AppLocalizations.of(context).exit,style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 15,fontWeight: FontWeight.bold)),
                        ),),
                    )),
              ],
            )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  if(Description == null || Description ==""){
                    DES = 1;
                  }else{DES = 0;}
                  if(_image == null){
                    MIMG = 1;
                  }else{MIMG = 0;}
      if(Description != null && Description!="" && _image != null) {
        w = 5;
      }
                });
              },
              child: Container(
                width: size.width*0.25,
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
                      child: Text(AppLocalizations.of(context).next,style: TextStyle(
                          fontFamily: 'poppinslight',
                          fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _FifthPage(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          setState(() {
            w=4;
          });
        },
        child: Container(
            padding: EdgeInsets.only(
                top: size.height * 0.04,
                left: size.width * 0.07,
                bottom: size.height*0.025,
                right: size.width * 0.07),
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.03,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              (IMGS ==1)?
                              Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                              Text(
                                AppLocalizations.of(context).host_Images,
                                style: TextStyle(
                                    fontSize:17.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppins'),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              if(_pickFileList.length <15){
                                uploadImage();
                              }else{

                              }
                              },
                            child: Container(
                              width: size.width*0.2,
                              height: size.height*0.04,
                              decoration: BoxDecoration(
                                  color:(_pickFileList.length <15)? Theme.of(context).primaryColor :Colors.grey,
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
                                    child: Text(AppLocalizations.of(context).upload,style: TextStyle(
                                        fontFamily: 'poppinslight',color: Colors.white,
                                        fontSize: 15,fontWeight: FontWeight.bold),)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.01,),
                      Container(
                        height: size.height*0.725,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 1,
                                color: Colors.black
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeIn,
                            child: SizedBox(
                              width: 500,
                              height:size.height,
                              child: GridView.builder(
                                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                                  //scrollDirection: Axis.horizontal,
                                  itemCount:
                                  (_pickFileList == null||_pickFileList == []) ? 0 :
                                  (_pickFileList.length < 15)?
                                  _pickFileList.length:15,
                                  // ignore: missing_return
                                  itemBuilder: (context, index)=>
                                      show(index)

                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left:- size.width*0.04,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          w=4;
                        });
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                    )),
                Positioned(
                    right: size.width*0.01,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Center(
                          child: Text(AppLocalizations.of(context).exit,style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 15,fontWeight: FontWeight.bold)),
                        ),),
                    )),
              ],
            )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${AppLocalizations.of(context).photos} (${_pickFileList.length} / 15)",style: TextStyle(
                fontFamily: 'poppinslight',
                fontSize: 15,fontWeight: FontWeight.bold),),
            GestureDetector(
              onTap: (){
                setState(() {
                  if(_pickFileList == null||_pickFileList == []||_pickFileList.length<3){
                    IMGS = 1;
                  }else{IMGS = 0;}
                  if(_pickFileList != null&&_pickFileList != []&&_pickFileList.length>2) {
                    w = 6;
                  }
                });
              },
              child: Container(
                width: size.width*0.25,
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
                      child: Text(AppLocalizations.of(context).next,style: TextStyle(
                          fontFamily: 'poppinslight',
                          fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String YEAR = DateTime.now().year.toString();
  String MONTH = DateTime.now().month.toString();
  String DAY = DateTime.now().day.toString();
  int random = Random().nextInt(999);
  Widget _SixthPage(){
    Size size = MediaQuery.of(context).size;
    var obJID = "$YEAR$MONTH$DAY$random";
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          setState(() {
            w=5;
          });
        },
        child: Container(
            padding: EdgeInsets.only(
                top: size.height * 0.04,
                left: size.width * 0.07,
                bottom: size.height*0.025,
                right: size.width * 0.07),
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height*0.025,),
                      Text(
                        AppLocalizations.of(context).address,
                        style: TextStyle(
                            fontSize:17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppins'),
                      ),
                      SizedBox(height: size.height*0.01,),
                      TextFormField(
                        readOnly: true,
                        initialValue:widget.city,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey
                            )
                          ),
                          labelText: AppLocalizations.of(context).city,
                          labelStyle: TextStyle(
                             color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight',
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.01,),
                      TextFormField(
                        readOnly: true,
                        initialValue:widget.state,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          ),
                          labelText: AppLocalizations.of(context).state,
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight',
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.01,),
                      TextFormField(
                        initialValue:street,
                        onChanged: (v) {
                          setState(() {
                            street = v;
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey
                            )
                          ),
                          labelText:
                          (ST ==1)?
                          "*  ${AppLocalizations.of(context).street}":
                          AppLocalizations.of(context).street,
                          labelStyle: TextStyle(
                            color: (ST ==1)?
                            Colors.red:
                            Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight',
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.01,),
                      TextFormField(
                        initialValue:postcode,
                        onChanged: (v) {
                          setState(() {
                            postcode = v;
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              )
                          ),
                          labelText:
                          (PC ==1)?
                          "*  ${AppLocalizations.of(context).postCode}":
                          AppLocalizations.of(context).postCode,
                          labelStyle: TextStyle(
                            color: (PC ==1)?
                            Colors.red:
                            Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left:- size.width*0.04,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          w=5;
                        });
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                    )),
                Positioned(
                    right: size.width*0.01,
                    top:- size.height*0.01,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,width: 50,
                        child: Center(
                          child: Text(AppLocalizations.of(context).exit,style: TextStyle(
                              fontFamily: 'poppins',
                              fontSize: 15,fontWeight: FontWeight.bold)),
                        ),),
                    )),
              ],
            )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  if(street == null || street ==""){
                    ST = 1;
                  }else{ST = 0;}
                  if(postcode == null||postcode ==""){
                    PC = 1;
                  }else{PC = 0;}
                  if(dollarORtl == 0){
                    setState(() {
                      DorTL = "TL";
                    });
                  }else{
                    setState(() {
                      DorTL = "\$";
                    });}
                });
                _ADDNEWHOSTBUTTON(obJID);
                if(_pickFileList != null || _pickFileList != []) {
                  for( i = 0; i < _pickFileList.length; i++) {
                    _ADDPHOTOSBUTTON(i,obJID);
                  }
                }else{
                  print("there is smth wrong");
                }

              },
              child: Container(
                width: size.width*0.25,
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
                      child: Text(AppLocalizations.of(context).share,style: TextStyle(
                          fontFamily: 'poppinslight',
                          fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _ThanksPage(){
    Size size = MediaQuery.of(context).size;
    int obJID = Random().nextInt(999999999);
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          setState(() {
            w=6;
          });
        },
        child: Container(
            padding: EdgeInsets.only(
                top: size.height * 0.04,
                left: size.width * 0.07,
                bottom: size.height*0.025,
                right: size.width * 0.07),
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height*0.1,),
                      Image.asset("assets/images/playstore.png",height: 200,width: 200,),
                      SizedBox(height: size.height*0.025,),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.calendarCheck,
                            color: Theme.of(context).primaryColor,
                            size: 25,
                          ),
                          SizedBox(width: size.width*0.05,),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context).your_ad_added_sucssefully,
                              style: TextStyle(fontFamily: 'poppinsbold',
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                // interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
                //   onAdShowedFullScreenContent: (InterstitialAd ad) =>
                //       print('$ad onAdShowedFullScreenContent.'),
                //   onAdDismissedFullScreenContent: (InterstitialAd ad) {
                //     print('$ad onAdDismissedFullScreenContent.');
                //     ad.dispose();
                //   },
                //   onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                //     print('$ad onAdFailedToShowFullScreenContent: $error');
                //     ad.dispose();
                //   },
                //   onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
                // );
                try {
                  interstitialAd.show();
                  Navigator.pop(context);
                }catch(e){
                  print("eeeeeeeeeeee $e");
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: size.width*0.25,
                height: size.height*0.06,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7.5),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),

                  ),
                  child: Center(
                      child: Text(AppLocalizations.of(context).done,style: TextStyle(
                          fontFamily: 'poppins',color: Colors.white,
                          fontSize: 15,fontWeight: FontWeight.bold),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




















  show(index){
    return Container(
        padding: EdgeInsets.all(1.5),
        child: Stack(
          children: [
            Center(child:Image.file( _pickFileList[index]),)
            ,
            Positioned(
                right: 0,top: 0,
                child: InkWell(
                    onTap: (){
                      setState(() {
                        _pickFileList.removeAt(index);
                      });
                    },
                    child:Container(
                      height: 20,width: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Center(child: Icon(Icons.remove_circle,
                        color: Theme.of(context).primaryColor
                        ,size: 15,),),
                    )
                )),

          ],
        )


    )
    ;
  }
  ImagePicker pickedFile = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path) ;
      } else {
        print('No image selected.');
      }
    });
  }
  uploadImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      List<PlatformFile> file =
      result.files.map((e) {
        if(_pickFileList.length <15){
          PFL = File(e.path);
        _pickFileList.add(PFL);
        print(_pickFileList.length);
        }
      }).toList();

      setState(() {

//        imagevalue = file.bytes;
//        _pickedImages.add(imagevalue);
      });

    } else {
      // User canceled the picker
    }
  }
  Random rnd = Random();

  _ADDPHOTOSBUTTON(i, up){
    ////////for images
    int _seed= rnd.nextInt(999999999);
    Reference reference = FirebaseStorage.instance.ref().child("${up}/$_seed.png");
    final UploadTask uploadTask = reference.putFile(_pickFileList[i]);
    uploadTask.whenComplete(() async {
      img = await uploadTask.snapshot.ref.getDownloadURL();
      // _objImages.add(img);
      FirebaseFirestore.instance.collection("Images").doc("$_seed").set({
        "id" : _seed,
        "obj_ID" : int.parse(up),
        "image" : img
      });
    });
  }

  _ADDNEWHOSTBUTTON( up){
    //////////////for another data
    int _sed= rnd.nextInt(999999999);
    Reference ref = FirebaseStorage.instance.ref().child("${up}/$_sed.png");
    final UploadTask UPloadTask = ref.putFile(_image);
    UPloadTask.whenComplete(() async {
      Homeimg = await UPloadTask.snapshot.ref.getDownloadURL();
      FirebaseFirestore.instance
          .collection('Objects')
          .doc("${up}")
          .set({
        "id": "${up}",
        "ADowner": ownerName,
        "ADID": ADID,
        "city": widget.city,
        "state": widget.state,
        "objname": ADNAME,
        'type': widget.hostKind,
        'kira_tameen': "${tameen}",
        'kira_comsyn': "${comsyon}",
        'address': street,
        'postcode': postcode,
        'bedroomNO': bedroomNO,
        'floorNO': floorNO,
        'roomNO': widget.roomNO,
        'bathroomNO': bathroomNo,
        'maxNO_person':maxpeople,
        'amenWIFI': amenwifi,
        'amenbedroom': amenbedroom,
        'amenTV': amenTV,
        'amengarden': amenGarden,
        'amenheating': amenheating,
        'amenAirCondition': amenarecondition,
        'amenHomesafty': amenHomeSafty,
        'amenparking': amenParking,
        'amenpool': amenPool,
        'amensecureCamera': amenSecurityCamnira,
        'amensmoke': amensmokealarm,
        'amenpets': amenPets,
        'checkIN': checkin,
        'checkOUT': checkout,
        'allowPets': allowpets,
        'allowSmoking': allowsmoking,
        'information': Description,
        'image':Homeimg,
        'rent_time_for':widget.hostrentT,
        'hostAD_from':widget.hostO,
        'hosr_sale_rent':widget.hostfor,
        'balcony':Balcony,
        'price':price,
        'hostspace':hostspace,
        'money_type':DorTL,
        'objState':"Active",
        'ads_time':DateTime.now(),
        'name_l':name_l,
        'awaiting_approval':'Awaiting approval'
      });
    });
    fToast.showToast(
      child: Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Theme.of(context).primaryColor,
            ),
            child: Text(AppLocalizations.of(context).ad_successfully_added,
              style: TextStyle(
                  color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
      ),
      gravity: ToastGravity.BOTTOM,

      toastDuration: Duration(seconds: 2),
    );
    setState(() {
      w = 7;
    });
  }
String ownerName,ADID,name_l;
  InterstitialAd interstitialAd;
  Future getInterstitADS() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));

  }
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo: widget.user.uid).snapshots().listen((event) {
      event.docs.forEach((element) {
        ownerName = element['name_f'];
        name_l = element['name_l'];
        ADID = element['id'];
      });
    });

    InterstitialAd.load(
        adUnitId: 'ca-app-pub-6540722261762138/7567422309',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this.interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));


  }



}

import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/des/more_des/report_thanks.dart';


class ReportUserPage extends StatefulWidget {
  User user;
  final hostid;
  ReportUserPage({this.user,this.hostid});
  @override
  _ReportUserPageState createState() => _ReportUserPageState();
}

class _ReportUserPageState extends State<ReportUserPage> {

  String page = "main";
  int reportID = 0;

  String hostedName;
  String hostedID;
  String userPhoto;
  String hostedinfo;
  String mesj="";
  FToast fToast;
  String GruopChatID;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.hostid).snapshots().listen((v) {
      v.docs.forEach((element) {
        hostedName = element["name_f"];
        hostedinfo = element['user_info'];
        hostedID = element['id'];
        userPhoto = element['image'];
      });
    });

  }
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return (page == "main")?_widgetMain():_widgetAnother();
  }

  _widgetMain(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.only(
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
                AppLocalizations.of(context).what_happening,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text(
                AppLocalizations.of(context).this_wont_be_shared_with_host,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinslight'),
              ),
              SizedBox(
                height: size.height * 0.075,
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  setState(() {
                    reportID = 1;
                  });
                },
                height: size.height*0.075,
                highlightColor: Colors.black54,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).i_think_they_scamming_spamming_me,
                        style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                    ),
                    Container(
                      height: size.height*0.05,
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                          color: (reportID == 1)?Colors.black:Colors.white,
                          border: Border.all(
                              width: size.width*0.005,
                              color: (reportID == 1)?Colors.black:Colors.black
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child:(reportID == 1)? Icon(FontAwesomeIcons.check,color: Colors.white,size: 22.5,):Container(height: 0,width: 0,),
                      ),
                    )
                  ],
                ),
              ),
              _line(context),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  setState(() {
                    reportID = 2;
                  });
                },
                height: size.height*0.075,
                highlightColor: Colors.black54,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).they_being_offensive,
                        style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                    ),
                    Container(
                      height: size.height*0.05,
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                          color: (reportID == 2)?Colors.black:Colors.white,
                          border: Border.all(
                              width: size.width*0.005,
                              color: (reportID == 2)?Colors.black:Colors.black
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child:(reportID == 2)? Icon(FontAwesomeIcons.check,color: Colors.white,size: 22.5,):Container(height: 0,width: 0,),
                      ),
                    )
                  ],
                ),
              ),
              _line(context),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  setState(() {
                    reportID = 3;
                  });
                },
                height: size.height*0.075,
                highlightColor: Colors.black54,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context).its_something_else,
                        style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight'),
                      ),
                    ),
                    Container(
                      height: size.height*0.05,
                      width: size.width*0.1,
                      decoration: BoxDecoration(
                          color: (reportID == 3)?Colors.black:Colors.white,
                          border: Border.all(
                              width: size.width*0.005,
                              color: (reportID == 3)?Colors.black:Colors.black
                          ),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child:(reportID == 3)? Icon(FontAwesomeIcons.check,color: Colors.white,size: 22.5,):Container(height: 0,width: 0,),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: (){
              setState(() {
                if(reportID == 3 ){
                  page = "another";
                }
                else if(reportID ==1){
                  Random rnd = Random();
                  var rnd1 = rnd.nextInt(500000000).toString();
                  var msgNO = rnd.nextInt(500000000).toString();
                  FirebaseFirestore.instance
                      .collection('reports')
                      .doc('reports')
                      .collection("user")
                      .doc(rnd1)
                      .set({
                    "id":"$rnd1",
                    "host_ID":hostedID,
                    'reporter_ID': widget.user.uid,
                    'msg':"I think they\'re scamming or spamming me",
                    'reportTime':DateTime.now()
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Report_thanks()));
                }else if(reportID == 2){
                  Random rnd = Random();
                  var rnd1 = rnd.nextInt(500000000).toString();
                  var msgNO = rnd.nextInt(500000000).toString();
                  FirebaseFirestore.instance
                      .collection('reports')
                      .doc('reports')
                      .collection("user")
                      .doc(rnd1)
                      .set({
                    "id":"$rnd1",
                    "host_ID":hostedID,
                    'reporter_ID': widget.user.uid,
                    'msg':"They're being offensive",
                    'reportTime':DateTime.now()
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Report_thanks()));

                }
              });
            },
            child:(reportID != 0)?Container(
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
                    child: Text(AppLocalizations.of(context).next,style: TextStyle(
                        fontFamily: 'poppinsbold',color: Colors.white,
                        fontSize: 17.5,fontWeight: FontWeight.bold),)),
              ),
            ):Container(
              width: size.width*0.25,
              height: size.height*0.06,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(7.5),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: Center(
                    child: Text(AppLocalizations.of(context).next,style: TextStyle(
                        fontFamily: 'poppinsbold',color: Colors.white,
                        fontSize: 17.5,fontWeight: FontWeight.bold),)),
              ),
            )

        ),
      ),
    );
  }

  _widgetAnother(){
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").doc(widget.hostid).snapshots(),
        builder: (context, snapshot) {
          return (!snapshot.hasData)?
          Container(height: 0,width: 0,):
          Scaffold(
            body: WillPopScope(
              // ignore: missing_return
              onWillPop: () {
                setState(() {
                  page = "main";
                });
              },
              child: Padding(
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
                          setState(() {
                            page = "main";
                          });
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
                        "${AppLocalizations.of(context).report} ${snapshot.data['name_f']} ${snapshot.data['name_l']}",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinsbold'),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Text(
                        AppLocalizations.of(context).why_are_you_upset,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinsbold'),
                      ),
                      SizedBox(height: size.height*0.02,),
                      Container(
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
                            maxLines: 10,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'poppinslight',
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  if(mesj.length>0){
                    Random rnd = Random();
                    var rnd1 = rnd.nextInt(500000000).toString();
                    var msgNO = rnd.nextInt(500000000).toString();
                    FirebaseFirestore.instance
                        .collection('reports')
                        .doc('reports')
                        .collection("user")
                        .doc(rnd1)
                        .set({
                      "id":"$rnd1",
                      "host_ID":hostedID,
                      'reporter_ID': widget.user.uid,
                      'msg':mesj,
                      'reportTime':DateTime.now()
                    });

                    Navigator.pop(context);
                  }
                },
                child:(mesj.length>0)? Container(
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
                        child: Text(AppLocalizations.of(context).send_message,style: TextStyle(
                            fontFamily: 'poppins',color: Colors.white,
                            fontSize: 15,fontWeight: FontWeight.bold),)),
                  ),
                ): Container(
                  width: size.width*0.25,
                  height: size.height*0.06,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(7.5),

                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Center(
                        child: Text(AppLocalizations.of(context).send_message,style: TextStyle(
                            fontFamily: 'poppins',color: Colors.white,
                            fontSize: 15,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

}

import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedbackPage extends StatefulWidget {
  User user;
  FeedbackPage({this.user});
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}
enum SingingCharacter {suggestion, complaint }

class _FeedbackPageState extends State<FeedbackPage> {
  bool submit = false;
  SingingCharacter _character = SingingCharacter.suggestion;
  String _type = "suggestion";
  FToast fToast;
  TextEditingController _feedback_msg = TextEditingController();
  String get _feedback => _feedback_msg.text;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
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
                AppLocalizations.of(context).hi_tell_what_think_about,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
              SizedBox(
                height: size.height * 0.075,
              ),
              Container(
                child: Column(
                  children: [
                    Column(
                      children: <Widget>[
                        RadioListTile<SingingCharacter>(
                          title: Text(AppLocalizations.of(context).suggestion,style: TextStyle(
                              fontSize: 17.5,
                              fontFamily: 'poppins')),
                          value: SingingCharacter.suggestion,
                          groupValue: _character,
                          activeColor: Colors.black,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              _type = "suggestion";
                              print(_character);
                            });
                          },
                        ),
                        RadioListTile<SingingCharacter>(
                          title:  Text(AppLocalizations.of(context).complaint,style: TextStyle(
                              fontSize: 17.5,
                              fontFamily: 'poppins')),
                          value: SingingCharacter.complaint,
                          groupValue: _character,
                          activeColor: Colors.black,
                          onChanged: (SingingCharacter value) {
                            setState(() {
                              _character = value;
                              _type ="complaint";
                              print(_character);
                            });
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.035,
                        ),
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
                              controller: _feedback_msg,
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

                  ],
                ),
              )
            ],
          ),
        ),
      ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: (){
              if(_feedback.length>9){
                Random rnd = Random();
                var rnd1 = rnd.nextInt(500000000).toString();
                (_type == "suggestion")?
                FirebaseFirestore.instance
                    .collection('feedback/sugesstions/messages')
                    .doc(rnd1)
                    .set({
                  "id": rnd1,
                  "user_email":widget.user.email,
                  'user_id': widget.user.uid,
                  'type': _type,
                  'msg':_feedback,
                }):
                FirebaseFirestore.instance
                    .collection('feedback/complaint/messages')
                    .doc(rnd1)
                    .set({
                  "id": rnd1,
                  "user_email":widget.user.email,
                  'user_id': widget.user.uid,
                  'type': _type,
                  'msg':_feedback,
                });
                Navigator.pop(context);
                fToast.showToast(
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.black,
                        ),
                        child: Text(AppLocalizations.of(context).thankU,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                  ),
                  gravity: ToastGravity.BOTTOM,

                  toastDuration: Duration(seconds: 2),
                );
              }
            },
            child:(_feedback.length>9)? Container(
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
                    child: Text(AppLocalizations.of(context).send_feedback,style: TextStyle(
                        fontFamily: 'poppinsbold',color: Colors.white,
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
                    child: Text(AppLocalizations.of(context).send_feedback,style: TextStyle(
                        fontFamily: 'poppins',color: Colors.white,
                        fontSize: 15,fontWeight: FontWeight.bold),)),
              ),
            ),
          ),
        )
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_mate_app/screens/profile/pages/contactus/send_msj_to_admin.dart';
import 'package:home_mate_app/screens/profile/pages/settings/languages.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ContactUSPage extends StatefulWidget {
  User user;
  ContactUSPage({this.user});
  @override
  _ContactUSPageState createState() => _ContactUSPageState();
}

class _ContactUSPageState extends State<ContactUSPage> {

  FToast fToast;
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
            top: size.height * 0.08,
            left: size.width * 0.07,
            right: size.width * 0.07),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                AppLocalizations.of(context).contact_us,
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
              SizedBox(
                height: size.height * 0.075,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      MessageAdmin(user: widget.user,)));
                },
                child: InkWell(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.message,color: Colors.black,size: 25,),
                      SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                      Text(AppLocalizations.of(context).sendmessage,style: TextStyle(fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              InkWell(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.inbox,size: 25,color: Colors.black,),
                        SizedBox(width: size.width*0.05,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).send_email,style: TextStyle(fontFamily: 'poppins',fontSize: 17.5,color: Colors.black,fontWeight: FontWeight.bold),),
                            Text("khaledmt96@gmail.com",style: TextStyle(fontFamily: 'poppins',fontSize: 12.5))
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: (){
                        Clipboard.setData(new ClipboardData(text: "khaledmt96@gmail.com"));
                        fToast.showToast(
                          child: Padding(
                            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                            child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.black,
                                ),
                                child: Text(AppLocalizations.of(context).copied_to_Clipboard,
                                  style: TextStyle(
                                      color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                          ),
                          gravity: ToastGravity.BOTTOM,

                          toastDuration: Duration(seconds: 2),
                        )
                        ;
                      },
                      icon: Icon(Icons.copy),
                      highlightColor: Colors.black12,
                      splashRadius: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Report_thanks extends StatefulWidget {
  User user;
  Report_thanks({this.user});
  @override
  _Report_thanksState createState() => _Report_thanksState();
}

class _Report_thanksState extends State<Report_thanks> {
  String creditNO;
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
                AppLocalizations.of(context).we_got_your_report,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
              SizedBox(
                height: size.height * 0.075,
              ),
              //TODO
              Text(
                AppLocalizations.of(context).thanks_for_sharing_your_opinion,
                style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: (){
              setState(() {
               Navigator.pop(context);
               Navigator.pop(context);
              });
            },
            child:Container(
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
                        fontFamily: 'poppinsbold',color: Colors.white,
                        fontSize: 17.5,fontWeight: FontWeight.bold),)),
              ),
            )

        ),
      ),
    );
  }
}


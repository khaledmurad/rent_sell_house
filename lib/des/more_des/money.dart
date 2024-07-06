import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Money_ALL extends StatefulWidget {
  final Oid;
  Money_ALL({this.Oid});

  @override
  _Money_ALLState createState() => _Money_ALLState();
}

class _Money_ALLState extends State<Money_ALL> {
  String mainLang;

  getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     mainLang = prefs.get("mainLang");

  }

  adFrom( from){
      switch(from){
        case "Real Estate Agency" :return AppLocalizations.of(context).real_Estate_Agency;break;
        case "Owner" :return AppLocalizations.of(context).owner;break;
      }
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
    print("mainLang -> $mainLang");
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Objects").doc(widget.Oid).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.08,
                    left: size.width * 0.07,
                    right: size.width * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Text(
                      AppLocalizations.of(context).about_Money,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinsbold'),
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.userAlt,size: 17.5,color: Colors.black,),
                        SizedBox(width: size.width*0.05,),
                        Text("${AppLocalizations.of(context).host_from} : ${adFrom(snapshot.data['hostAD_from'])}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    (snapshot.data['hosr_sale_rent'] == "For rent")?
                    Column(
                      children: [
                        (snapshot.data['rent_time_for'] == 'Yearly')?
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.moneyBillWave,size: 17.5,color: Colors.black,),
                                SizedBox(width: size.width*0.05,),
                                Text("${AppLocalizations.of(context).for_month} : ${snapshot.data['price']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.moneyBillWave,size: 17.5,color: Colors.black,),
                                SizedBox(width: size.width*0.05,),
                                Text("${AppLocalizations.of(context).deposit} : ${snapshot.data['kira_tameen']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.moneyBillWave,size: 17.5,color: Colors.black,),
                                SizedBox(width: size.width*0.05,),
                                Text("${AppLocalizations.of(context).commission} : ${snapshot.data['kira_comsyn']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ],
                        ):
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyBillWave,size: 17.5,color: Colors.black,),
                            SizedBox(width: size.width*0.05,),
                            Text("${AppLocalizations.of(context).for_day} : ${snapshot.data['price']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                          ],
                        ),

                      ],
                    ):
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.moneyBillWave,size: 17.5,color: Colors.black,),
                        SizedBox(width: size.width*0.05,),
                        Text("${AppLocalizations.of(context).price} : ${snapshot.data['price']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                      ],
                    ),

                  ],
                ),
              ),
            );
          }else{return Container();}
        }
    );
  }
}

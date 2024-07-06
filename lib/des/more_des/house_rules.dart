import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HouseRules extends StatelessWidget {
  final Oid;
  HouseRules({this.Oid});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Objects").doc(Oid).snapshots(),
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
                    AppLocalizations.of(context).house_Rules,
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
                      Icon(FontAwesomeIcons.clock,size: 17.5,color: Colors.black,),
                      SizedBox(width: size.width*0.05,),
                      Text("${AppLocalizations.of(context).checkin} : ${snapshot.data['checkIN']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.clock,size: 17.5,color: Colors.black,),
                      SizedBox(width: size.width*0.05,),
                      Text("${AppLocalizations.of(context).checkout} : ${snapshot.data['checkOUT']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  (snapshot.data['allowPets'] ==null)?
                      Container(height: 0,width: 0,):
                  (snapshot.data['allowPets'] =="yes")?
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.paw,size: 17.5,color: Colors.black,),
                          SizedBox(width: size.width*0.05,),
                          Text(AppLocalizations.of(context).pets,style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ):
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.paw,size: 17.5,color: Colors.black54,),
                          SizedBox(width: size.width*0.05,),
                          Text(AppLocalizations.of(context).no_pets,style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black54,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                  (snapshot.data['allowSmoking'] ==null)?
                  Container(height: 0,width: 0,):
                  (snapshot.data['allowSmoking'] =="yes")?
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.smoking,size: 17.5,color: Colors.black,),
                          SizedBox(width: size.width*0.05,),
                          Text(AppLocalizations.of(context).smoking_allow,style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ):
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.smokingBan,size: 17.5,color: Colors.black54,),
                          SizedBox(width: size.width*0.05,),
                          Text(AppLocalizations.of(context).smoking_Not_allow,style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black54,fontWeight: FontWeight.bold),),
                        ],
                      ),

                    ],
                  ),
                  (snapshot.data['maxNO_person'] =="more")?
                  Container(height: 0,width: 0,):
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.users,size: 17.5,color: Colors.black,),
                          SizedBox(width: size.width*0.05,),
                          Text("${AppLocalizations.of(context).max_persons} \"${snapshot.data['maxNO_person']}\"",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,color: Colors.black,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }else{return Container();}
      }
    );
  }
}

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/models/view.dart';


class ALL_AMENITIES extends StatelessWidget {
  final Oid;
  Objects bojs;
  ALL_AMENITIES({this.Oid,this.bojs});
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
                  child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  AppLocalizations.of(context).amenities,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppinsbold'),
                ),
                SizedBox(
                  height: size.height * 0.035,
                ),
                Container(child: (bojs.amenWIFI == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).wiFi,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesome.wifi,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).wiFi,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesome.wifi,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(
                  child: (bojs.amenTV == true)?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).tV,
                        style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        FontAwesome.tv,
                        size: 20,
                        color: Colors.black,
                      ),
                    ],
                  ):Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context).tV,
                        style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,decorationThickness: 2),
                      ),
                      Icon(
                        FontAwesome.tv,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amenAirCondition == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).air_condition,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesome.snowflake_o,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).air_condition,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesome.snowflake_o,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amenheating== true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).heating,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesome.thermometer_empty,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).heating,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesome.thermometer_empty,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amenpool == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).pool,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.swimmingPool,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).pool,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesomeIcons.swimmingPool,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amenHomesafty == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).house_safety,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.shieldAlt,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).house_safety,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesomeIcons.shieldAlt,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amengarden == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).garden,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.tree,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).garden,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesomeIcons.tree,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amenparking == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).park,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.parking,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).park,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesomeIcons.parking,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amenpets == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).pets,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.paw,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).pets,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesomeIcons.paw,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amensecureCamera == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).secure_camera,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.video,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).secure_camera,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesomeIcons.video,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
                SizedBox(
                  height: size.height * 0.015,
                ),
                Container(child: (bojs.amensmoke == true)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).smoking,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      FontAwesomeIcons.smoking,
                      size: 20,
                      color: Colors.black,
                    ),
                  ],
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).smoking,
                      style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5, color: Colors.grey,fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,decorationThickness: 2),
                    ),
                    Icon(
                      FontAwesomeIcons.smoking,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),),
              ],
            ),
          )
      ),
    );;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/models/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Amenti extends StatelessWidget {
  final objID;
  Objects bojs;
  Amenti({this.objID,this.bojs});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child:
          (bojs.amenWIFI == true)?
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
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
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: (bojs.amenAirCondition == true)?
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: (bojs.amenheating == true)?
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: (bojs.amenpool == true)?
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
          ),
        ),
      ],
    );
  }
}


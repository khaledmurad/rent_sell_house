import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/screens/profile/pages/addCC/addnew.dart';

class PaymentPage extends StatefulWidget {
  User user;
  PaymentPage({this.user});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
                child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,
                  color: Theme.of(context).primaryColor,),
              ),
              SizedBox(
                height: size.height * 0.035,
              ),
              Text(
                "Edit payment methods",
                style: TextStyle(
                    color:Theme.of(context).primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
              SizedBox(
                height: size.height * 0.075,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewCard(user: widget.user,)));
                },
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.solidCreditCard,size: 20,),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Text(
                      "Credit or depit card",
                      style: TextStyle(
                          fontSize: 17.5,
                          fontFamily: 'poppins'),
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

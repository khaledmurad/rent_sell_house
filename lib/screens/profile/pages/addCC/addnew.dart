import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class AddNewCard extends StatefulWidget {
  User user;
  AddNewCard({this.user});
  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  String creditNO,CVV,EXDATE,cardHolder;
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
                "Add card details",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
              SizedBox(
                height: size.height * 0.075,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    onChanged: (v) {
                      setState(() {
                        cardHolder = v;
//                        FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
//                          value.reference.update(<String,dynamic>{
//                            R:"${v[0].toUpperCase() + v.substring(1)}"
//                          });
//                        });
                      });
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'poppins',
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                      ),
                      labelText: "Card holder",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'poppinslight',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  TextFormField(
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxx xxxx xxxx xxxx',
                        separator: ' ',
                      ),
                    ],                    //initialValue: text,
                    onChanged: (v) {
                      setState(() {
                        creditNO = v;
//                        FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
//                          value.reference.update(<String,dynamic>{
//                            R:"${v[0].toUpperCase() + v.substring(1)}"
//                          });
//                        });
                      });
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'poppins',
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),

                      ),
                      hintText: "0000 0000 0000 0000",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'poppinslight',
                      ),
                      labelText: "Add card number",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'poppinslight',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width*0.40,
                        child: TextFormField(
                          inputFormatters: [
                            MaskedTextInputFormatter(
                              mask: 'xx/xx',
                              separator: '/',
                            ),
                          ],                    //initialValue: text,
                          onChanged: (v) {
                            setState(() {
                              EXDATE = v;
//                        FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
//                          value.reference.update(<String,dynamic>{
//                            R:"${v[0].toUpperCase() + v.substring(1)}"
//                          });
//                        });
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                            ),
                            hintText: "  /  ",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'poppinslight',
                            ),
                            labelText: "Ex. date",
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'poppinslight',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width*0.40,
                        child: TextFormField(
                          inputFormatters: [
                            MaskedTextInputFormatter(
                              mask: 'xxxx',
                              separator: '',
                            ),
                          ],  //initialValue: text,
                          onChanged: (v) {
                            setState(() {
                              CVV = v;
//                        FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
//                          value.reference.update(<String,dynamic>{
//                            R:"${v[0].toUpperCase() + v.substring(1)}"
//                          });
//                        });
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'poppins',
                          ),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),

                            ),
                            labelText: "CVV",
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'poppinslight',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.symmetric(vertical: size.height*0.0075),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {

                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                height: size.height*0.075,
                width: size.width*0.4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor
                ),
                child: Center(
                  child: Text(
                    "Add",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsbold'),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                height: size.height*0.075,
                width: size.width*0.4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  color: Colors.black54,
                ),
                child: Center(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsbold'),
                  ),
                ),
              ),
            )
          ],),
      ),
    );
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

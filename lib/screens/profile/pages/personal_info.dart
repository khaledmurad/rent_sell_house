import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Personal_Info extends StatefulWidget {
  User user;
  Personal_Info({this.user});
  @override
  _Personal_InfoState createState() => _Personal_InfoState();
}

class _Personal_InfoState extends State<Personal_Info> {
  DateTime _date  ;
  var _birthday ;
  int _dateDay,_dateMonth,_dateYear;
  final save_key = GlobalKey<FormState>();
  String gender;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.user.uid).snapshots().listen((v) {
      v.docs.forEach((element) {
        gender = element["gender"];
        _birthday = element['birthday'];
      });
    });  }
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).snapshots(),
        builder: (context , snapshat){
          if(snapshat.hasData){
            return Scaffold(
              body: Container(
                height: size.height,
                child: ListView(
                  padding: EdgeInsets.only(
                    // top: size.height * 0.08,
                      left: size.width * 0.07,
                      right: size.width * 0.07),
                 // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.05,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        GestureDetector(
                          //TODO
                          onTap: (){
                            if (save_key.currentState.validate()) {
                              save_key.currentState.save();
                              FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
                                value.reference.update(<String,dynamic>{
                                  "gender":gender,
                                  "birthday":_birthday
                                });
                              });
                              print('valid');
                            }else{
                              print('not valid');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Text(AppLocalizations.of(context).save,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins'),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    Text(
                      AppLocalizations.of(context).edit_personal_info,
                      style: TextStyle(
                          color:Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinsbold'),
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    Form(
                      key: save_key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context).pUBLIC_INFO,style: TextStyle(fontFamily: 'poppinslight',
                              color: Colors.grey,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold)),
                          _widgetEdit(capitalize(snapshat.data['name_f']), AppLocalizations.of(context).first_name,'name_f'),
                          _widgetEdit(capitalize(snapshat.data['name_l']), AppLocalizations.of(context).last_name,'name_l'),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          Text(AppLocalizations.of(context).pRIVATE_DETAILS,style: TextStyle(fontFamily: 'poppinslight',
                              color: Colors.grey,
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold)),
                          Column(
                            children: [
                              Container(
                                width: size.width,
                                child: DropdownButtonHideUnderline(
                                  child: new DropdownButton<String>(
                                    underline: SizedBox(
                                      height:  size.height*0.001,
                                      width: MediaQuery.of(context).size.width,
                                      child: Container(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    hint: Text(AppLocalizations.of(context).select,style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'poppinslight')),
                                    value: (gender=="")?null:gender,
                                    items: <DropdownMenuItem<String>>[
                                      new DropdownMenuItem(
                                        child: new Text(AppLocalizations.of(context).male,style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'poppins')),
                                        value: 'Male',
                                      ),
                                      new DropdownMenuItem(
                                        child: new Text(AppLocalizations.of(context).female,style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'poppins')),
                                        value: 'Female',
                                      ),
                                    ],
                                    onChanged: (String value) {
                                      setState(() {
                                        gender =value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:  size.height*0.001,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.015,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              TextFormField(
                                readOnly: true,
                                initialValue:_birthday==null ? snapshat.data["birthday"] :_birthday,
                                onTap: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: _date == null
                                          ? DateTime.now()
                                          : _date,
                                      firstDate: DateTime(1970),
                                      lastDate: DateTime(2022))
                                      .then((value) {
                                    setState(() {
                                      _dateDay = value.day;
                                      _dateMonth = value.month;
                                      _dateYear = value.year;
                                      _date = DateTime.parse("${value}");
                                      _birthday = "${_date.year}-${_date.month}-${_date.day}";
                                    });
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                    fontSize: 17),
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey
                                        )
                                    ),
                                    contentPadding: EdgeInsets.only(top: 14.0),
                                    //  errorText: showErrorText ?  'Password can\'t be empty' : null,
                                    labelText: AppLocalizations.of(context).date_birthday,
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,fontFamily: 'poppinslight'),
                                    hintText:
                                    (_birthday == null) ? null : _birthday,
                                    hintStyle: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                              ),
                              SizedBox(
                                height: size.height * 0.015,
                              )
                            ],
                          ),
                        //  _widgetEdit(snapshat.data['phone'], "Phone number", "phone"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                // controller:  _comsyonController,
                                initialValue: snapshat.data['phone'],
                                onSaved: (v) {
                                  setState(() {
                                    FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
                                      value.reference.update(<String,dynamic>{
                                        "phone":"${v[0].toUpperCase() + v.substring(1)}"
                                      });
                                    });
                                  });
                                },
                                inputFormatters: [
                                  MaskedTextInputFormatter(
                                    mask: 'xxx xxx xx xx',
                                    separator: ' ',
                                  ),
                                ],
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                      )
                                  ),
                                  labelText: AppLocalizations.of(context).phone_number,
                                  prefix: Text("(+90)  "),
                                  prefixStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'poppins',
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'poppinslight',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.015,
                              )
                            ],
                          ),
                          _widgetEdit(snapshat.data['city'], AppLocalizations.of(context).city, "city"),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                // controller:  _comsyonController,
                                initialValue: snapshat.data['user_info'],
                                onSaved: (v) {
                                  setState(() {
                                    FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
                                      value.reference.update(<String,dynamic>{
                                        'user_info':"${v[0].toUpperCase() + v.substring(1)}"
                                      });
                                    });
                                  });
                                },
                                maxLines: 4,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                      )
                                  ),
                                  labelText: "${snapshat.data['name_f']} ${AppLocalizations.of(context).information}",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'poppinslight',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.015,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }else{
            return Container(
              height: 0,
              width: 0,
            );
          }
        }
    );
  }

  _widgetEdit(String text,String tit,String R){
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          // controller:  _comsyonController,
          initialValue: text,
          onSaved: (v) {
            setState(() {
              FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).get().then((value){
                value.reference.update(<String,dynamic>{
                  R:"${v[0].toUpperCase() + v.substring(1)}"
                });
              });
            });
          },
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'poppins',
          ),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey
                )
            ),
            labelText: tit,
            labelStyle: TextStyle(
              color: Colors.grey,
              fontFamily: 'poppinslight',
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.015,
        )
      ],
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


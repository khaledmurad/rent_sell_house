import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate_app/auth/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:home_mate_app/screens/add_new/new_des.dart';
import 'package:provider/provider.dart';

enum Host_type {sale, rent }
enum Host_owner {owner, Real_Estate_Agency}
class AddNewPage extends StatefulWidget {
  AddNewPage({@required this.user});
  User user;
  @override
  _AddNewPageState createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  _AddNewPageState({@required this.user});
  User user;
  Host_type _hostT = Host_type.sale;
  Host_owner _hostO = Host_owner.Real_Estate_Agency;
  String _Htype = "For sale";
  String _Otype = "Real Estate Agency";
  String _value , roomCount , hostkind,ObjNAME,cityID,stateID;
  int CR = 0 , HK =0,C =0 ,S =0;



  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child:
      (widget.user !=null)?
      StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).snapshots(),
          builder: (context, snapshot) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.08,
                    left: size.width * 0.07,
                    bottom: size.height*0.05,
                    right: size.width * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppLocalizations.of(context).welcome} ${hostedName}",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins'),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Text(
                      AppLocalizations.of(context).add_new_ads,
                      style: TextStyle(
                          fontSize:17.5,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      "${AppLocalizations.of(context).you_are} :",
                      style: TextStyle(
                          fontSize:15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RadioListTile<Host_owner>(activeColor: Theme.of(context).highlightColor,
                          title:  Text(AppLocalizations.of(context).real_Estate_Agency),
                          value: Host_owner.Real_Estate_Agency,
                          groupValue: _hostO,
                          onChanged: (Host_owner value) {
                            setState(() {
                              _hostO = value;
                              _Otype = "Real Estate Agency";
                              print(_hostO);
                            });
                          },
                        ),
                        RadioListTile<Host_owner>(activeColor: Theme.of(context).highlightColor,
                          title:  Text(AppLocalizations.of(context).owner),
                          value: Host_owner.owner,
                          groupValue: _hostO,
                          onChanged: (Host_owner value) {
                            setState(() {
                              _hostO = value;
                              _Otype ="Owner";
                              print(_hostO);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      "${AppLocalizations.of(context).your_house} :",
                      style: TextStyle(
                          fontSize:15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppinslight'),
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RadioListTile<Host_type>(activeColor: Theme.of(context).highlightColor,
                          title:  Text(AppLocalizations.of(context).for_sale),
                          value: Host_type.sale,
                          groupValue: _hostT,
                          onChanged: (Host_type value) {
                            setState(() {
                              _hostT = value;
                              _Htype = "For sale";
                              print(_hostT);
                            });
                          },
                        ),
                        RadioListTile<Host_type>(activeColor: Theme.of(context).highlightColor,
                          title:  Text(AppLocalizations.of(context).for_rent),
                          value: Host_type.rent,
                          groupValue: _hostT,
                          onChanged: (Host_type value) {
                            setState(() {
                              _hostT = value;
                              _Htype ="For rent";
                              print(_hostT);
                            });
                          },
                        ),
                      ],
                    ),
                    (_hostT == Host_type.rent)?
                    Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppLocalizations.of(context).your_house_rent_for} :",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight'),
                            ),
                            Container(
                              width: size.width*0.4,
                              child: new DropdownButtonHideUnderline(
                                child: new DropdownButton<String>(
                                  hint: Text(AppLocalizations.of(context).select,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: _value,
                                  items: <DropdownMenuItem<String>>[
                                    new DropdownMenuItem(
                                      child: new Text(AppLocalizations.of(context).yearly,
                                          style: TextStyle(
                                              fontSize:12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppinslight')),
                                      value: 'Yearly',
                                    ),
                                    new DropdownMenuItem(
                                      child: new Text(AppLocalizations.of(context).monthly,
                                          style: TextStyle(
                                              fontSize:12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'poppinslight')),
                                      value: 'Monthly (tourist)',
                                    ),
                                  ],
                                  onChanged: (String value) {
                                    setState(() {
                                      _value = value;
                                      print(_value);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ):Container(height: 0,width: 0,),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (CR ==1)?
                            Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                            Text(
                              "${AppLocalizations.of(context).count_house_rooms} :",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight'),
                            ),
                          ],
                        ),
                        Container(
                          width: size.width*0.4,
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              hint: Text(AppLocalizations.of(context).select,
                                  style: TextStyle(
                                      fontSize:12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: roomCount,
                              items: <DropdownMenuItem<String>>[
                                new DropdownMenuItem(
                                  child: new Text('0+1',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '0+1',
                                ),
                                new DropdownMenuItem(
                                  child: new Text('1+1',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '1+1',
                                ),new DropdownMenuItem(
                                  child: new Text('2+1',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '2+1',
                                ),new DropdownMenuItem(
                                  child: new Text('3+1',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '3+1',
                                ),new DropdownMenuItem(
                                  child: new Text('3+2',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '3+2',
                                ),new DropdownMenuItem(
                                  child: new Text('4+1',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '4+1',
                                ),new DropdownMenuItem(
                                  child: new Text('4+2',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '4+2',
                                ),new DropdownMenuItem(
                                  child: new Text('4+3',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '4+3',
                                ),new DropdownMenuItem(
                                  child: new Text('5+1',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '5+1',
                                ),new DropdownMenuItem(
                                  child: new Text('5+2',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '5+2',
                                ),new DropdownMenuItem(
                                  child: new Text('5+3',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: '5+3',
                                ),new DropdownMenuItem(
                                  child: new Text('More',
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'More',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  roomCount = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    (_hostT == Host_type.rent)?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (HK ==1)?
                            Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),                          Text(
                              "${AppLocalizations.of(context).house_kind} :",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight'),
                            ),
                          ],
                        ),
                        Container(
                          width: size.width*0.4,
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              hint: Text(AppLocalizations.of(context).select,
                                  style: TextStyle(
                                      fontSize:12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: hostkind,
                              items: <DropdownMenuItem<String>>[
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).entire_house,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Entire house',
                                ),
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).cabins_Cattages,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Cabins and Cattages',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).apartment,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Apartment',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).hotel,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Hotel',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).villa,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Villa',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).tiny_house,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Tiny house',
                                ),
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).housemate,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Housemate',
                                )
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  hostkind = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (HK ==1)?
                            Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                            Text(
                              "${AppLocalizations.of(context).house_kind} :",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight'),
                            ),
                          ],
                        ),
                        Container(
                          width: size.width*0.4,
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton<String>(
                              hint: Text(AppLocalizations.of(context).select,
                                  style: TextStyle(
                                      fontSize:12.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppinslight')),
                              value: (hostkind == 'Housemate')?null:hostkind,
                              items: <DropdownMenuItem<String>>[
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).entire_house,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Entire house',
                                ),
                                new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).cabins_Cattages,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Cabins and Cattages',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).apartment,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Apartment',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).hotel,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Hotel',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).villa,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Villa',
                                ),new DropdownMenuItem(
                                  child: new Text(AppLocalizations.of(context).tiny_house,
                                      style: TextStyle(
                                          fontSize:12.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'poppinslight')),
                                  value: 'Tiny house',
                                ),
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  hostkind = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (C ==1)?
                            Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),                          Text(
                              "${AppLocalizations.of(context).city} :",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight'),
                            ),
                          ],
                        ),
                        Container(
                          width: size.width*0.4,
                          child: new DropdownButtonHideUnderline(
                            child: new StreamBuilder(
                                stream: FirebaseFirestore.instance.collection("city").orderBy("user").snapshots(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return Container(
                                      child: SingleChildScrollView(
                                        child: new DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              hint: Text(AppLocalizations.of(context).city,style: TextStyle(
                                                  fontSize:12.5,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'poppinslight')),
                                              value: cityID,
                                              items: snapshot.data.docs.map<DropdownMenuItem<String>>((DocumentSnapshot doc){
                                                return DropdownMenuItem<String>(
                                                  value: doc["user"].toString(),
                                                  child: Text("${doc["user"]}",style: TextStyle(
                                                      fontSize:12.5,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'poppinslight')),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  cityID = value;
                                                  stateID =null;
                                                });
                                              }),
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container(
                                      width: 0,height: 0,
                                    );
                                  }
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    (cityID==null)?
                    Container(height: 0,width: 0,):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            (S ==1)?
                            Text("*  ",style: TextStyle(color: Colors.red,fontSize: 15),):Container(),
                            Text(
                              "${AppLocalizations.of(context).state} :",
                              style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinslight'),
                            ),
                          ],
                        ),
                        Container(
                          width: size.width*0.4,
                          child: new DropdownButtonHideUnderline(
                            child: new StreamBuilder(
                                stream: FirebaseFirestore.instance.collection("state").where("city",isEqualTo: cityID)
                                    .orderBy('state').snapshots(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return Container(
                                      child: SingleChildScrollView(
                                        child: new DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              hint: Text(AppLocalizations.of(context).select,style: TextStyle(
                                                  fontSize:12.5,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'poppinslight')),
                                              value: stateID,
                                              isDense: true,
                                              items: snapshot.data.docs.map<DropdownMenuItem<String>>((DocumentSnapshot doc){
                                                return DropdownMenuItem<String>(
                                                  value: doc["state"].toString(),
                                                  child: Text("${doc["state"]}",style: TextStyle(
                                                      fontSize:12.5,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'poppinslight')),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  stateID = value;
                                                });
                                              }),
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container(
                                      width: 0,height: 0,
                                    );
                                  }
                                }
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Container(
                      width: size.width,
                      height: size.height*0.06,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(7.5),
                          border: Border.all(
                              width: 0.5,
                              color: Colors.black54
                          )
                      ),
                      child: RaisedButton(
                        onPressed: (){
                          setState(() {
                            if(roomCount == null){
                              CR = 1;
                            }else{CR = 0;}
                            if(cityID == null){
                              C = 1;
                            }else{C = 0;}
                            if(stateID == null){
                              S = 1;
                            }else{S = 0;}
                            if(hostkind == null){
                              HK = 1;
                            }else{HK = 0;}
                          });
                          if(roomCount != null && cityID != null && stateID != null && hostkind != null){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewDescription(
                              user: widget.user,
                              city: cityID,
                              state: stateID,
                              hostfor: _Htype,
                              hostO: _Otype,
                              hostKind: hostkind,
                              hostrentT: _value,
                              roomNO: roomCount,
                            )));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.5),

                          ),
                          child: Center(
                              child: Text(AppLocalizations.of(context).next,style: TextStyle(
                                  fontFamily: 'poppinslight',
                                  fontSize: 15,fontWeight: FontWeight.bold),)),
                        ),
                        color: Theme.of(context).highlightColor,),
                    ),
                  ],
                ),
              ),
            );
          }
      )
      :Container(
        height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/addnew.PNG'),
          fit: BoxFit.cover
        )
      ),),
    );
  }


String hostedName;
  @override
  void initState() {
    super.initState();
    if(widget.user!=null) {
      FirebaseFirestore.instance.collection("Users").where(
          "id", isEqualTo: widget.user.uid).snapshots().listen((v) {
        v.docs.forEach((element) {
          hostedName = element["name_f"];
        });
      });
    }
  }


}

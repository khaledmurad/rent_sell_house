import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class LanguagesPage extends StatefulWidget {
  User user;
  final lang;
  LanguagesPage({this.user,this.lang});
  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  _getLang(L) async {
    //await new Future<Widget>.delayed(const Duration(seconds: 1));
    if(L == 'en'){
      setState(() {
        index = 1;
      });
    }else if(L == 'tr'){
      setState(() {
        index = 2;
      });
    }else if(L == 'ar'){
      setState(() {
        index = 3;
      });
    }
  }
  String L;
  int index;
  @override
  void initState() {
    super.initState();
    L = (widget.lang!=null)?widget.lang:'en';
    _getLang(L);
  }

  Future _calculation() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    L = prefs.getString("mainLang");
    return (L!=null)?L:'en';
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:
      Padding(
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
                AppLocalizations.of(context).language,
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
                  MyApp.setLocale(context, Locale('en', 'EN'));
                  saveLanguage('en');
                  index = 1;
                },
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).english,style: TextStyle(fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold)),
                      (index == 1)?
                      Icon(FontAwesomeIcons.check,color: Theme.of(context).primaryColor,size: 25,)
                          :Container(height: 0,),

                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              GestureDetector(
                onTap: (){
                  MyApp.setLocale(context, Locale('tr', 'TR'));
                  saveLanguage('tr');
                  index = 2;
                },
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).turkish,style: TextStyle(fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold)),
                      (index == 2)?
                      Icon(FontAwesomeIcons.check,color: Theme.of(context).primaryColor,size: 25,)
                          :Container(height: 0,),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              GestureDetector(
                onTap: (){
                  MyApp.setLocale(context, Locale('ar', 'AE'));
                  saveLanguage('ar');
                  index = 3;
                },
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).arabic,style: TextStyle(fontFamily: 'poppins',
                          color: Colors.black,
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold)),
                      (index == 3)?
                      Icon(FontAwesomeIcons.check,color: Theme.of(context).primaryColor,size: 25,)
                          :Container(height: 0,),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),

            ],
          ),
        ),
      )
      // FutureBuilder(
      //   future: _calculation(),
      //   builder: (context , future){
      //     _getLang(future.data);
      //     return (future.hasData)?
      //     Padding(
      //       padding: EdgeInsets.only(
      //           top: size.height * 0.08,
      //           left: size.width * 0.07,
      //           right: size.width * 0.07),
      //       child: SingleChildScrollView(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             GestureDetector(
      //               onTap: (){
      //                 Navigator.of(context).pop();
      //               },
      //               child: Container(
      //                 height: 25,width: 25,
      //                 decoration: BoxDecoration(
      //                     color: Colors.transparent,
      //                     borderRadius: BorderRadius.circular(50)
      //                 ),
      //                 child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.035,
      //             ),
      //             Text(
      //               AppLocalizations.of(context).language,
      //               style: TextStyle(
      //                   color:Colors.black,
      //                   fontSize: 25,
      //                   fontWeight: FontWeight.bold,
      //                   fontFamily: 'poppinsbold'),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.075,
      //             ),
      //             GestureDetector(
      //               onTap: (){
      //                 MyApp.setLocale(context, Locale('en', 'EN'));
      //                 saveLanguage('en');
      //                 index = 1;
      //               },
      //               child: InkWell(
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(AppLocalizations.of(context).english,style: TextStyle(fontFamily: 'poppins',
      //                         color: Colors.black,
      //                         fontSize: 17.5,
      //                         fontWeight: FontWeight.bold)),
      //                     (index == 1)?
      //                     Icon(FontAwesomeIcons.check,color: Theme.of(context).primaryColor,size: 25,)
      //                         :Container(height: 0,),
      //
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             GestureDetector(
      //               onTap: (){
      //                 MyApp.setLocale(context, Locale('tr', 'TR'));
      //                 saveLanguage('tr');
      //                 index = 2;
      //               },
      //               child: InkWell(
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(AppLocalizations.of(context).turkish,style: TextStyle(fontFamily: 'poppins',
      //                         color: Colors.black,
      //                         fontSize: 17.5,
      //                         fontWeight: FontWeight.bold)),
      //                     (index == 2)?
      //                     Icon(FontAwesomeIcons.check,color: Theme.of(context).primaryColor,size: 25,)
      //                         :Container(height: 0,),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //             GestureDetector(
      //               onTap: (){
      //                 MyApp.setLocale(context, Locale('ar', 'AE'));
      //                 saveLanguage('ar');
      //                 index = 3;
      //               },
      //               child: InkWell(
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Text(AppLocalizations.of(context).arabic,style: TextStyle(fontFamily: 'poppins',
      //                         color: Colors.black,
      //                         fontSize: 17.5,
      //                         fontWeight: FontWeight.bold)),
      //                     (index == 3)?
      //                     Icon(FontAwesomeIcons.check,color: Theme.of(context).primaryColor,size: 25,)
      //                         :Container(height: 0,),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: size.height * 0.03,
      //             ),
      //
      //           ],
      //         ),
      //       ),
      //     ):
      //     Center(
      //         child: SpinKitChasingDots(
      //         color: Theme.of(context).primaryColor,
      //     size: size.height*0.05,
      //     ));
      //   },
      // ),

    );
  }

  saveLanguage(String lan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("mainLang", lan);
  }
}

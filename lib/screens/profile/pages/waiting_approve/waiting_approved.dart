import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_mate_app/screens/profile/pages/offers/offers_des.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaitingApproved extends StatefulWidget {
  User user;
  WaitingApproved({this.user});
  @override
  _WaitingApprovedState createState() => _WaitingApprovedState();
}

class _WaitingApprovedState extends State<WaitingApproved> {
  String adErorr;
  Future getBannerWidget() async{
    await new Future<Widget>.delayed(const Duration(seconds: 1));
    myBanner=  BannerAd(
      adUnitId: 'ca-app-pub-6540722261762138/2132141764',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
          onAdLoaded: (ad){
            print("Ad loading $ad");
          },
          onAdFailedToLoad: (ad , loadError){
            adErorr = loadError.message.toString();
            print("Ad loading error $loadError");
            ad.dispose();
          }
      ),
    );
    await myBanner.load();

    return (adErorr == 'No ad config.')?null:AdWidget(ad: myBanner,);

  }

   BannerAd myBanner;
  _line(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height:  size.height*0.015,
        ),
        SizedBox(
          height:  size.height*0.0005,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height:  size.height*0.015,
        ),
      ],
    );
  }
  List<String> offers;
  @override
  void initState() {
    super.initState();
    //myBanner.load();
    offers = [];
    FirebaseFirestore.instance
        .collection("Objects")
        .where("ADID", isEqualTo: widget.user.uid)
        .where("awaiting_approval", isNotEqualTo: "Approval")
        .snapshots()
        .listen((v) {
      v.docs.forEach((element) {
        offers.add(element['id']);
      });
    });
    print(offers.length);
  }

  final Future<Widget> _calculation =
      Future<Widget>.delayed(const Duration(seconds: 1), () {
    return Center(
        child: CircularProgressIndicator(
      backgroundColor: Color(0xFF3EBACE),
    ));
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _calculation,
            builder: (context, fut) {
              return (fut.hasData)
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.07, right: size.width * 0.07),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  size: 17.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.035,
                            ),
                            Text(
                              AppLocalizations.of(context).awaiting_approval,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinsbold'),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            FutureBuilder(
                              future: _ww(),
                              builder: (context, snapshot) {
                                return ListTile(
                                  title: (offers.length > 0)
                                      ? _WidgetOffers()
                                      : _WidgetNoOffers(),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: SpinKitChasingDots(
                      color: Theme.of(context).primaryColor,
                      size: size.height * 0.05,
                    ));
            },
          ),
          Positioned(
              left: 5,
              bottom: 0,
              child:FutureBuilder(
                  future: getBannerWidget(),
                  builder: (context, f) {
                    return (f.hasData)?
                    Container(
                      height: size.height*0.065,
                      width: size.width,
                      child: f.data,
                    )
                        :Container(height: 0,);
                  }
              )  )
        ],
      ),
    );
  }

  Future<Widget> _ww() async {
    if (offers.length > 0) {
      await new Future.delayed(const Duration(seconds: 5));
      return _WidgetOffers();
    } else {
      return _WidgetNoOffers();
    }
  }

  _WidgetOffers() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
         width: size.width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Objects")
                .where("ADID", isEqualTo: widget.user.uid)
                .where("awaiting_approval", isNotEqualTo: "Approval")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: (4 / 6),
                  children: snapshot.data.docs.map<Widget>((doc) {
                    return GestureDetector(
                      onLongPress: () {
                        showModalBottomSheet<void>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: size.height*0.175,
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(60),
                                        topRight: Radius.circular(60)
                                    )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${doc['objname']}",style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'poppins',
                                        color: Colors.black
                                    ),),
                                    _line(context),
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(AppLocalizations.of(context).delete,
                                                  style: TextStyle(
                                                      fontSize: 17.5,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'poppins')),
                                              content: Container(
                                                height: size.height * 0.125,
                                                child: Text(
                                                    "${AppLocalizations.of(context).are_you_sure_you_want_delete} ${doc['objname']} ?",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'poppins')),
                                              ),
                                              actions: [
                                                FlatButton(
                                                    onPressed: () {
                                                      //TODO
                                                      FirebaseFirestore.instance.collection("Objects").doc(doc['id'])
                                                          .delete();
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(AppLocalizations.of(context).delete,
                                                        style: TextStyle(
                                                            fontSize: 12.5,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'poppins'))),
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(AppLocalizations.of(context).back,
                                                        style: TextStyle(
                                                            fontSize: 12.5,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'poppins'))),
                                              ],
                                            ));
                                      },
                                      child: Text(AppLocalizations.of(context).delete,style: TextStyle(
                                          fontSize: 17.5,
                                          fontFamily: 'poppins',
                                          color: Colors.red
                                      ),),
                                    ),
                                    SizedBox(height: size.height*0.01,),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context).cancel,style: TextStyle(
                                          fontSize: 17.5,
                                          fontFamily: 'poppins',
                                          color: Colors.black
                                      ),),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          top: size.height * 0.01,
                         // bottom: size.height * 0.01,
                          left: size.width*0.01,
                          right: size.width*0.01
                        ),
                        height: size.height * 0.15,
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: size.height * 0.15,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(doc['image']),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "${doc['objname']}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'poppinslight'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.005,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${doc['state']} . ${doc['city']}",
                                      style: TextStyle(
                                          fontFamily: 'poppinslight',
                                          fontSize: 13,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }

  _WidgetNoOffers() {
    Size size = MediaQuery.of(context).size;
    return Text(
      AppLocalizations.of(context).you_dont_have_any_ad_awaiting,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        fontFamily: 'poppins',
      ),
    );
  }
}

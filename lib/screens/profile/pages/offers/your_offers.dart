import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_mate_app/screens/profile/pages/offers/offers_des.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OwnOffers extends StatefulWidget {
  User user;
  OwnOffers({this.user});
  @override
  _OwnOffersState createState() => _OwnOffersState();
}

class _OwnOffersState extends State<OwnOffers> {
  DateTime DateFrom, DateTo;
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
            adErorr= loadError.message.toString();
            print("Ad loading error $loadError");
            ad.dispose();
          }
      ),
    );
    await myBanner.load();

    return (adErorr == 'No ad config.')?null:AdWidget(ad: myBanner,);

  }

   BannerAd myBanner ;
  List<String> offers;
  @override
  void initState() {
    super.initState();
   // myBanner.load();
    offers = [];
    FirebaseFirestore.instance
        .collection("Objects")
        .where("ADID", isEqualTo: widget.user.uid)
        .where("awaiting_approval", isEqualTo: "Approval")
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
                              AppLocalizations.of(context).my_list,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinsbold'),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
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
                      width: size.width*0.75,
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
                .where("awaiting_approval", isEqualTo: "Approval")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: (4 / 6),
                  children: snapshot.data.docs.map<Widget>((doc) {
                    return InkWell(
                      highlightColor: Colors.white54,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OffersDes(
                                      user: widget.user,
                                      objectID: doc['id'],
                                    )));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: size.height * 0.01,
                           // bottom: size.height * 0.01,
                            left: size.width * 0.01,
                            right: size.width * 0.01),
                        height: size.height * 0.15,
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: size.height * 0.15,
                              decoration: BoxDecoration(
                                 // borderRadius: BorderRadius.circular(12.0),
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
                                  Text(
                                    "${doc['objname']}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'poppinslight'),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.005,
                                  ),
                                  Text(
                                    "${doc['state']} . ${doc['city']}",
                                    style: TextStyle(
                                        fontFamily: 'poppinslight',
                                        fontSize: 13,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Text(
                                    "state: ${doc['objState']}",
                                    style: TextStyle(
                                        fontFamily: 'poppinslight',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
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
      AppLocalizations.of(context).you_havent_added_ads,
      style: TextStyle(
        fontSize: 17.5,
        fontWeight: FontWeight.bold,
        fontFamily: 'poppins',
      ),
    );
  }
}

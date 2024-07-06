import 'dart:math';
// import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_mate_app/controllers/reviews_controller.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_mate_app/filter/filter.dart';
import 'package:home_mate_app/models/reviews.dart';
import '../../models/view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../controllers/obj_controller.dart';

class CityContentPage extends StatefulWidget {
  final city;
  final homefor;
  User user;
  CityContentPage({this.city, this.user, this.homefor});
  @override
  _CityContentPageState createState() => _CityContentPageState();
}

class _CityContentPageState extends State<CityContentPage> {
  final _rondom = new Random();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _MainPage();
  }

  List<dynamic> Listrate = [];
  var bojs = List<Objects>();
  var reviews = List<Review>();
  var allrate = [];
  double sumRate = 0.0;
  double i;

  final objectcontroller = Get.put(objectController());
  final reviewcontroller = Get.put(reviewController());
  static const _adUnitID = "ca-app-pub-3940256099942544/6300978111";
  // final _nativeAdController = NativeAdmobController();
  String adErorr;
  Future getBannerWidget() async{
    Size size = MediaQuery.of(context).size;
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
            print("Ad adErorr loading error $adErorr");
            ad.dispose();
          }
      ),
    );
    await myBanner.load();

    return (adErorr == 'No ad config.')?null:AdWidget(ad: myBanner,);


  }
   BannerAd myBanner ;
  @override
  void initState() {
    super.initState();
  //  myBanner.load();
    _calculation();
//    bojs =
//        objectcontroller.objects.where((e) => (e.city == widget.city)).toList();
    //_widgetRate(iid);
    FirebaseFirestore.instance.collection("review").get().then((v) {
      v.docs.forEach((doc) {
        allrate.add({"id": doc['hostID'], "rate": doc['rate']});
      });
    });
  }

   _buildRatingStars(double rating, double persons) {
    String stars = '${(rating / persons).toStringAsFixed(1)}';
    stars.trim();
    return Row(
      children: [
        Icon(Icons.star , color: Colors.amber,size: 17.5,),
        Text(
          stars,
          style:TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'poppins')
        ),
      ],
    );
  }
  Widget _widgetRate(id) {
//      return _buildRatingStars( sumRate.toDouble(),Listrate.length.toDouble());
    sumRate=0.0;
    reviews =
        reviewcontroller.review.where((e) => (e.hostID == id))
            .toList();

    Listrate = allrate.where((element) {
      // sumRate = sumRate +element['rate'];
      return (element['id'] == id);
    }).toList();
   for(int i=0 ;i<reviews.length;i++){
     sumRate = sumRate +reviews[i].rate;
   }
    //return ;
  }
  final _random = new Random();
   Future _calculation() async {
     await new Future<Widget>.delayed(const Duration(seconds: 2));
     if(widget.city!=null && widget.homefor==null){
       bojs =
           objectcontroller.objects.where((e) => (e.city == widget.city))
               .where((e) => (e.awaiting_approval =="Approval" ))
               .where((e) => (e.objState =="Active" ))
               .toList();
     }else if(widget.city==null && widget.homefor==null){
       bojs =
           objectcontroller.objects
               .where((e) => (e.awaiting_approval =="Approval" ))
               .where((e) => (e.objState =="Active" ))
               .toList();
     }else if(widget.city==null && widget.homefor=="sale"){
       bojs =
           objectcontroller.objects
               .where((e) => (e.awaiting_approval =="Approval" ))
               .where((e) => (e.objState =="Active" ))
               .where((e) => (e.hosr_sale_rent =="For sale" ))
               .toList();
     }else if(widget.city==null && widget.homefor=="rent"){
       bojs =
           objectcontroller.objects
               .where((e) => (e.awaiting_approval =="Approval" ))
               .where((e) => (e.objState =="Active" ))
               .where((e) => (e.hosr_sale_rent =="For rent" ))
               .toList();
     }

     bojs.shuffle();
     return bojs;
  }
  _MainPage() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
            size: 17.5,
          ),
          splashRadius: 22.5,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          (widget.city!=null)?
          "${widget.city}":
          AppLocalizations.of(context).houses,
          style: TextStyle(
              color: Colors.black, fontFamily: 'poppins', fontSize: 17.5),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _calculation(),
            builder: (context, f) {
              return (f.hasData)
                  ? SingleChildScrollView(
                      child: Container(
                          height: size.height,
                          width: size.width,
                          child: ListView.builder(
                            padding:
                            EdgeInsets.only(bottom: size.height * 0.125,left: 25,right: 25),
                            itemCount: f.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              _widgetRate(f.data[index].id);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ObjectDescription(
                                                id: f.data[index].id,
                                                objOwner:
                                                f.data[index].ADID,
                                                user: widget.user,
                                              )));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 20),
                                  height: size.height * 0.4,
                                  width: size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(12.0),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      f.data[index].image),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      (reviews.length != 0)?
                                      _buildRatingStars(sumRate, double.parse("${reviews.length}")):
                                      Container(height: 0,),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${f.data[index].type} . ${f.data[index].city}",
                                            style: TextStyle(
                                                fontFamily: 'poppins',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "${f.data[index].price} ${f.data[index].money_type}",
                                            style: TextStyle(
                                                fontFamily: 'poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                            color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.005,
                                      ),
                                      Text(
                                        "${f.data[index].objname}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'poppins'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                      ),
                    )
                  : Center(
                      child: SpinKitChasingDots(
                        color: Theme.of(context).primaryColor,
                        size: size.height*0.05,
                      )
              );
            },
          ),
          Positioned(
              left: 5,
              bottom: 5,
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
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(highlightColor: Colors.transparent),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                FlutterIcons.ios_options_ion,
            color: Colors.white,
            size: size.height*0.035,
            ),),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FilterPage(
                      user: widget.user,
                    )));
          },),
      ),
    );
  }

}

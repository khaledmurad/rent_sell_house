import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_native_admob/flutter_native_admob.dart';
// import 'package:flutter_native_admob/native_admob_controller.dart';
// import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_mate_app/auth/auth.dart';
import 'package:home_mate_app/auth/login.dart';
import 'package:home_mate_app/controllers/obj_controller.dart';
import 'package:home_mate_app/controllers/reviews_controller.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/models/reviews.dart';
import 'package:home_mate_app/models/view.dart';
import 'package:home_mate_app/notifications/notifications.dart';
import 'package:home_mate_app/notifications/send_notifications.dart';
import 'package:home_mate_app/screens/dashboard/result_page.dart';
import 'package:home_mate_app/screens/description/categore_objects.dart';
import 'package:home_mate_app/screens/description/city_objects.dart';
import 'package:home_mate_app/screens/profile/user_page.dart';
import 'package:provider/provider.dart';

import '../../main.dart';


class DashboardPage extends StatefulWidget {
  User user;
  DashboardPage({this.user});
  Future<void> _signOut(BuildContext context) async {

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  var timeNow = DateTime.now().hour;

  String Timedaily(){
    if ((timeNow >= 5) && (timeNow < 12)) {
      return 'Good Morning';
    } else if ((timeNow >= 12) && (timeNow < 17)) {
      return 'Good Afternoon';
    }  else {
      return 'Good Evening';
    }
  }

  Map city = {

  };

  var searchS;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child:
      ListView(
        children: [
          SizedBox(height: size.height*0.02,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${Timedaily()}",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("${AppLocalizations.of(context).hello} $UserName",
                      style: TextStyle(
                        fontSize: size.width * 0.055,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage(user: widget.user)));
                  },
                  child: Container(
                    height: size.width * .1,
                    width: size.width * .1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (UserImage == ""||UserImage == null)?
                        AssetImage(
                            'assets/images/5.jpg'):
                        NetworkImage(UserImage)
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: size.height*0.03,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: size.width*0.025),
                  height: size.height*0.07,
                  width: size.width*0.725,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                      // border: Border.all(
                      //     width: 1.5,color: Theme.of(context).primaryColor
                      // ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextField(
                    onChanged: (v){
                      setState(() {
                        searchS = v;
                      });
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:  AppLocalizations.of(context).search_about_ID_or_owner,
                      hintStyle: TextStyle(fontSize : size.width*0.034,fontWeight: FontWeight.bold,fontFamily: 'poppins'),
                      // suffixIcon:IconButton(
                      //   icon: Icon(Icons.search),
                      //   onPressed: () {
                      //     if(searchS != ""||searchS!=null){
                      //       Navigator.push(context, MaterialPageRoute(builder: (
                      //           context) => ResultPAGE(searchS, widget.user)));
                      //     }
                      //   },
                      //   highlightColor: Colors.transparent,splashRadius: 15,
                      //   color: (searchS == ""||searchS==null)?Colors.grey:Theme.of(context).primaryColor,
                      // ),

                    ),
                  ),
                ),
                GestureDetector(
                  onTap:() {
                    if(searchS != ""||searchS!=null){
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => ResultPAGE(searchS, widget.user)));
                    }
                  } ,
                  child: Container(
                    padding: EdgeInsets.all(size.width*0.03),
                    height:size.height*0.07 ,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor,
                          blurRadius: 4,
                          offset: Offset(0,.5)
                        )
                      ],
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(child: Icon(Icons.search,color: Colors.white,
                    size: size.height*0.033,)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: size.height*0.02,),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  child: Text(AppLocalizations.of(context).live_anywhere,
                    style: TextStyle(fontSize : size.width*0.05,fontWeight: FontWeight.bold,
                        fontFamily: 'poppins'),),
                ),
                SizedBox(height: size.height*0.01,),
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('city')
                        .orderBy("user",descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return (snapshot.hasData)?
                      Container(
                        height: size.height*0.22,
                        child: ListView(
                            scrollDirection:Axis.horizontal,
                            children:snapshot.data.docs.map<Widget>((city){
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CityContentPage(
                                    city:city["user"],
                                    user: widget.user,)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0, bottom: 10, left: 5,right: 5),
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: 1.0,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: <Widget>[
                                                Hero(
                                                  tag: NetworkImage(city["image"]),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(10),topLeft: Radius.circular(10)
                                                    ),
                                                    child: Image(
                                                      height: size.height*0.15,
                                                      width: size.width*0.4,
                                                      image: NetworkImage(city["image"]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
//                                              Positioned(
//                                                left: 10.0,
//                                                bottom: 10.0,
//                                                child: Column(
//                                                  crossAxisAlignment:
//                                                  CrossAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      city["user"],
//                                                      style: TextStyle(
//                                                        color: Colors.white,
//                                                        fontSize: 24.0,
//                                                        fontWeight: FontWeight.w600,
//                                                        letterSpacing: 1.2,
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
                                              ],
                                            ),
                                            SizedBox(height: size.height*0.005,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _CitiesName(city["user"]),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'poppins',
                                                    fontSize: 17.5,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList()
                        ),
                      ):
                      Container(height: 0,width: 0,);
                    }
                )
              ],
            ),
          ),
          SizedBox(height: size.height*0.02,),
          FutureBuilder(
            future: getBannerWidget(),
            builder: (context, f) {
              return (f.hasData)?
              f.data
                  :Container(height: 0,);
            }
          ),
          SizedBox(height: size.height*0.02,),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).categories,
                        style: TextStyle(fontSize : size.width*0.05,
                            fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                      GestureDetector(
                        onTap: (){

                        },
                        child: Text("${AppLocalizations.of(context).show_all}",
                          style: TextStyle(fontSize : size.width*0.0325,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                          color: Theme.of(context).hoverColor),),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height*0.015,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("objKind")
                      .orderBy("name",descending:false).limit(3)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.hasData)?
                    Container(
                      //  height: size.height*0.37,
                      child: Column(
//                      physics: NeverScrollableScrollPhysics(),
//                      scrollDirection:Axis.vertical,
                          children:snapshot.data.docs.map<Widget>((k){
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)
                                =>CateContentPage(
                                  gate: k['name'],
                                  user: widget.user,
                                )));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: size.height*0.005, bottom: size.height*0.005, left: size.width*0.025,right: size.width*0.025),
                                    width: MediaQuery.of(context).size.width,
                                    height: size.height*0.125,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                            image: NetworkImage(k['image']),
                                            fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black54,BlendMode.colorBurn)
                                        )
                                    ),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(_TypeName(k['name']),style: TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold,fontSize: 17.5,fontFamily: 'poppinsbold'),),
                                        ]),
                                  ),
                                ],
                              ),
                            );
                          }).toList()
                      ),
                    ):
                    Container(height: 0);
                  }
                )
              ],
            ),
          ),
          // (widget.user == null)?
          // Column(
          //   children: [
          //     SizedBox(height: size.height*0.03,),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 35),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color: Colors.black,
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         child: Column(
          //           children: [
          //             Container(
          //               padding: EdgeInsets.symmetric(vertical: 15),
          //               height: 160,
          //               child: Column(
          //                 children: [
          //                   Text(AppLocalizations.of(context).yOUR_WORLD_IN_YOUR_HAND,style: TextStyle(fontSize: 17.5,fontWeight: FontWeight.bold,color: Colors.white,
          //                   fontFamily: 'poppins'),),
          //                   SizedBox(height: size.height*0.01,),
          //                   Text(AppLocalizations.of(context).be_a_member,style: TextStyle(fontSize: 12.5,
          //                       fontFamily: 'poppins',fontWeight: FontWeight.w300,color: Colors.white),),
          //                   SizedBox(height: size.height*0.02,),
          //                   Padding(
          //                     padding: const EdgeInsets.symmetric(
          //                         horizontal: 15),
          //                     child: RaisedButton(
          //                       color: Theme.of(context).primaryColor,
          //                       shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(7.0),
          //                       ),
          //                       child: Container(
          //                         width: size.width,
          //                         child: Center(
          //                             child: Text(
          //                               AppLocalizations.of(context).be_member,
          //                               style: TextStyle(
          //                                   fontSize: 17,
          //                                   fontFamily: 'poppins',
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Colors.white),
          //                             )),
          //                       ),
          //                       onPressed: () {
          //                         Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
          //                       },
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //             Stack(
          //               children: [
          //                 Hero(
          //                   tag: Image.asset("assets/images/r.jpg"),
          //                   child: ClipRRect(
          //                     borderRadius: BorderRadius.circular(6),
          //                     child: Image(
          //                       height: 200,
          //                       width: size.width,
          //                       image: AssetImage("assets/images/r.jpg"),
          //                       fit: BoxFit.cover,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ):
          // Container(height: 0,),
          SizedBox(height: size.height*0.02,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("For sale",style: TextStyle(
                    fontSize : size.width*0.05,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CityContentPage(
                      user: widget.user,homefor: "sale",)));
                  },
                  child: Text("${AppLocalizations.of(context).show_all}",
                    style: TextStyle(fontSize : size.width*0.0325,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins',
                        color: Theme.of(context).hoverColor),),
                ),
              ],
            ),
          ),
          _WedgetObjects(),
          SizedBox(height: size.height*0.02,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("For rent",style: TextStyle(
                    fontSize : size.width*0.05,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CityContentPage(
                      user: widget.user,homefor: "rent",)));
                  },
                  child: Text("${AppLocalizations.of(context).show_all}",
                    style: TextStyle(fontSize : size.width*0.0325,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins',
                        color: Theme.of(context).hoverColor),),
                ),
              ],
            ),
          ),
          _WedgetObjectsRent(),
          SizedBox(height: size.height*0.015,),
          // FutureBuilder(
          //   future: _calculation(),
          //   builder:(context,f){
          //     return (f.hasData)?
          //     GestureDetector(
          //       onTap: (){
          //         Navigator.push(context, MaterialPageRoute(builder: (context)=>CityContentPage(
          //           user: widget.user,)));
          //       },
          //       child: Container(
          //         margin:
          //         EdgeInsets.only(bottom: size.height * 0.075,
          //             left: size.width*0.2,right: size.width*0.2),
          //         // padding: EdgeInsets.only(left: 25,right: 25),
          //         width: size.width*0.25,
          //         height: size.height*0.06,
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(10),
          //             border: Border.all(
          //                 width: 0.75,
          //                 color: Theme.of(context).primaryColor
          //             )
          //         ),
          //         child: Center(
          //             child: Text("${AppLocalizations.of(context).show_all}",style: TextStyle(
          //                 fontFamily: 'poppinsbold',color: Theme.of(context).primaryColor,
          //                 fontSize: 15,fontWeight: FontWeight.bold),)),
          //       ),
          //     ):
          //     Container(height: 0,);
          //   }
          // ),
        ],
            ),
          );
  }

  // NativeAd _ad;
  bool _isAdLoaded = false;
  BannerAd myBanner ;
  bool showAD ;
   Future getBannerWidget() async{
     Size size = MediaQuery.of(context).size;
     await new Future<Widget>.delayed(const Duration(seconds: 1));
     myBanner= BannerAd(
       adUnitId: 'ca-app-pub-6540722261762138/3821284491',
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


     return (adErorr == 'No ad config.')?null:
     Container(
         height: size.height*0.065,
         width: size.width,
         child: AdWidget(ad: myBanner,)
     );

   }
  @override
  void initState() {
    super.initState();
    prepareW();
    FirebaseFirestore.instance.collection("Users").where(
        "id", isEqualTo: widget.user.uid).snapshots().listen((v) {
      v.docs.forEach((element) {
        UserName = element["name_f"];
        UserImage = element["image"];
      });
    });
    print("The name is : " + UserName);
    // _ad = NativeAd(
    //   adUnitId: 'ca-app-pub-6540722261762138/6455078891',
    //   factoryId: 'ListTile',
    //   request: AdRequest(),
    //   listener: NativeAdListener(),
    // );

    //myBanner.load();
  }
  String adErorr;
  String UserName = "";
  String UserImage;
  /////////////////////////////////////
  List<dynamic> Listrate = [];
  var bojs = List<Objects>();
  var reviews = List<Review>();
  var allrate = [];
  double sumRate = 0.0;
  double i;
  final objectcontroller = Get.put(objectController());
  final reviewcontroller = Get.put(reviewController());
  _buildRatingStars(double rating, double persons) {
    String stars = '${(rating / persons).toStringAsFixed(1)}';
    stars.trim();
    return Row(
      children: [
        Icon(Icons.star , color: Colors.amber,size: 15,),
        Text(
            stars,
            style:TextStyle(fontSize: 13,fontWeight: FontWeight.w600,fontFamily: 'poppins')
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
//    bojs =
//        objectcontroller.objects
//            .where((e) => (e.objState =="Active" ))
//            .toList();
//    bojs.shuffle();
    Listrate = allrate.where((element) {
      // sumRate = sumRate +element['rate'];
      return (element['id'] == id);
    }).toList();
    for(int i=0 ;i<reviews.length;i++){
      sumRate = sumRate +reviews[i].rate;
    }
    //return ;
  }

  bool isLoading = true;


  List<Objects> Gallery = new List<Objects>();
  List<Objects> GalleryS = new List<Objects>();
  List<Objects> GalleryR = new List<Objects>();



  prepareW() async {
    setState(() {
      isLoading = true;
    });


  var s1 = FirebaseFirestore.instance.collection("Objects")
      .where("awaiting_approval",isEqualTo: "Approval")
      .where("objState",isEqualTo:"Active" ).get().then((value){

    if(value.docs.length > 0){

          value.docs.forEach((e) {

            var newob = Objects(
                id: e["id"],
                image: e['image'],
                roomNO: e['roomNO'],
                state: e['state'],
                kira_tameen: e['kira_tameen'],
                kira_comsyn: e['kira_comsyn'],
                checkOUT: e['checkOUT'],
                checkIN: e['checkIN'],
                amensmoke: e['amensmoke'],
                amenparking: e['amenparking'],
                allowSmoking: e['allowSmoking'],
                amenWIFI: e['amenWIFI'],
                amensecureCamera: e['amensecureCamera'],
                amenpets: e['amenpets'],
                amenHomesafty: e['amenHomesafty'],
                amengarden: e['amengarden'],
                amenAirCondition: e['amenAirCondition'],
                allowPets: e['allowPets'],
                address: e['address'],
                amenTV: e['amenTV'],
                amenheating: e['amenheating'],
                amenbedroom: e['amenbedroom'],
                hostAD_from: e['hostAD_from'],
                amenpool: e['amenpool'],
                price: e['price'],
                objname: e['objname'],
                maxNO_person: e['maxNO_person'],
                information: e['information'],
                hosr_sale_rent: e['hosr_sale_rent'],
                bathroomNO: e['bathroomNO'],
                balcony: e['balcony'],
                hostspace: e['hostspace'],
                objState: e['objState'],
                floorNO: e['floorNO'],
                type: e['type'],
                money_type: e['money_type'],
                rent_time_for: e['rent_time_for'],
                postcode: e['postcode'],
                city: e['city'],
                bedroomNO: e['bedroomNO'],
                ADowner: e['ADowner'],
                ADID: e['ADID'],
                awaiting_approval: e['awaiting_approval'],
                ads_time: e['ads_time']
            );

            setState(() {
              Gallery.add(newob);
            });

          });


          Gallery.shuffle();


    }

    GalleryS = Gallery.where((element) => element.hosr_sale_rent == "For sale").toList();
    GalleryR = Gallery.where((element) => element.hosr_sale_rent == "For rent").toList();

  });

    setState(() {
      isLoading = false;
    });
  }
  Future _calculation() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));
      bojs =
          objectcontroller.objects
              .where((e) => (e.awaiting_approval =="Approval" ))
              .where((e) => (e.objState =="Active" ))
              .toList();
      bojs.shuffle();


    print("1dsdvdsv ${bojs}");
    print("1dsdvdsv ${bojs.length}");

   return bojs;
  }

  _WedgetObjects(){
    Size size = MediaQuery.of(context).size;
    return AnimatedSwitcher(
      duration: Duration(microseconds: 500),
      //height: size.height*0.3,
      child:
      isLoading ? Text("Loading") : GalleryS.length > 0 ?
      SingleChildScrollView(
              child: Container(
                  height: size.height*.35,
                  width: size.width,
                  margin: EdgeInsets.only(left: 5,right: 5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:(GalleryS.length >3)? 4:GalleryS.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ObjectDescription(
                                        id: GalleryS[index].id,
                                        objOwner:
                                        GalleryS[index].ADID,
                                        user: widget.user,
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: size.height * .015,
                              left: size.width* .03,right: size.width* .03),
                          margin: EdgeInsets.only(top: 20,left: 2.5,right: 2.5),
                          height: size.height ,
                          width: size.width * .7,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(7.5)
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: size.height * 0.2,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(7.5),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            GalleryS[index].image),
                                        fit: BoxFit.cover)),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              // (reviews.length != 0)?
                              // _buildRatingStars(sumRate, double.parse("${reviews.length}")):
                              // Container(height: 0,),
                              // SizedBox(
                              //   height: size.height * 0.0075,
                              // ),
                              Flexible(
                                child:
                                (GalleryS[index].objname.length>=25)?
                                Text(
                                  "${GalleryS[index].objname.substring(0,25)} ...",
                                  style: TextStyle(
                                      fontSize: size.width * .04,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'poppins'),
                                ):
                                Text(
                                  "${GalleryS[index].objname}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'poppins'),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_pin,color: Colors.red,size: size.width * .04),
                                      Text(
                                        "${GalleryS[index].city}",
                                        style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "\$${GalleryS[index].price}",
                                    style: TextStyle(
                                        fontFamily: 'poppins',
                                        fontSize: 13,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
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
            ))
      // FutureBuilder(
      //   future: _calculation(),
      //   builder: (context, f) {
      //     return (f.hasData)
      //         ? SingleChildScrollView(
      //       child: Container(
      //           height: size.height*.45,
      //           width: size.width,
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 25,right: 25),
      //             child: GridView.builder(
      //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //               physics: NeverScrollableScrollPhysics(),
      //               padding:
      //               EdgeInsets.only(bottom: size.height * 0.125),
      //               itemCount:(f.data.length >3)? 4:f.data.length,
      //               itemBuilder: (BuildContext context, int index) {
      //                 _widgetRate(f.data[index].id);
      //                 return GestureDetector(
      //                   onTap: () {
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) =>
      //                                 ObjectDescription(
      //                                   id: f.data[index].id,
      //                                   objOwner:
      //                                   f.data[index].ADID,
      //                                   user: widget.user,
      //                                 )));
      //                   },
      //                   child: Container(
      //                     padding: EdgeInsets.only(top: 20,left: 2.5,right: 2.5),
      //                     height: size.height *1,
      //                     width: size.width,
      //                     child: Column(
      //                       crossAxisAlignment:
      //                       CrossAxisAlignment.start,
      //                       children: [
      //                         Container(
      //                           height: size.height * 0.1,
      //                           decoration: BoxDecoration(
      //                               borderRadius:
      //                               BorderRadius.circular(0),
      //                               image: DecorationImage(
      //                                   image: NetworkImage(
      //                                       f.data[index].image),
      //                                   fit: BoxFit.cover)),
      //                         ),
      //                         SizedBox(
      //                           height: size.height * 0.01,
      //                         ),
      //                         (reviews.length != 0)?
      //                         _buildRatingStars(sumRate, double.parse("${reviews.length}")):
      //                         Container(height: 0,),
      //                         SizedBox(
      //                           height: size.height * 0.01,
      //                         ),
      //                         Flexible(
      //                           child: Text(
      //                             "${f.data[index].objname}",
      //                             style: TextStyle(
      //                                 fontSize: 12.5,
      //                                 fontWeight: FontWeight.w600,
      //                                 fontFamily: 'poppins'),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           height: size.height * 0.005,
      //                         ),
      //                         Flexible(
      //                           child: Text(
      //                             "${f.data[index].type} . ${f.data[index].city}",
      //                             style: TextStyle(
      //                                 fontFamily: 'poppins',
      //                                 fontSize: 12.5,
      //                                 fontWeight: FontWeight.w600),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           )
      //       ),
      //     )
      //         : Center(
      //         child: SpinKitChasingDots(
      //           color: Theme.of(context).primaryColor,
      //           size: size.height*0.05,
      //         ));
      //   },
      // ),
    );
  }
  _WedgetObjectsRent(){
    Size size = MediaQuery.of(context).size;
    return AnimatedSwitcher(
      duration: Duration(microseconds: 500),
      //height: size.height*0.3,
      child:
      isLoading ? Text("Loading") : GalleryR.length > 0 ?
      SingleChildScrollView(
              child: Container(
                  height: size.height*.35,
                  width: size.width,
                  margin: EdgeInsets.only(left: 5,right: 5),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: size.height * .0275),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:(GalleryR.length >3)? 4:GalleryR.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ObjectDescription(
                                          id: GalleryR[index].id,
                                          objOwner:
                                          GalleryR[index].ADID,
                                          user: widget.user,
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: size.height * .015,
                                left: size.width* .03,right: size.width* .03),
                            margin: EdgeInsets.only(top: 20,left: 2.5,right: 2.5),
                            height: size.height ,
                            width: size.width * .7,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(7.5)
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.height * 0.2,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(7.5),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              GalleryR[index].image),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                // (reviews.length != 0)?
                                // _buildRatingStars(sumRate, double.parse("${reviews.length}")):
                                // Container(height: 0,),
                                // SizedBox(
                                //   height: size.height * 0.0075,
                                // ),
                                Flexible(
                                  child:
                                  (GalleryR[index].objname.length>=25)?
                                  Text(
                                    "${GalleryR[index].objname.substring(0,25)} ...",
                                    style: TextStyle(
                                        fontSize: size.width * .04,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'poppins'),
                                  ):
                                  Text(
                                    "${GalleryR[index].objname}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'poppins'),
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.005,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.location_pin,color: Colors.red,size: size.width * .04),
                                        Text(
                                          "${GalleryR[index].city}",
                                          style: TextStyle(
                                              fontFamily: 'poppins',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "\$${GalleryR[index].price}",
                                      style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontSize: 13,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },

                    ),
                  )
              ),
            )
          : Center(
            child: SpinKitChasingDots(
              color: Theme.of(context).primaryColor,
              size: size.height*0.05,
            ))
      // FutureBuilder(
      //   future: _calculation(),
      //   builder: (context, f) {
      //     return (f.hasData)
      //         ? SingleChildScrollView(
      //       child: Container(
      //           height: size.height*.45,
      //           width: size.width,
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 25,right: 25),
      //             child: GridView.builder(
      //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //               physics: NeverScrollableScrollPhysics(),
      //               padding:
      //               EdgeInsets.only(bottom: size.height * 0.125),
      //               itemCount:(f.data.length >3)? 4:f.data.length,
      //               itemBuilder: (BuildContext context, int index) {
      //                 _widgetRate(f.data[index].id);
      //                 return GestureDetector(
      //                   onTap: () {
      //                     Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) =>
      //                                 ObjectDescription(
      //                                   id: f.data[index].id,
      //                                   objOwner:
      //                                   f.data[index].ADID,
      //                                   user: widget.user,
      //                                 )));
      //                   },
      //                   child: Container(
      //                     padding: EdgeInsets.only(top: 20,left: 2.5,right: 2.5),
      //                     height: size.height *1,
      //                     width: size.width,
      //                     child: Column(
      //                       crossAxisAlignment:
      //                       CrossAxisAlignment.start,
      //                       children: [
      //                         Container(
      //                           height: size.height * 0.1,
      //                           decoration: BoxDecoration(
      //                               borderRadius:
      //                               BorderRadius.circular(0),
      //                               image: DecorationImage(
      //                                   image: NetworkImage(
      //                                       f.data[index].image),
      //                                   fit: BoxFit.cover)),
      //                         ),
      //                         SizedBox(
      //                           height: size.height * 0.01,
      //                         ),
      //                         (reviews.length != 0)?
      //                         _buildRatingStars(sumRate, double.parse("${reviews.length}")):
      //                         Container(height: 0,),
      //                         SizedBox(
      //                           height: size.height * 0.01,
      //                         ),
      //                         Flexible(
      //                           child: Text(
      //                             "${f.data[index].objname}",
      //                             style: TextStyle(
      //                                 fontSize: 12.5,
      //                                 fontWeight: FontWeight.w600,
      //                                 fontFamily: 'poppins'),
      //                           ),
      //                         ),
      //                         SizedBox(
      //                           height: size.height * 0.005,
      //                         ),
      //                         Flexible(
      //                           child: Text(
      //                             "${f.data[index].type} . ${f.data[index].city}",
      //                             style: TextStyle(
      //                                 fontFamily: 'poppins',
      //                                 fontSize: 12.5,
      //                                 fontWeight: FontWeight.w600),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 );
      //               },
      //             ),
      //           )
      //       ),
      //     )
      //         : Center(
      //         child: SpinKitChasingDots(
      //           color: Theme.of(context).primaryColor,
      //           size: size.height*0.05,
      //         ));
      //   },
      // ),
    );
  }







  // _WedgetObjects(){
  //   Size size = MediaQuery.of(context).size;
  //   return AnimatedSwitcher(
  //     duration: Duration(microseconds: 500),
  //     //height: size.height*0.3,
  //     child:
  //     isLoading ? Text("Loading") : Gallery.length > 0 ?
  //     SingleChildScrollView(
  //             child: Container(
  //                 height: size.height*.45,
  //                 width: size.width,
  //                 child: Padding(
  //                   padding: EdgeInsets.only(left: 25,right: 25),
  //                   child: GridView.builder(
  //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //                     physics: NeverScrollableScrollPhysics(),
  //                     padding:
  //                     EdgeInsets.only(bottom: size.height * 0.125),
  //                     itemCount:(Gallery.length >3)? 4:Gallery.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       _widgetRate(Gallery[index].id);
  //                       return GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) =>
  //                                       ObjectDescription(
  //                                         id: Gallery[index].id,
  //                                         objOwner:
  //                                         Gallery[index].ADID,
  //                                         user: widget.user,
  //                                       )));
  //                         },
  //                         child: Container(
  //                           padding: EdgeInsets.only(top: 20,left: 2.5,right: 2.5),
  //                           height: size.height *1,
  //                           width: size.width,
  //                           child: Column(
  //                             crossAxisAlignment:
  //                             CrossAxisAlignment.start,
  //                             children: [
  //                               Container(
  //                                 height: size.height * 0.1,
  //                                 decoration: BoxDecoration(
  //                                     borderRadius:
  //                                     BorderRadius.circular(0),
  //                                     image: DecorationImage(
  //                                         image: NetworkImage(
  //                                             Gallery[index].image),
  //                                         fit: BoxFit.cover)),
  //                               ),
  //                               SizedBox(
  //                                 height: size.height * 0.01,
  //                               ),
  //                               (reviews.length != 0)?
  //                               _buildRatingStars(sumRate, double.parse("${reviews.length}")):
  //                               Container(height: 0,),
  //                               SizedBox(
  //                                 height: size.height * 0.01,
  //                               ),
  //                               Flexible(
  //                                 child: Text(
  //                                   "${Gallery[index].objname}",
  //                                   style: TextStyle(
  //                                       fontSize: 12.5,
  //                                       fontWeight: FontWeight.w600,
  //                                       fontFamily: 'poppins'),
  //                                 ),
  //                               ),
  //                               SizedBox(
  //                                 height: size.height * 0.005,
  //                               ),
  //                               Flexible(
  //                                 child: Text(
  //                                   "${Gallery[index].type} . ${Gallery[index].city}",
  //                                   style: TextStyle(
  //                                       fontFamily: 'poppins',
  //                                       fontSize: 12.5,
  //                                       fontWeight: FontWeight.w600),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 )
  //             ),
  //           )
  //         : Center(
  //           child: SpinKitChasingDots(
  //             color: Theme.of(context).primaryColor,
  //             size: size.height*0.05,
  //           ))
  //     // FutureBuilder(
  //     //   future: _calculation(),
  //     //   builder: (context, f) {
  //     //     return (f.hasData)
  //     //         ? SingleChildScrollView(
  //     //       child: Container(
  //     //           height: size.height*.45,
  //     //           width: size.width,
  //     //           child: Padding(
  //     //             padding: EdgeInsets.only(left: 25,right: 25),
  //     //             child: GridView.builder(
  //     //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  //     //               physics: NeverScrollableScrollPhysics(),
  //     //               padding:
  //     //               EdgeInsets.only(bottom: size.height * 0.125),
  //     //               itemCount:(f.data.length >3)? 4:f.data.length,
  //     //               itemBuilder: (BuildContext context, int index) {
  //     //                 _widgetRate(f.data[index].id);
  //     //                 return GestureDetector(
  //     //                   onTap: () {
  //     //                     Navigator.push(
  //     //                         context,
  //     //                         MaterialPageRoute(
  //     //                             builder: (context) =>
  //     //                                 ObjectDescription(
  //     //                                   id: f.data[index].id,
  //     //                                   objOwner:
  //     //                                   f.data[index].ADID,
  //     //                                   user: widget.user,
  //     //                                 )));
  //     //                   },
  //     //                   child: Container(
  //     //                     padding: EdgeInsets.only(top: 20,left: 2.5,right: 2.5),
  //     //                     height: size.height *1,
  //     //                     width: size.width,
  //     //                     child: Column(
  //     //                       crossAxisAlignment:
  //     //                       CrossAxisAlignment.start,
  //     //                       children: [
  //     //                         Container(
  //     //                           height: size.height * 0.1,
  //     //                           decoration: BoxDecoration(
  //     //                               borderRadius:
  //     //                               BorderRadius.circular(0),
  //     //                               image: DecorationImage(
  //     //                                   image: NetworkImage(
  //     //                                       f.data[index].image),
  //     //                                   fit: BoxFit.cover)),
  //     //                         ),
  //     //                         SizedBox(
  //     //                           height: size.height * 0.01,
  //     //                         ),
  //     //                         (reviews.length != 0)?
  //     //                         _buildRatingStars(sumRate, double.parse("${reviews.length}")):
  //     //                         Container(height: 0,),
  //     //                         SizedBox(
  //     //                           height: size.height * 0.01,
  //     //                         ),
  //     //                         Flexible(
  //     //                           child: Text(
  //     //                             "${f.data[index].objname}",
  //     //                             style: TextStyle(
  //     //                                 fontSize: 12.5,
  //     //                                 fontWeight: FontWeight.w600,
  //     //                                 fontFamily: 'poppins'),
  //     //                           ),
  //     //                         ),
  //     //                         SizedBox(
  //     //                           height: size.height * 0.005,
  //     //                         ),
  //     //                         Flexible(
  //     //                           child: Text(
  //     //                             "${f.data[index].type} . ${f.data[index].city}",
  //     //                             style: TextStyle(
  //     //                                 fontFamily: 'poppins',
  //     //                                 fontSize: 12.5,
  //     //                                 fontWeight: FontWeight.w600),
  //     //                           ),
  //     //                         ),
  //     //                       ],
  //     //                     ),
  //     //                   ),
  //     //                 );
  //     //               },
  //     //             ),
  //     //           )
  //     //       ),
  //     //     )
  //     //         : Center(
  //     //         child: SpinKitChasingDots(
  //     //           color: Theme.of(context).primaryColor,
  //     //           size: size.height*0.05,
  //     //         ));
  //     //   },
  //     // ),
  //   );
  // }








  _CitiesName(String d){
    switch(d){
      case "Ankara":return AppLocalizations.of(context).ankara;break;
      case "Antalya":return AppLocalizations.of(context).antalya;break;
      case "Bursa":return AppLocalizations.of(context).bursa;break;
      case "Istanbul":return AppLocalizations.of(context).istanbul;break;
      case "Izmir":return AppLocalizations.of(context).izmir;break;
      case "Kaysari":return AppLocalizations.of(context).kaysari;break;
      case "Sakarya":return AppLocalizations.of(context).sakarya;break;
      case "Trabzon":return AppLocalizations.of(context).trabzon;break;
    }
  }
  _TypeName(String d){
    switch(d){
      case "Entire house":return AppLocalizations.of(context).entire_house;break;
      case "Cabins and Cattages":return AppLocalizations.of(context).cabins_Cattages;break;
      case "Apartment":return AppLocalizations.of(context).apartment;break;
      case "Hotel":return AppLocalizations.of(context).hotel;break;
      case "Villa":return AppLocalizations.of(context).villa;break;
      case "Tiny house":return AppLocalizations.of(context).tiny_house;break;
      case "Housemate":return AppLocalizations.of(context).housemate;break;
    }
  }
}

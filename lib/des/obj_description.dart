import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_mate_app/auth/landing.dart';
import 'package:home_mate_app/auth/login.dart';
import 'package:home_mate_app/booking/booking_page.dart';
import 'package:home_mate_app/controllers/obj_controller.dart';
import 'package:home_mate_app/des/Amenities.dart';
import 'package:home_mate_app/des/more_des/all_amenities.dart';
import 'file:///C:/AndroidStudioProjects/home_mate_app/lib/des/more_des/house_rules.dart';
import 'package:home_mate_app/des/more_des/more_info.dart';
import 'package:home_mate_app/des/more_des/msj_host.dart';
import 'package:home_mate_app/des/more_des/report.dart';
import 'package:home_mate_app/des/more_des/reviews_all.dart';
import 'package:home_mate_app/des/more_des/money.dart';
import 'package:home_mate_app/models/view.dart';
import 'package:home_mate_app/screens/profile/pages/main_profile/MainProfile.dart';

class ObjectDescription extends StatefulWidget {
  final id;
  final objOwner;
  User user;

  ObjectDescription({this.id,this.objOwner,this.user});
  @override
  _ObjectDescriptionState createState() => _ObjectDescriptionState();
}

class _ObjectDescriptionState extends State<ObjectDescription> {

   _buildRatingStars(double rating , double persons) {
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
  List<String> Listrate = List<String>();
  double sumRate =0;
  IconData icon = Icons.favorite_border;
  Timestamp joined ;
  String reviewM,reviewY;
  String hostedName;
  String price;
  String userPhoto;
  String userPhone;
  String hostedinfo;
  List<String> CountReview = [];
  String rent_time_for;
  String priceType,GruopChatID;
  String hostSR;
  FToast fToast;
  var bojs = List<Objects>();
  final objectcontroller = Get.put(objectController());

  @override
  void initState() {
    super.initState();

    _calculation();
    fToast = FToast();
    fToast.init(context);
    FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.objOwner).snapshots().listen((v) {
      v.docs.forEach((element) {
        hostedName = element["name_f"];
        joined = element['sginupdate'];
        hostedinfo = element['user_info'];
        userPhoto = element['image'];
        userPhone = element['phone'];
      });
    });
    setState(() {
      FirebaseFirestore.instance.collection("review").where("hostID",isEqualTo:widget.id).snapshots().listen((v) {
        v.docs.forEach((element) {
          CountReview.add(element['id']);
        });
      });
      FirebaseFirestore.instance.collection("Objects").where("id",isEqualTo:widget.id).snapshots().listen((v) {
        v.docs.forEach((element) {
          rent_time_for = element['rent_time_for'];
          price = element['price'];
          hostSR = element['hosr_sale_rent'];
          priceType = element['money_type'];
        });
      });
      FirebaseFirestore.instance.collection("review").where("hostID",isEqualTo: widget.id).snapshots().listen((v) {
        v.docs.forEach((doc){
          Listrate.add("${doc["rate"]}");
          sumRate = sumRate+doc["rate"];
        });
      });
    });
    print(Listrate);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {

      });
    });
    _isSaved();
  }
  _isSaved(){

    setState(() {
      if(widget.user != null) {
        FirebaseFirestore.instance.collection("Saved/${widget.user.uid}/saved")
            .where("id", isEqualTo: widget.id).snapshots()
            .listen((v) {
          v.docs.forEach((doc) =>
          icon = Icons.favorite);
        });
      }
    });

  }
  Future _calculation() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));
    bojs =
        objectcontroller.objects.where((e) => (e.id == widget.id)).toList();
    return bojs;
  }

  _line(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height:  size.height*0.03,
        ),
        SizedBox(
          height:  size.height*0.0005,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height:  size.height*0.03,
        ),
      ],
    );
  }
   adKind(homeFor){
     switch(homeFor){
       case "For sale" :return AppLocalizations.of(context).for_sale;break;
       case "For rent" :return AppLocalizations.of(context).for_rent;break;
     }
   }
   adrentFor(rentFor){
     switch(rentFor){
       case "Yearly" :return AppLocalizations.of(context).yearly;break;
       case "Monthly" :return AppLocalizations.of(context).tourism;break;
     }
   }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder(
          future: _calculation(),
          builder: (context,f){
            return(f.hasData)?
            Scaffold(
              body: ListView.builder(
                  itemCount: bojs.length,
                  itemBuilder: (context , index){
                    return Column(
                      children: [
                        Container(
                            height: size.height * .35,
                            width: size.width,
                            child: Stack(
                              children: [
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("Images")
                                        .where('obj_ID', isEqualTo: int.parse(bojs[index].id))
                                        .snapshots(),
                                    builder: (context, snap) {
                                      if (snap.hasData) {
                                        return Column(
                                          // padding: EdgeInsets.only(bottom: size.height*0.125),
                                            children:[
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> openImages(bojs[index].objname,bojs[index].id)));
                                                },
                                                child: Container(
                                                    child: SizedBox(
                                                      height: size.height * .35,
                                                      width: double.infinity,
                                                      child: Carousel(
                                                          autoplayDuration: Duration(seconds: 5),
                                                          dotSize: 5,
                                                          images: snap.data.docs
                                                              .map<Widget>((img) {
                                                            return Image.network(
                                                              img["image"],
                                                              fit: BoxFit.fill,
                                                            );
                                                          }).toList()),
                                                    )),
                                              ),


                                            ] );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                Positioned(
                                    left: size.width*0.02,
                                    top: size.height*0.01,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        height: 50,width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(50)
                                        ),
                                        child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),),
                                    )),
                                (widget.user != null)?
                                (widget.user.uid != widget.objOwner)?
                                Positioned(
                                    right: size.width*0.02,
                                    top: size.height*0.01,
                                    child:Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              if(icon == Icons.favorite_border) {
                                                icon = Icons.favorite;
                                                FirebaseFirestore.instance.collection("Saved/${widget.user.uid}/saved").doc(widget.id).set({
                                                  "id":widget.id,
                                                  "user_id": widget.user.uid,
                                                });
                                              }else {
                                                icon = Icons.favorite_border;
                                                FirebaseFirestore.instance.collection("Saved/${widget.user.uid}/saved").doc(widget.id).delete();

                                              }
                                            })
                                            ;
                                          },
                                          child: Container(
                                            height: 50,width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            child: Icon(icon,size: 25,),),
                                        ),
                                        SizedBox(
                                          width:size.width*0.01 ,),
                                        Container(
                                          height: 50,width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(50)
                                          ),
                                          child: PopupMenuButton(
                                            icon: Icon(FontAwesomeIcons.ellipsisV,size: 17.5,
                                              color: Colors.black,),
                                            itemBuilder: (context)=><PopupMenuEntry<String>>[
                                               PopupMenuItem<String>(
                                                value: 'review',
                                                child: Row(
                                                  children: [
                                                    Icon(FontAwesomeIcons.solidStar,size: 15,
                                                      color: Colors.amber,),
                                                    SizedBox(width: size.width*0.02,),
                                                    Text(AppLocalizations.of(context).add_review,style: TextStyle(fontFamily: 'poppins',
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            iconSize: 17.5,
                                            elevation: 20,
                                            onSelected: (String result) {
                                              switch (result) {
                                                case 'review':
                                                  setState(() {
                                                    showModalBottomSheet<void>(
                                                      isScrollControlled: true,
                                                      enableDrag: true,
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                                      ),
                                                      builder: (BuildContext context) {
                                                        return _showModalBottomSheetContainer();
                                                      },
                                                    );
                                                  });
                                                  break;
                                                default:
                                              }
                                            },
                                          ),)
                                      ],
                                    ))
                                    :Container(height: 0,)
                                    :Container(height: 0,),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(right: size.height*0.015, top:size.height*0.015, left:size.height*0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${bojs[index].objname}",
                                style: TextStyle(fontFamily: 'poppins',
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              (bojs[index].hosr_sale_rent == "For rent")?
                              (bojs[index].rent_time_for == "Yearly")?
                              Text(
                                "${adKind(bojs[index].hosr_sale_rent)} ${adrentFor(bojs[index].rent_time_for)}",
                                style: TextStyle(fontFamily: 'poppins',
                                    color: Colors.black54,
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.bold),
                              ):
                              Text(
                                "${adKind(bojs[index].hosr_sale_rent)} ${adrentFor(bojs[index].rent_time_for)}",
                                style: TextStyle(fontFamily: 'poppins',
                                    color: Colors.black54,
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.bold),
                              ):
                              Text(
                                "${adKind(bojs[index].hosr_sale_rent)}",
                                style: TextStyle(fontFamily: 'poppins',
                                    color: Colors.black54,
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: size.height*0.01,
                              ),
                              Row(
                                children: [
                                  (Listrate.length !=0)?
                                  Row(children: [
                                    _buildRatingStars(
                                        sumRate.toDouble(),Listrate.length.toDouble()),
                                    SizedBox(
                                      width: size.width*0.05,
                                    ),
                                  ],):Container(height: 0,width: 0,),
                                  Text(
                                    "${bojs[index].state}, ${bojs[index].city}, Turkey",
                                    style: TextStyle(fontFamily: 'poppinslight',
                                        fontSize: 17, color: Colors.black54),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height*0.01,
                              ),
                              Row(
                                children: [
                                  Text("Ads id :   ${bojs[index].id}",style: TextStyle(fontFamily: 'poppins',
                                      color: Colors.black54,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),),
                                  IconButton(
                                    onPressed: (){
                                      Clipboard.setData(new ClipboardData(text: "${bojs[index].id}"));
                                      fToast.showToast(
                                        child: Padding(
                                          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                                          child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25.0),
                                                color: Colors.black,
                                              ),
                                              child: Text(AppLocalizations.of(context).copied_to_Clipboard,
                                                style: TextStyle(
                                                    color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                                        ),
                                        gravity: ToastGravity.BOTTOM,

                                        toastDuration: Duration(seconds: 2),
                                      )
                                      ;
                                    },
                                    icon: Icon(Icons.copy),
                                    highlightColor: Colors.black54,
                                    splashRadius: 13,
                                  ),
                                ],
                              ),
                              _line(context),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(bojs[index].type,style: TextStyle(fontFamily: 'poppins',
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                      Text("${AppLocalizations.of(context).hosted_by} ${hostedName}",style: TextStyle(fontFamily: 'poppinslight',
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      if(widget.objOwner != widget.user.uid) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainProfile(
                                                      user: widget.user,
                                                      Guser: widget.objOwner,
                                                    )));
                                      }
                                    },
                                    child: Container(
                                      height: size.height*0.07,width: size.width*0.2,
                                      child: CircleAvatar(
                                          radius:30,
                                          backgroundImage:
//                                null == photoUrl
//                                    ? ((snapshot.data["image"] == "")
//                                    ?
                                          (userPhoto == ""||userPhoto == null)?
                                          AssetImage(
                                              'assets/images/5.jpg'):
                                          NetworkImage(userPhoto)),
                                    ),
                                  )
//                                    : NetworkImage(snapshot.data["image"]))
//                                    : NetworkImage(photoUrl)),
                                ],
                              ),
                              SizedBox(height: size.height*0.01,),
                              Text("${bojs[index].roomNO} Home ",style: TextStyle(fontFamily: 'poppinslight',
                                  fontSize: 17, color: Colors.black54 , fontWeight: FontWeight.bold),),
                              _line(context),
                              Row(
                                children: [
                                  Container(
                                    width: size.width*0.3,
                                    height: size.height*0.16,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5,
                                          color: Colors.black54
                                      ),),
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.height*0.075,width: size.width*0.15,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage("assets/images/bed.png"),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: size.height*0.025),
                                          child: Text("${bojs[index].bedroomNO} ${AppLocalizations.of(context).bedroom}",style: TextStyle(fontFamily: 'poppinslight',
                                              fontSize: 13, color: Colors.black54 , fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width*0.3,
                                    height: size.height*0.16,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(left: size.width*0.01),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5,
                                          color: Colors.black54
                                      ),),
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.height*0.075,width: size.width*0.15,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage("assets/images/bathtub.png"),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: size.height*0.025),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: Text("${bojs[index].bathroomNO} ${AppLocalizations.of(context).bathroom}",style: TextStyle(fontFamily: 'poppinslight',
                                                    fontSize: 13, color: Colors.black54 , fontWeight: FontWeight.bold)),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: size.width*0.3,
                                    height: size.height*0.16,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(left: size.width*0.01),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5,
                                          color: Colors.black54
                                      ),),
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.height*0.075,width: size.width*0.15,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage("assets/images/balcon.png"),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: size.height*0.025),
                                          child: Text((bojs[index].balcony== "Available")?AppLocalizations.of(context).balcony
                                              :AppLocalizations.of(context).no_balcony,style: TextStyle(fontFamily: 'poppinslight',
                                              fontSize: 13, color: Colors.black54 , fontWeight: FontWeight.bold)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              _line(context),
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.home,size: 25,color: Colors.black54,),
                                  SizedBox(width: size.width*0.05,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(bojs[index].type,style: TextStyle(fontFamily: 'poppins',fontSize: 17.5,color: Colors.black,fontWeight: FontWeight.bold),),
                                      Text(AppLocalizations.of(context).enjoy_your_stay,style: TextStyle(fontFamily: 'poppinslight',fontSize: 12.5))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01,),
                              (bojs[index].hosr_sale_rent != "For sale")?
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.bookOpen,size: 25,color: Colors.black54,),
                                  SizedBox(width: size.width*0.05,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppLocalizations.of(context).house_Rules,style: TextStyle(fontFamily: 'poppins',fontSize: 17.5,color: Colors.black,fontWeight: FontWeight.bold),),
                                      InkWell(child: Text(AppLocalizations.of(context).get_details,style: TextStyle(fontFamily: 'poppinslight',fontSize: 12.5,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2)),onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)
                                      => HouseRules(Oid: widget.id,)));},)
                                    ],
                                  ),
                                ],
                              ):Container(height: 0,),
                              SizedBox(height: size.height * 0.01,),
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.dollarSign,size: 25,color: Colors.black54,),
                                  SizedBox(width: size.width*0.05,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppLocalizations.of(context).price,style: TextStyle(fontFamily: 'poppins',fontSize: 17.5,color: Colors.black,fontWeight: FontWeight.bold),),
                                      InkWell(child: Text(AppLocalizations.of(context).get_details,style: TextStyle(fontFamily: 'poppinslight',fontSize: 12.5,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2)),onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)
                                      => Money_ALL(Oid: widget.id,)));},)
                                    ],
                                  ),
                                ],
                              ),
                              _line(context),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).more_information,
                                    style: TextStyle(fontFamily: 'poppins',
                                        fontWeight: FontWeight.bold, fontSize: 17),
                                  ),
                                  Container(
                                    // height: size.height*0.1,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child:
                                    (bojs[index].information.length>=100)?
                                    Text(bojs[index].information.substring(0,100) + '...',
                                      style: TextStyle(fontFamily: 'poppinslight',
                                        height: 1.5,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ):Text(bojs[index].information,
                                      style: TextStyle(fontFamily: 'poppinslight',
                                        height: 1.5,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MoreInformation(Oid: widget.id,))),
                                        child: Text(
                                          AppLocalizations.of(context).read_more,
                                          style: TextStyle(fontFamily: 'poppinslight',
                                            decoration: TextDecoration.underline,
                                            decorationThickness: 1,
                                            decorationStyle: TextDecorationStyle.double,
                                            color: Colors.black,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                      Icon(FontAwesome.angle_right)
                                    ],
                                  ),
                                  _line(context),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).amenities,
                                        style: TextStyle(fontFamily: 'poppins',
                                            fontWeight: FontWeight.bold, fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  Amenti(objID: bojs[index].id,
                                    bojs: bojs[index],),
                                  SizedBox(height: size.height*0.02,),
                                  FlatButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ALL_AMENITIES(Oid: widget.id,
                                        bojs: bojs[index],)));
                                    },
                                    child: Container(
                                        width: size.width,
                                        height: size.height*0.06,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7.5),
                                            border: Border.all(
                                                width: 0.5,
                                                color: Colors.black54
                                            )
                                        ),
                                        child: Center(
                                            child: Text(AppLocalizations.of(context).show_all_amenities,style: TextStyle(
                                                fontFamily: 'poppinslight',
                                                fontSize: 15,fontWeight: FontWeight.bold),))),
                                    color: Colors.white,),
                                ],
                              ),
                              (CountReview.length > 0)?
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("review").where("hostID",isEqualTo: widget.id).limit(1).snapshots(),
                                  builder: (context, s){
                                    if(s.hasData){
                                      return Column(
                                        children: s.data.docs.map<Widget>((d){
                                          reviewM = d['month'];
                                          reviewY = d['year'];
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _line(context),
                                              Row(
                                                children: [
                                                  Icon(Icons.star , color: Colors.amber,size: 25,),
                                                  Text("${d['rate']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 17.5,fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              SizedBox(height: size.height*0.02,),
                                              StreamBuilder(
                                                  stream: FirebaseFirestore.instance.collection("Users").where("id",isEqualTo: d["reviewer"]).snapshots(),
                                                  builder: (context, snapshot) {
                                                    if(snapshot.hasData){
                                                      return Column(
                                                        children: snapshot.data.docs.map<Widget>((user){
                                                          return Row(
                                                            children: [
                                                              Container(
                                                                //  height: size.height*0.07,width: size.width*0.2,
                                                                child: CircleAvatar(
                                                                    radius:25,
                                                                    backgroundImage:
                                                                    (user["image"] == ""||user["image"] == null)?
                                                                    AssetImage(
                                                                        'assets/images/5.jpg'):
                                                                    NetworkImage(user['image'])
                                                                ),
                                                              ),
                                                              SizedBox(width: size.width*0.02,),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text('${user['name_f']} ${user['name_l']}',style: TextStyle(color: Colors.black,fontSize: 17.5,fontFamily: 'poppins',
                                                                      fontWeight: FontWeight.bold),),
                                                                  Text('${_MonthsName(reviewM)} ${reviewY}',style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.black,fontSize: 12.5,fontFamily: 'poppinslight'))
                                                                ],
                                                              )
                                                            ],
                                                          );
                                                        }).toList(),
                                                      );
                                                    }else{return Container();}
                                                  }
                                              ),
                                              SizedBox(height: size.height*0.025,),
                                              Text("${d['msg']}",
                                                style: TextStyle(fontWeight: FontWeight.w500,
                                                    color: Colors.black,fontSize: 15,fontFamily: 'poppins'),),
                                              SizedBox(height: size.height*0.02,),
                                              FlatButton(
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllReviews(Oid: widget.id,)));
                                                },
                                                child: Container(
                                                    width: size.width,
                                                    height: size.height*0.06,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(7.5),
                                                        border: Border.all(
                                                            width: 0.5,
                                                            color: Colors.black54
                                                        )
                                                    ),
                                                    child: Center(
                                                        child: Text(AppLocalizations.of(context).show_all_reviews,style: TextStyle(
                                                            fontFamily: 'poppinslight',
                                                            fontSize: 15,fontWeight: FontWeight.bold),))),
                                                color: Colors.white,),
                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }else{return Container();}
                                  }
                              ):
                              Container(height: 0,width: 0,),
                              _line(context),
                              //todo
                              GestureDetector(
                                onLongPress: (){
                                  Clipboard.setData(new ClipboardData(text:"${bojs[index].address},${bojs[index].state}/${bojs[index].city}"));
                                  fToast.showToast(
                                    child: Padding(
                                      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.0),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Text(AppLocalizations.of(context).copied_to_Clipboard,
                                            style: TextStyle(
                                                color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                                    ),
                                    gravity: ToastGravity.BOTTOM,

                                    toastDuration: Duration(seconds: 2),
                                  )
                                  ;
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).location,
                                      style: TextStyle(fontFamily: 'poppins',
                                          fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                    SizedBox(height: size.height*0.01,),
                                    Text("${AppLocalizations.of(context).city} : ${bojs[index].city}",
                                      style: TextStyle(fontWeight: FontWeight.w500,
                                          color: Colors.black,fontSize: 15,fontFamily: 'poppins'),),
                                    Text("${AppLocalizations.of(context).state} : ${bojs[index].state}",
                                      style: TextStyle(fontWeight: FontWeight.w500,
                                          color: Colors.black,fontSize: 15,fontFamily: 'poppins'),),
                                    Text("${AppLocalizations.of(context).street} : ${bojs[index].address}",
                                      style: TextStyle(fontWeight: FontWeight.w500,
                                          color: Colors.black,fontSize: 15,fontFamily: 'poppins'),),
                                    Text("${AppLocalizations.of(context).postCode} : ${bojs[index].postcode}",
                                      style: TextStyle(fontWeight: FontWeight.w500,
                                          color: Colors.black,fontSize: 15,fontFamily: 'poppins'),),
                                  ],
                                ),
                              ),
                              _line(context),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${AppLocalizations.of(context).hosted_by} ${hostedName}",style: TextStyle(fontFamily: 'poppins',
                                          color: Colors.black,
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold),),
                                      Text("${AppLocalizations.of(context).joined_in} ${_MonthsName("${joined.toDate().month}")} ${joined.toDate().year}",style: TextStyle(fontFamily: 'poppinslight',
                                          color: Colors.black,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: (){
                    if(widget.objOwner != widget.user.uid) {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          MainProfile(
                            user: widget.user, Guser: widget.objOwner,
                          )));
                    }
                                    },
                                    child: Container(
                                      height: size.height*0.07,width: size.width*0.2,
                                      child: CircleAvatar(
                                          radius:30,
                                          backgroundImage:
//                                null == photoUrl
//                                    ? ((snapshot.data["image"] == "")
//                                    ?
                                          (userPhoto == ""||userPhoto == null)?
                                          AssetImage(
                                              'assets/images/5.jpg'):
                                          NetworkImage(userPhoto)
                                      ),
                                    ),
                                  )
//                                    : NetworkImage(snapshot.data["image"]))
//                                    : NetworkImage(photoUrl)),
                                ],
                              ),
                              SizedBox(height: size.height*0.02,),
                              (hostedinfo == "" || hostedinfo == null)?Container(height: 0,width: 0,) :
                              GestureDetector(
                                onLongPress: (){
                                  Clipboard.setData(new ClipboardData(text: hostedinfo));
                                  fToast.showToast(
                                    child: Padding(
                                      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25.0),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: Text(AppLocalizations.of(context).copied_to_Clipboard,
                                            style: TextStyle(
                                                color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                                    ),
                                    gravity: ToastGravity.BOTTOM,

                                    toastDuration: Duration(seconds: 2),
                                  )
                                  ;
                                },
                                child: Text("$hostedinfo",
                                  style: TextStyle(fontWeight: FontWeight.w500,
                                      color: Colors.black,fontSize: 15,fontFamily: 'poppinslight'),),
                              ),
                              SizedBox(height: size.height*0.02,),
                              Padding(padding: EdgeInsets.only(right: size.height*0.005),
                              child: _WidgetMsgHost(),),
                              SizedBox(height: size.height*0.01,),
                              _line(context),
                              InkWell(
                                highlightColor: Colors.white,
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportPage(
                                    user: widget.user,hostid: widget.objOwner,oid: widget.id,
                                  )));
                                },
                                child: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.fontAwesomeFlag),
                                    SizedBox(width: size.width*0.05,),
                                    Text(AppLocalizations.of(context).report_listing,style: TextStyle(fontFamily: 'poppins',fontSize: 15
                                        ,decoration: TextDecoration.underline,decorationThickness: 2,fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              SizedBox(height: size.height*0.02,),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                bottomNavigationBar:_WidgetNavigationBar()
            ):
            Center(
                child: SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: size.height*0.05,
                ));
          },
        ),



    );
  }

  _month(int m){
    if(m == 1){
      return             "January";
    }else if(m == 2){
      return             "February";
    }else if(m == 3){
      return             "March";
    }else if(m == 4){
      return             "April";
    }else if(m == 5){
      return             "May";
    }else if(m == 6){
      return             "June";
    }else if(m == 7){
      return             "July";
    }else if(m == 8){
      return             "August";
    }else if(m == 9){
      return             "September";
    }else if(m == 10){
      return             "October";
    }else if(m == 11){
      return             "November";
    }else if(m == 12){
      return             "December";
    }
  }

  _WidgetMsgHost(){
    Size size = MediaQuery.of(context).size;
    if(widget.user!=null){
      return (widget.user.uid==widget.objOwner)?
      Container(height: 0,width: 0,):
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (userPhone == ""|| userPhone == null)?
          Container(height: 0,width: 0,):
          FlatButton(
            onPressed: (){
              UrlLauncher.launch("tel://+90$userPhone");
            },
            highlightColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
                width: size.width*.4,
                height: size.height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    border: Border.all(
                        width: 0.5,
                        color: Colors.black54
                    )
                ),
                child: Center(
                    child: Text("Call",style: TextStyle(
                        fontFamily: 'poppinslight',
                        fontSize: 15,fontWeight: FontWeight.bold),))),
            color: Colors.white,),
          FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageHost(
                hostid: widget.objOwner,Oid: widget.id,user: widget.user,
              )));
            },
            highlightColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
                width: size.width*.4,
                height: size.height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    border: Border.all(
                        width: 0.5,
                        color: Colors.black54
                    )
                ),
                child: Center(
                    child: Text(AppLocalizations.of(context).contact_host,style: TextStyle(
                        fontFamily: 'poppinslight',
                        fontSize: 12.5,fontWeight: FontWeight.bold),))),
            color: Colors.white,),
        ],
      );
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          (userPhone == ""|| userPhone == null)?
          Container(height: 0,width: 0,):
          FlatButton(
            onPressed: (){
              UrlLauncher.launch("tel://+90$userPhone");
            },
            highlightColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
                width: size.width*.4,
                height: size.height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    border: Border.all(
                        width: 0.5,
                        color: Colors.black54
                    )
                ),
                child: Center(
                    child: Text("Call",style: TextStyle(
                        fontFamily: 'poppinslight',
                        fontSize: 15,fontWeight: FontWeight.bold),))),
            color: Colors.white,),
          FlatButton(
            onPressed: (){
              fToast.showToast(
                child: Padding(
                  padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(AppLocalizations.of(context).login_first,
                        style: TextStyle(
                            color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                ),
                gravity: ToastGravity.BOTTOM,

                toastDuration: Duration(seconds: 2),
              )
              ;
            },
            highlightColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Container(
                width: size.width*.4,
                height: size.height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    border: Border.all(
                        width: 0.5,
                        color: Colors.black54
                    )
                ),
                child: Center(
                    child: Text(AppLocalizations.of(context).contact_host,style: TextStyle(
                        fontFamily: 'poppinslight',
                        fontSize: 15,fontWeight: FontWeight.bold),))),
            color: Colors.white,),
        ],
      );
    }
  }
  _WidgetNavigationBar(){
    Size size = MediaQuery.of(context).size;
    if(widget.user!=null){
      return (widget.user.uid==widget.objOwner)?
      Container(height: 0,width: 0,):
      (hostSR == "For rent")? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (rent_time_for == "Yearly")?Text("$price $priceType / month",style: TextStyle(
                fontFamily: 'poppinslight',
                fontSize: 15,fontWeight: FontWeight.bold),):
            Text("$price $priceType / night",style: TextStyle(
                fontFamily: 'poppinslight',
                fontSize: 15,fontWeight: FontWeight.bold),),
            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageHost(
                    hostid: widget.objOwner,Oid: widget.id,user: widget.user,
                  )));
                },
                child:Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                  //width: size.width*0.3,
                  height: size.height*0.06,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Center(
                        child: Text(AppLocalizations.of(context).contact_host,style: TextStyle(
                            fontFamily: 'poppins',color: Colors.white,
                            fontSize: 15,fontWeight: FontWeight.bold),)),
                  ),
                )

            ),
          ],
        ),
      ):
      Padding(padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MessageHost(
                hostid: widget.objOwner,Oid: widget.id,user: widget.user,
              )));
            },
            child:
            Container(
              height: size.height*0.06,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(7.5),

              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: Center(
                    child: Text(AppLocalizations.of(context).contact_host,style: TextStyle(
                        fontFamily: 'poppins',color: Colors.white,
                        fontSize: 15,fontWeight: FontWeight.bold),)),
              ),
            )
        ),);
    }else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: (){
              fToast.showToast(
                child: Padding(
                  padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(AppLocalizations.of(context).login_first,
                        style: TextStyle(
                            color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                ),
                gravity: ToastGravity.BOTTOM,

                toastDuration: Duration(seconds: 2),
              );
            },
            child:Container(
              height: size.height*0.06,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(7.5),

              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: Center(
                    child: Text(AppLocalizations.of(context).contact_host,style: TextStyle(
                        fontFamily: 'poppins',color: Colors.white,
                        fontSize: 15,fontWeight: FontWeight.bold),)),
              ),
            )

        ),
      );
    }
  }

  double rate = 3.0;
  String mesj='';
  DateTime today = DateTime.now();
   _showModalBottomSheetContainer(){
     Size size = MediaQuery.of(context).size;
     return Container(
       margin: EdgeInsets.only(
           bottom: MediaQuery.of(context).viewInsets.bottom),
       padding: EdgeInsets.only(top: size.height*0.03),
       width: size.width,height: size.height*0.475,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
             child: Row(
               children: [
                 GestureDetector(
                   onTap: () {
                     Navigator.of(context).pop();
                   },
                   child: Icon(
                     FontAwesomeIcons.times,
                     size: 15,
                   ),
                 ),
                 SizedBox(
                   width: size.width * 0.05,
                 ),
                 Text(
                   AppLocalizations.of(context).rate_place,
                   style: TextStyle(
                       fontSize: 15,
                       fontWeight: FontWeight.bold,
                       fontFamily: 'poppins'),
                 ),
               ],
             ),
           ),
           SizedBox(
             height: size.height * 0.025,
           ),
           SizedBox(
             height:  size.height*0.001,
             width: MediaQuery.of(context).size.width,
             child: Container(
               color: Colors.black54,
             ),
           ),
           SizedBox(
             height: size.height * 0.025,
           ),
           Padding(
             padding:  EdgeInsets.only(left: size.width * 0.07,
                 right: size.width * 0.07),
             child: Text(
               AppLocalizations.of(context).rate_write_review,
               style: TextStyle(
                   fontSize: 17.5,
                   fontWeight: FontWeight.bold,
                   fontFamily: 'poppinsbold'),
             ),
           ),
           SizedBox(height: size.height*0.015,),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               RatingBar.builder(
                 initialRating: rate,
                 minRating: 1,
                 direction: Axis.horizontal,
                 allowHalfRating: true,
                 itemCount: 5,
                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                 itemBuilder: (context, _) => Icon(
                   Icons.star,
                   color: Colors.amber,
                 ),
                 onRatingUpdate: (rating) {
                   setState(() {
                     rate = rating;
                   });
                 },
               )
             ],
           ),
           SizedBox(height: size.height*0.02,),
           Padding(
               padding:  EdgeInsets.only(left: size.width * 0.07,
                   right: size.width * 0.07),
               child: Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                     border: Border.all(
                         width: 0.75,
                         color: Colors.black45
                     )
                 ),
                 child: Padding(
                   padding: const EdgeInsets.only(left: 5,right: 5,bottom: 1),
                   child: TextFormField(
                     initialValue: mesj,
                     onChanged: (v) {
                       setState(() {
                         mesj = v;
                       });
                     },
                     maxLines: 4,
                     style: TextStyle(
                       color: Colors.black,
                       fontSize: 15,
                       fontFamily: 'poppins',
                     ),
                     decoration: InputDecoration(
                       border: InputBorder.none,
                       hintText: AppLocalizations.of(context).great_place_stay,
                       hintStyle: TextStyle(
                         color: Colors.black,
                         fontSize: 15,
                         fontFamily: 'poppins',
                       ),
                     ),
                   ),
                 ),
               )
           ),
           SizedBox(height: size.height*0.02,),
           Padding(
             padding:  EdgeInsets.only(left: size.width * 0.07,
                 right: size.width * 0.07),
             child: GestureDetector(
                 onTap: (){
                   Random rnd = Random();
                   var rnd1 = rnd.nextInt(500000000).toString();
                   var msgNO = rnd.nextInt(500000000).toString();
                   FirebaseFirestore.instance
                       .collection('review')
                       .doc(rnd1)
                       .set({
                     "id":rnd1,
                     "hostID":widget.id,
                     "reviewer":widget.user.uid,
                     "rate":rate,
                     "msg":mesj,
                     "month":"${today.month}",
                     "year":"${today.year}",

                   });

                   Navigator.pop(context);
                   fToast.showToast(
                     child: Padding(
                       padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .025),
                       child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(25.0),
                             color: Theme.of(context).primaryColor,
                           ),
                           child: Text(AppLocalizations.of(context).thankU,style: TextStyle(
                               color:Colors.white,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                     ),
                     gravity: ToastGravity.TOP,

                     toastDuration: Duration(seconds: 2),
                   );

                 },
                 child:Container(
                   width: size.width,
                   height: size.height*0.06,
                   decoration: BoxDecoration(
                       color: Theme.of(context).primaryColor,
                       borderRadius: BorderRadius.circular(7.5),

                   ),
                   child: Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(7.5),
                     ),
                     child: Center(
                         child: Text(AppLocalizations.of(context).review,style: TextStyle(
                             fontFamily: 'poppins',color: Colors.white,
                             fontSize: 15,fontWeight: FontWeight.bold),)),
                   ),
                 )
             ),
           ),



         ],
       ),
     );
   }
   _MonthsName(String d){
     switch(d){
       case "1":return AppLocalizations.of(context).january;break;
       case "2":return AppLocalizations.of(context).february;break;
       case "3":return AppLocalizations.of(context).march;break;
       case "4":return AppLocalizations.of(context).april;break;
       case "5":return AppLocalizations.of(context).may;break;
       case "6":return AppLocalizations.of(context).june;break;
       case "7":return AppLocalizations.of(context).july;break;
       case "8":return AppLocalizations.of(context).august;break;
       case "9":return AppLocalizations.of(context).september;break;
       case "10" :return AppLocalizations.of(context).october;break;
       case "11" :return AppLocalizations.of(context).november;break;
       case "12" :return AppLocalizations.of(context).december;break;

     }
   }
}

class openImages extends StatefulWidget {
  final objName;
  final ID;
   openImages(this.objName,this.ID) ;
  @override
  _openImagesState createState() => _openImagesState();
}

class _openImagesState extends State<openImages> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(backgroundColor:Colors.white,title: Text("${widget.objName}",style: TextStyle(fontFamily: 'poppinsbold',
          color: Colors.black,
          fontSize: 17.5,
          fontWeight: FontWeight.bold)),),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Images")
              .where('obj_ID', isEqualTo: int.parse("${widget.ID}"))
              .snapshots(),
          builder: (context, snap) {
            if (snap.hasData) {
              return Column(
                // padding: EdgeInsets.only(bottom: size.height*0.125),
                  children:[
                    Container(
                        child: SizedBox(
                          height: size.height ,
                          width: double.infinity,
                          child: Carousel(
                             // autoplayDuration: Duration(seconds: 5),
                              dotSize: 5,
                              images: snap.data.docs
                                  .map<Widget>((img) {
                                return Image.network(
                                  img["image"],
                                  fit: BoxFit.contain,
                                );
                              }).toList()),
                        )),


                  ] );
            } else {
              return Container();
            }
          }),
    );
  }
}

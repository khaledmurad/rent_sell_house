import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_mate_app/auth/auth.dart';
import 'package:home_mate_app/auth/login.dart';
import 'package:home_mate_app/controllers/reviews_controller.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/models/reviews.dart';
import 'package:provider/provider.dart';

class SavedPage extends StatefulWidget {
  User user;
  SavedPage({@required this.user});
  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  _SavedPageState({@required this.user});
  User user;
  List<String> isSave ;
  List<dynamic> Listrate = [];
  var reviews = List<Review>();
  var allrate = [];
  double sumRate = 0.0;
  double i;
  final reviewcontroller = Get.put(reviewController());
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
  @override
  void initState() {
    super.initState();
    isSave = [];
    if(widget.user!=null) {
    FirebaseFirestore.instance.collection("Saved/${widget.user.uid}/saved").where(
        "user_id", isEqualTo: widget.user.uid).snapshots().listen((event) {
    event.docs.forEach((element) {
      isSave.add(element['id']);
    });
  });
}
  }

  Future<Null> refresh() async{
    await Future.delayed(Duration(seconds: 2));
    isSave.clear();
    if(widget.user!=null) {
      FirebaseFirestore.instance.collection("Saved/${widget.user.uid}/saved").where(
          "user_id", isEqualTo: widget.user.uid).snapshots().listen((event) {
        event.docs.forEach((element) {
          isSave.add(element['id']);
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: RefreshIndicator(
        onRefresh: refresh,
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Container(
          height: size.height,
          child: ListView(
            padding: EdgeInsets.only(
                top: size.height * 0.08,
                left: size.width * 0.07,
                right: size.width * 0.07),
            children: [
              InkWell(
                onTap: (){
                  print(isSave.length);
                },
                child: Text(
                  AppLocalizations.of(context).saved,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppinsbold'),
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Text(
                AppLocalizations.of(context).collect_places_to_stay,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,fontFamily: 'poppinslight',),
              ),
              StreamBuilder<User>(
                  stream: auth.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      user = snapshot.data;
                      if (user == null || user.isAnonymous) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    //width: size.width * 0.25,
                                    height: size.height * 0.075,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Center(
                                      child: Text(AppLocalizations.of(context).login,style: TextStyle(
                                          color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return FutureBuilder(
                          future: _ww(),
                          builder: (context, snapshot){
                            return ListTile(
                              title: (isSave.length >0)?_isSaved():_isNON(),
                            );
                          },
                        );
                      }
                    } else {
                      return Container(
                        height: 0,
                        width: 0,
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
  Future<Widget> _ww() async {
    if(isSave.length >0){
      await new Future.delayed(const Duration(seconds: 5));
      return  _isSaved();
    }else{ return _isNON();}
  }

  _isSaved(){
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.02,
        ),
        Container(
       //   height: size.height,
          width: size.width,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Objects").where("id",whereIn: isSave).snapshots(),
            builder: (context , snapshot){
              if(snapshot.hasData){
                return Padding(
                  padding: EdgeInsets.only(bottom: size.height*0.025),
                  child: Column(
                    children: snapshot.data.docs
                        .map<Widget>((doc){
                      _widgetRate(doc['id']);
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDescription(id: doc['id'],objOwner: doc['ADID'],
                            user: widget.user,)));
                        },
                        child: Container(
                          padding: EdgeInsets.only(top:20),
                          height: size.height*0.2,width: size.width,
                          child: Row(
                            children: [
                              Container(
                                height: size.height*0.2,width: size.width*0.35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      bottomLeft: Radius.circular(12.0)
                                    ),
                                    image: DecorationImage(
                                        image: NetworkImage(doc['image']),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              SizedBox(width: size.width*0.05,),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (reviews.length != 0)?
                                    _buildRatingStars(sumRate, double.parse("${reviews.length}")):
                                    Container(height: 0,),
                                    SizedBox(height: size.height*0.01,),
                                    Text("${doc["type"]} . ${doc['city']}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,fontWeight: FontWeight.w600),),
                                    SizedBox(height: size.height*0.005,),
                                    Text("${doc['objname']}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'poppinslight'),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }else{
                return Container();
              }
            },
          ),
        )
      ],
    );
  }

  _isNON(){
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.1,
          ),
          Image.asset("assets/images/bookmark.png",height: 50,width: 50,),
          SizedBox(height: 10,),
          Center(child: Text(AppLocalizations.of(context).start_save_what_you_like,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'poppins',),)),
        ],
      ),
    );
  }
}

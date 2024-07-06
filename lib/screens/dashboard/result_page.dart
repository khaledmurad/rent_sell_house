import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:home_mate_app/controllers/reviews_controller.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/models/reviews.dart';

class ResultPAGE extends StatefulWidget {
  final ID;
  User user;
   ResultPAGE(this.ID,this.user);

  @override
  _ResultPAGEState createState() => _ResultPAGEState();
}

class _ResultPAGEState extends State<ResultPAGE> {
  List<dynamic> all_obj =[];
  List<dynamic> all_user =[];
  var all_objcts =[];
  var all_users =[];
  Future _calculation() async {
    await new Future<Widget>.delayed(const Duration(seconds: 3));

      all_user = all_users
          .toList();

      if(widget.ID.toString().contains(RegExp(r'[0-9]'))&&!widget.ID.toString().contains(RegExp(r'[a-z]'))) {
        all_obj = all_objcts
            .where((e) => e['awaiting_approval'] == 'Approval')
            .where((e) => e['objState'] == 'Active')
            .where((e) =>
        e['id'].toString() == widget.ID.toString() )
            .toList();
      }else{
        all_obj = all_objcts
            .where((e) => e['awaiting_approval'] == 'Approval')
            .where((e) => e['objState'] == 'Active')
            .where((e) =>
        "${e['ADowner']
            .toString()
            .toLowerCase()}"
            == widget.ID.toString().toLowerCase() )
            .toList();
      }
      all_obj.shuffle();

    return all_obj;
  }
  @override
  void initState() {
    super.initState();
    // myBanner.load();
    FirebaseFirestore.instance.collection("Objects").get().then((value){
      value.docs.forEach((d){
        all_objcts.add(
            {
              "id": d['id'],
              "image": d['image'],
              "HostKind": d['type'],
              "amenwifi": d["amenWIFI"],
              "amensmokealarm": d["amensmoke"],
              "amenbedroom": d["amenbedroom"],
              "amenheating": d["amenheating"],
              "amenarecondition": d["amenAirCondition"],
              "amenTV": d["amenTV"],
              "amenParking": d["amenparking"],
              "amenSecurityCamira": d["amensecureCamera"],
              "amenGarden": d["amengarden"],
              "amenPool": d["amenpool"],
              "amenHomeSafty": d["amenHomesafty"],
              "amenPets": d["amenpets"],
              "roomCount": d["roomNO"],
              "cityID": d["city"],
              "stateID": d["state"],
              "hosttypeSR": d["hosr_sale_rent"],
              "bedroomNO": d["bedroomNO"],
              "Balcon": d["balcony"],
              "bathroomNo": d["bathroomNO"],
              "ADID": d["ADID"],
              "ADowner": d["ADowner"],
              "name": d["objname"],
              "objState": d["objState"],
              "awaiting_approval": d["awaiting_approval"],
              "price": d["price"],
              "rent_time_for": d["rent_time_for"]
            }
        );

      });
    });
    FirebaseFirestore.instance.collection("Users").get().then((value){
      value.docs.forEach((d){
        all_users.add(
            {
              "username": d['name_f']+" "+d['name_l'],
              "userID":d['id']
            }
        );

      });
    });


  }
  double sumRate = 0.0;
  var reviews = List<Review>();
  final reviewcontroller = Get.put(reviewController());
  List<dynamic> Listrate = [];
  var allrate = [];
  Widget _widgetRate(id) {
//      return _buildRatingStars( sumRate.toDouble(),Listrate.length.toDouble());
    //Listrate.clear();
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
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
            size: 17.5,
          ),
          splashRadius: 22.5,
          highlightColor: Theme.of(context).primaryColor,
          onPressed: () {setState(() {
            Navigator.pop(context);
          });},
        ),
        title: Text(
          AppLocalizations.of(context).filter_results,
          style: TextStyle(color: Colors.black,
              fontFamily: 'poppins',
              fontSize: 17.5),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: _calculation(),
          builder:(context , f){
            return (f.hasData)?
            WillPopScope(
              // ignore: missing_return
              onWillPop: (){
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: (all_obj.isNotEmpty)?SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: size.height,
                      width: size.width,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: size.height*0.075),
                        child: ListView.builder(
                            padding: EdgeInsets.only(bottom: size.height*0.05,left: 25,right: 25,),
                            itemCount: all_obj.length,
                            itemBuilder: (context , obj){
                              _widgetRate(all_obj[obj]["id"]);
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ObjectDescription(id: all_obj[obj]['id'],objOwner: all_obj[obj]['ADID'],
                                    user: widget.user,)));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top:20),
                                  height: size.height*0.4,width: size.width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12.0),
                                              image: DecorationImage(
                                                  image: NetworkImage(all_obj[obj]['image']),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height*0.01,),
//                                  Row(
//                                    children: [
//                                      Icon(Icons.star , color: Theme.of(context).primaryColor,size: 15,),
//                                      Text("4.5",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'poppins'),),
//                                    ],
//                                  ),
                                      (reviews.length != 0)?
                                      _buildRatingStars(sumRate, double.parse("${reviews.length}")):
                                      Container(height: 0,),
                                      SizedBox(height: size.height*0.01,),
                                      Text("${all_obj[obj]["HostKind"]} . ${all_obj[obj]['cityID']}",style: TextStyle(fontFamily: 'poppins',fontSize: 20,fontWeight: FontWeight.w600),),
                                      SizedBox(height: size.height*0.005,),
                                      Text("${all_obj[obj]['name']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,fontFamily: 'poppins'),),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    // SizedBox(height: size.height*0.2,)
                  ],
                ),
              ):Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Image.asset("assets/images/error.png",height: 50,width: 50,),
                    SizedBox(height: 10,),
                    Center(child: Text(AppLocalizations.of(context).no_result,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'poppins',),)),
                  ],
                ),
              ),
            ):
            Center(
                child: SpinKitChasingDots(
                  color: Theme.of(context).primaryColor,
                  size: size.height*0.05,
                ));
          }

      ),
    );
  }
}

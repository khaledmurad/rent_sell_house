import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../des/obj_description.dart';
import '../../models/view.dart';
import '../description/categore_objects.dart';
import '../description/city_objects.dart';

class Discover extends StatefulWidget {
  User user;
  Discover({Key key,this.user}) : super(key: key);
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height:size.height,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: [
          SizedBox(height: size.height*0.02,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            child: Text("Categories",
              style: TextStyle(
                fontSize: size.width * 0.055,
                fontFamily: 'poppinsbold',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: size.height*0.03,),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("objKind")
                        .orderBy("name",descending:false)
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
          SizedBox(height: size.height*0.02,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Real estate",style: TextStyle(
                    fontSize : size.width*0.05,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CityContentPage(
                      user: widget.user,)));
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
          SizedBox(height: size.height*0.015,),
        ],
      ),
    );
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

  @override
  void initState(){
    super.initState();
    prepareW();
  }
  _WedgetObjects(){
    Size size = MediaQuery.of(context).size;
    return AnimatedSwitcher(
        duration: Duration(microseconds: 500),
        //height: size.height*0.3,
        child:
        isLoading ? Text("Loading") : Gallery.length > 0 ?
        SingleChildScrollView(
          child: Container(
              height: size.height*.35,
              width: size.width,
              margin: EdgeInsets.only(left: 5,right: 5),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:(Gallery.length >3)? 4:Gallery.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ObjectDescription(
                                    id: Gallery[index].id,
                                    objOwner:
                                    Gallery[index].ADID,
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
                                        Gallery[index].image),
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
                            (Gallery[index].objname.length>=25)?
                            Text(
                              "${Gallery[index].objname.substring(0,25)} ...",
                              style: TextStyle(
                                  fontSize: size.width * .04,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins'),
                            ):
                            Text(
                              "${Gallery[index].objname}",
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
                                    "${Gallery[index].city}",
                                    style: TextStyle(
                                        fontFamily: 'poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Text(
                                "\$${Gallery[index].price}",
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

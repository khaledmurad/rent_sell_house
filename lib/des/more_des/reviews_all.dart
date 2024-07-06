import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:home_mate_app/controllers/reviews_controller.dart';
import 'package:home_mate_app/models/reviews.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AllReviews extends StatefulWidget {
  final Oid;
  AllReviews({this.Oid});
  @override
  _AllReviewsState createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  List<Review> reviews;
  final reviewcontroller = Get.put(reviewController());
  FToast fToast;
  String reviewM,reviewY;
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

  @override
  void initState() {
    super.initState();
    fToast =FToast();
    fToast.init(context);
//    reviews = reviewcontroller.review.where((r) => (r.hostID == widget.Oid)).toList();
    print(reviews);
  }

  Future _calculation() async {
    await new Future<Widget>.delayed(const Duration(seconds: 2));
    reviews = reviewcontroller.review.where((r) => (r.hostID == widget.Oid)).toList();
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: FutureBuilder(
        future:_calculation() ,
        builder: (context,f){
          return(f.hasData)?
          SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.only(
                  left: size.width * 0.07,
                  right: size.width * 0.07
              ),
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
                    AppLocalizations.of(context).all_Reviews,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppinsbold'),
                  ),
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children:<Widget> [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: reviews.length,
                            itemBuilder: (context,index){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _line(context),
                                  Row(
                                    children: [
                                      Icon(Icons.star , color: Colors.amber,size: 20,),
                                      Text("${reviews[index].rate}",style: TextStyle(fontFamily: 'poppinslight',fontSize: 15,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  SizedBox(height: size.height*0.02,),
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection("Users").where("id",isEqualTo: reviews[index].reviewer).snapshots(),
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
                                                      Text('${reviews[index].month} ${reviews[index].year}',style: TextStyle(
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
                                  GestureDetector(
                                    onLongPress: (){
                                      Clipboard.setData(new ClipboardData(text: "${reviews[index].msg}"));
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
                                      )                                        ;
                                    },
                                    child: Text("${reviews[index].msg}",
                                      style: TextStyle(fontWeight: FontWeight.w500,
                                          color: Colors.black,fontSize: 15,fontFamily: 'poppins'),),
                                  ),
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height*0.02,)
                ],
              ),
            ),
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
}

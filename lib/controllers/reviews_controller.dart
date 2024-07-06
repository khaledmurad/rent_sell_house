import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/reviews.dart';

class reviewController extends GetxController{
  var review = List<Review>().obs;

  @override
  void onInit() {
    super.onInit();
    getObjects();
    print("3333333333 ${review.length}");
  }

  void getObjects() async{
    await Future.delayed(Duration(seconds: 1));
    List<Review> allreview=[];
    FirebaseFirestore.instance.collection("review").get().then((value) {
      value.docs.forEach((e) {
        allreview.add(Review(
          id: e["id"],
          hostID: e['hostID'],
          month:  e['month'],
          msg:  e['msg'],
          rate:  e['rate'],
          reviewer:  e['reviewer'],
          year:  e['year'],
        ));
        print("444444444444 ${allreview.length}");
      });
    });
    review.value = allreview;
    print("5555555555555 ${allreview.length}");

  }
}



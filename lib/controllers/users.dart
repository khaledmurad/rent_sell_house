import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_mate_app/models/users.dart';

class usersController extends GetxController{
  var users = List<Users>().obs;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  void getUsers() async{
    await Future.delayed(Duration(seconds: 1));
    List<Users> allUser=[];
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      value.docs.forEach((e) {
        allUser.add(Users(
          id: e["id"],
          city: e['city'],
          signup: e['sginupdate'],
          login: e['lastlogin'],
          userInfo: e['user_info'],
          phone: e['phone'],
          Lname: e['name_l'],
          Fname: e['name_f'],
          image: e['image'],
          email: e['email'],
        ));
      });
    });
    users.value = allUser;
  }
}



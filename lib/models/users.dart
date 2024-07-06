import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  String id ,city,Fname,Lname,phone,userInfo,image,email;
  Timestamp signup ,login;



  Users({
    this.id,this.city,this.signup,this.login,this.Fname,this.Lname,this.users,
    this.phone,this.userInfo,this.image,this.email
  });

  var users = List<Users>();

  getObjects() async {
    await Future.delayed(Duration(seconds: 1));
    List<Users> allUsers=[];
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      value.docs.forEach((e) {
        allUsers.add(Users(
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
    return users = allUsers;

  }
}
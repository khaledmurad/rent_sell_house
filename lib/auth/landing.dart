import 'package:flutter/material.dart';
import 'package:home_mate_app/auth/login.dart';
import 'package:home_mate_app/des/obj_description.dart';
import 'package:home_mate_app/screens/add_new/add_new.dart';
import 'package:home_mate_app/screens/home.dart';
import 'package:home_mate_app/screens/profile/profile.dart';
import 'anonumus.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'database.dart';



class Landing extends StatefulWidget {
  Landing({Key key,this.user}) : super(key: key);
  User user;
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            widget.user = snapshot.data;
            ObjectDescription(user: widget.user,);
              return //HomePage()
                Provider<DataBase>(
                    create: (_) => FireStoreDataBase(uid:widget.user.uid),
                    child:HomePage(user: widget.user,));

            // if (widget.user == null || widget.user.isAnonymous) {
            //   return HomePage();
            // } else {
            //   ObjectDescription(user: widget.user,);
            //   return //HomePage()
            //     Provider<DataBase>(
            //         create: (_) => FireStoreDataBase(uid:widget.user.uid),
            //         child:HomePage(user: widget.user,));
            //
            // }
          }

          return Center(
            child: CircularProgressIndicator( backgroundColor: Theme.of(context).primaryColor,),
          );
        });  }
}

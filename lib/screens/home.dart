import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_mate_app/auth/AP.dart';
import 'package:home_mate_app/auth/landing.dart';
import 'package:home_mate_app/filter/filter.dart';
import 'package:home_mate_app/screens/add_new/add_new.dart';
import 'package:home_mate_app/screens/categories/discover.dart';
import 'package:home_mate_app/screens/dashboard/dashboard.dart';
import 'package:home_mate_app/screens/inbox/inbox.dart';
import 'package:home_mate_app/screens/profile/pages/offers/your_offers.dart';
import 'package:home_mate_app/screens/profile/pages/saved.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:home_mate_app/screens/profile/profile.dart';

import 'inbox/pages/msgScreen.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({this.user});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    print("${widget.user.uid} here is the user id");
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        // navigatorKey.currentState.pushNamed('/filter');
        print(message.data);
        switch(message.data['screen']){
          case 'reserv' :  Navigator.push(context,
              MaterialPageRoute(builder: (context)=>OwnOffers(user: widget.user,)));
          break;
          case 'chat' :  Navigator.push(context,
              MaterialPageRoute(builder: (context)=>MessageScreen(user: widget.user,
              chatID:message.data['chatID'] ,hostID: message.data['reserverID'],)));
          break;
        }
        //navigatorKey.currentState.pushNamed(message.data['screen']);
      }
    });
    FirebaseMessaging.onBackgroundMessage((message) => null);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      print(message.data);
      switch(message.data['screen']){
        case 'reserv' :  Navigator.push(context,
            MaterialPageRoute(builder: (context)=>OwnOffers(user: widget.user,)));
        break;
        case 'chat' :  Navigator.push(context,
            MaterialPageRoute(builder: (context)=>MessageScreen(user: widget.user,
              chatID:message.data['chatID'] ,hostID: message.data['reserverID'],)));
        break;
      }
      //navigatorKey.currentState.pushNamed(message.data['screen']);
      // navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>OwnOffers()));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  List<IconData> iconItems = [
    Ionicons.ios_home,
    FontAwesomeIcons.bars,
    FontAwesome.inbox,
    Ionicons.ios_person,
  ];

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * .03),
      child: Scaffold(
        body:IndexedStack(
          index: pageIndex,
          children: [
            DashboardPage(user: widget.user,),
            Discover(user: widget.user),
            InboxPage(user: widget.user),
            ProfilePage(user: widget.user),
            AddNewPage(user: widget.user)
          ],
        ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: Colors.white,
            activeColor: Theme.of(context).primaryColor,
            splashColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.black.withOpacity(0.5),
            icons: iconItems,
            activeIndex: pageIndex,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            //leftCornerRadius: 20,
            iconSize: 25,
            //rightCornerRadius: 20,
            onTap: (index) {
              selectedTab(index);
            },
            //other params
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                selectedTab(4);
              },
              child: Icon(
                Icons.add,
                size: 25,
              ),
              backgroundColor: Theme.of(context).primaryColor,
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
        //backgroundColor: Theme.of(context).primaryColor,

      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_mate_app/auth/AP.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'auth/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeLanguage(newLocale);
  }
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  changeLanguage(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  _getNotiState() async {
    await new Future<Widget>.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool Notistatus = prefs.getBool("noti_state");

    if (Notistatus == null) {
      prefs.setBool("noti_state", true);
    }

  }
  startTime() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {



    } else {

      prefs.setBool('first_time', false);
      Auth().signInAnonymously();
    }
  }
  getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var mainLang = prefs.get("mainLang");
    print("mainLang -> $mainLang");
    setState(() {
      _locale = Locale('$mainLang');
    });
  }
  @override
  void initState(){
    super.initState();
    startTime();
    getLanguage();
    _getNotiState();
  }
  final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'EN'),
          Locale('tr', 'TR'),
          Locale('ar', 'AR'),
        ],
        locale: _locale,
        navigatorKey: navigatorKey,
        title: 'HomeMate',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(6, 72, 168, 1),
          hoverColor: Color.fromRGBO(6, 72, 168, 5),
//          primaryColor: Color(0xFFFF3378),
          scaffoldBackgroundColor:Colors.white,
          highlightColor: Color(0xFFfdd278),
          //Color.fromRGBO(229, 229, 229, 1),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.playfairDisplayTextTheme(),
        ),
        home: SplashScreen(
          imageBackground: img.image,
          seconds: 2,
          navigateAfterSeconds: AorP()//Landing()
          ,
         // image: new Image.asset('assets/images/splashscreen.png'),
          photoSize: 100,
          useLoader: false,
        ),
      ),
    );
  }
  Image img = Image.asset('assets/images/splashscreen.jpg');
}


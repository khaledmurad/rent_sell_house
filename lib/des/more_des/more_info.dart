import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreInformation extends StatelessWidget {
  final Oid;
  FToast fToast= FToast();
  MoreInformation({this.Oid});
  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Objects").doc(Oid).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.08,
                    left: size.width * 0.07,
                    right: size.width * 0.07),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Text(
                        AppLocalizations.of(context).more_information,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinsbold'),
                      ),
                      SizedBox(
                        height: size.height * 0.035,
                      ),
                      GestureDetector(
                        onLongPress: (){
                          Clipboard.setData(new ClipboardData(text: snapshot.data['information']));
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
                          )
                          ;
                        },
                        child: Text(snapshot.data['information'],style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinslight')),
                      )
                        ],
                      ),
                )
                ),
            );
          }else{return Container();}
        }
    );
  }
}

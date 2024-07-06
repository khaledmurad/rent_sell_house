import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class BookingPage extends StatefulWidget {
  final Oid;
  final hostid;
  User user;
  BookingPage({this.hostid,this.Oid,this.user});
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<DateTime> _blackoutDateCollection = List<DateTime>();
  Future<SharedPreferences> prefs;
  String page = "main";
  List<DateTime> _blackoutDates;
  int guests = 1;
  int maxGuests;
  String priceDayly , priceType , serviceFee,phoneNO,mesj ="",GruopChatID;
  String changerphone,maxGest;
  String image , name ;
  FToast fToast;
  Timestamp joinedDate;
  int phoneEmpty = 0;
  DateTime date,dateFrom,dateTo;
  @override
  void initState() {
    super.initState();
    prefs = SharedPreferences.getInstance();
    _blackoutDates = <DateTime>[];
    fToast = FToast();
    fToast.init(context);
   setState(() {
     FirebaseFirestore.instance.collection("Objects").where("id",isEqualTo:widget.Oid).snapshots().listen((v) {
       v.docs.forEach((element) {
         maxGuests = int.parse(element['maxNO_person']);
         priceDayly = element['kira_day'];
         priceType = element['money_type'];
         serviceFee = element['service_fee'];
         phoneNO = element['phoneNO'];
       });
     });
     FirebaseFirestore.instance.collection("Users").where("id",isEqualTo:widget.hostid).snapshots().listen((v) {
       v.docs.forEach((element) {
         phoneNO = element['phone'];
         image = element['image'];
         name = element['name_f'];
         joinedDate = element['sginupdate'];
       });
     });
   });
    FirebaseFirestore.instance
        .collection("Reservation")
        .where("objID", isEqualTo: widget.Oid)
        .where("reservationState", isNotEqualTo: "Refused")
        .snapshots()
        .listen((v) {
      v.docs.forEach((element) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            date =
                element["reserv_date_from"].toDate();
            dateTo =
                element["reserv_date_to"].toDate();

            for (date;
            date.isBefore(DateTime(dateTo.year,dateTo.month,dateTo.day)) ||
                date ==
                    DateTime(dateTo.year,dateTo.month,dateTo.day);
            date = date.add(Duration(days: 1))) {
              if (date.isAfter(DateTime(ST.year, ST.month, ST.day - 1))) {
                _blackoutDateCollection.add(date);
              }
            }
          });
        });
        //  _blackoutDates.add(DateTime(element["year"], element["month"], element['day']));
      });
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _blackoutDates = _blackoutDateCollection;
      });
    });
    print(_blackoutDates.length);
    print(_blackoutDates);
    print(_blackoutDateCollection.length);
  }

  PickerDateRange ss;
  DateTime ST = DateTime.now(), ET;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      ss = args.value;
      ST = ss.startDate;
      d = ss.startDate;
      ET = ss.endDate;
    });
  }

  _line(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height:  size.height*0.0005,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black54,
          ),
        ),
        SizedBox(
          height:  size.height*0.03,
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
   // maxGuests = int.parse(maxGest);
    return (page=="main")?_MainPage():_Addphone();
  }


  _MainPage(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: prefs,
          builder: (context ,AsyncSnapshot<SharedPreferences> snap){
            if(!snap.hasData){
              return CircularProgressIndicator();
            }else{
              return Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.07,
                    right: size.width * 0.07),
                child: SingleChildScrollView(
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
                            child: Icon(FontAwesomeIcons.arrowLeft,size: 17.5,
                              color: Colors.black,),)
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Text(
                        "Booking details",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'poppinsbold'),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SfDateRangePicker(
                        monthViewSettings: DateRangePickerMonthViewSettings(
                            blackoutDates: _blackoutDates),
                        onSelectionChanged: _onSelectionChanged,
                        monthCellStyle: DateRangePickerMonthCellStyle(
                          todayTextStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                          blackoutDateTextStyle: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough),
                        ),
                        rangeSelectionColor: Theme.of(context).primaryColor,
                        startRangeSelectionColor:
                        Theme.of(context).primaryColor,
                        endRangeSelectionColor: Theme.of(context).primaryColor,
                        todayHighlightColor: Theme.of(context).primaryColor,
                        minDate: _widgetMinDate(),
                        maxDate: _widgetMaxDate(),
                        selectionMode: DateRangePickerSelectionMode.range,
                        headerStyle: DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _line(context),
                      Text(
                        'Your trip',
                        style: TextStyle(fontFamily: 'poppinsbold',
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            (ET == null)?"${_MonthsName(ST.month)} ${ST.day}" :
                            "${_MonthsName(ST.month)} ${ST.day} - ${_MonthsName(ET.month)} ${ET.day}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Guests',
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    if(maxGuests > guests) {
                                      guests = guests + 1;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline,color:(maxGuests > guests)? Theme.of(context).primaryColor:Colors.grey,size: 25,),
                                ),
                              ) ,
                              SizedBox(width: size.width*0.05,),
                              Text(
                                "$guests",
                                style: TextStyle(
                                    fontSize:17.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'poppinslight'),
                              ),
                              SizedBox(width: size.width*0.05,),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    if(guests >1){
                                      guests = guests -1;
                                    }
                                  });
                                },
                                child: Container(
                                  child: Icon(Icons.remove_circle_outline,color:(guests >1)? Theme.of(context).primaryColor:Colors.grey,size: 25,),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      _line(context),
                      Text(
                        'Price details',
                        style: TextStyle(fontFamily: 'poppinsbold',
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Per night',
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            '$priceDayly $priceType',
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service fee',
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            (serviceFee != "0" && serviceFee!="")?
                            (ET == null)?
                            '$serviceFee $priceType':
                            "${int.parse(serviceFee) *( ET.difference(ST).inDays)} $priceType":
                            '0 $priceType',
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(fontFamily: 'poppinsbold',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            (serviceFee != "0" && serviceFee!="")?
                            (ET == null)?
                            "${int.parse(serviceFee)+int.parse(priceDayly)} $priceType":
                            "${(int.parse(priceDayly)*( ET.difference(ST).inDays))+int.parse(serviceFee)} $priceType":
                            (ET == null)?
                            "${int.parse(priceDayly)} $priceType":
                            "${(int.parse(priceDayly))*( ET.difference(ST).inDays)} $priceType"
                            ,
                            style: TextStyle(fontFamily: 'poppinslight',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      _line(context),
                      Text(
                        'Pay with',
                        style: TextStyle(fontFamily: 'poppins',
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      //TODO
                      SizedBox(height: size.height*0.025,),
                      _line(context),
                      //////////////////////////////////////////////////////phoneNO
                      Text(
                        'Phone number',
                        style: TextStyle(fontFamily: 'poppinsbold',
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (phoneNO !="")?
                            '(+90) $phoneNO':
                            "Add new phone number",
                            style: TextStyle(fontFamily: 'poppinsbold',
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                page = "addphone";
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.005),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.5),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                (phoneNO !="")?
                                "Change":
                                'Add',
                                style: TextStyle(fontFamily: 'poppinsbold',color: Colors.white,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      (phoneEmpty ==1)?
                      Text(
                        "* Phone number is required.",
                        style: TextStyle(fontFamily: 'poppinslight',color: Colors.red,
                            fontWeight: FontWeight.bold, fontSize: 12.5),
                      ):Container(height: 0,width: 0,),
                      SizedBox(height: size.height*0.025,),
                      _line(context),
                      //////////////////////////////////////////Message the host
                      Text(
                        'Message the host',
                        style: TextStyle(fontFamily: 'poppinsbold',
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(height: size.height*0.025,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Message your host and let him know when you'll check in",
                              style: TextStyle(fontFamily: 'poppinslight',
                                  fontWeight: FontWeight.bold, fontSize: 12.5),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                                  ),
                                  builder: (BuildContext context) {
                                    return _showModalBottomSheetContainer();
                                  },
                                );
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: size.width*0.02,vertical: size.height*0.005),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.5),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                'Message',
                                style: TextStyle(fontFamily: 'poppinsbold',color: Colors.white,
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.025,),
                      _line(context),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.calendarCheck,
                            color: Theme.of(context).primaryColor,
                            size: 25,
                          ),
                          SizedBox(width: size.width*0.05,),
                          Flexible(
                            child: Text(
                              'Your reservation won\'t be confirmed until the host accepts your request (within 24 hours).',
                              style: TextStyle(fontFamily: 'poppinsbold',
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height*0.045,),
                      GestureDetector(
                        onTap: (){
//                          int totalPrice=
//                          (ET == null)?
//                          int.parse(serviceFee)+int.parse(priceDayly):
//                          (int.parse(serviceFee)+int.parse(priceDayly))*( ET.difference(ST).inDays);
//                          Random rnd = Random();
//                          var reservID = rnd.nextInt(500000000).toString();
//                          setState(() {
//                            if(phoneNO == ""){
//                              phoneEmpty = 1;
//                            }else{
//                              FirebaseFirestore.instance.collection("Reservation").doc(reservID).set({
//                                "id":reservID,
//                                "objID":widget.Oid,
//                                "hostID":widget.hostid,
//                                "clientID":widget.user.uid,
//                                "reserv_date_from":ST,
//                                "reserv_date_to":ET,
//                                "clientPhoneNO":phoneNO,
//                                "total_price":totalPrice,
//                                "priceType":priceType,
//                                "guestsNo":guests,
//                                "reservationState":"Waiting",
//                                "reserv_date":DateTime.now()
//                              });
//                            }
//                          });
                        print(_blackoutDates);
                        },
                        child: Container(
                          width: double.infinity,
                          height: size.height*0.065,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(169, 176, 185, 0.42),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Request to book",
                              style: TextStyle(
                                  fontSize:17.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppinsbold'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height*0.025,),

                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
  _Addphone(){
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          setState(() {
            page = "main";
          });
        },
        child: Padding(
          padding: EdgeInsets.only(
              top: size.height * 0.08,
              left: size.width * 0.07,
              right: size.width * 0.07),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    FontAwesomeIcons.arrowLeft,
                    size: 17.5,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  (phoneNO == "")?"Add phone number":"Change phone number",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'poppinsbold'),
                ),
                SizedBox(
                  height: size.height * 0.075,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  height: size.height*0.075,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: size.width*0.005,
                      color: Colors.black54,
                    )
                  ),
                  child: Center(
                    child: TextFormField(
                      onChanged: (v){
                        setState(() {
                          changerphone =v;
                        });
                      },
                      inputFormatters: [
                        MaskedTextInputFormatter(
                          mask: 'xxx xxx xx xx',
                          separator: ' ',
                        ),
                      ],
                      keyboardType: TextInputType.number,
                      initialValue: "$phoneNO",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins') ,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                          prefixStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins'),
                        prefix: Text("(+90)  ")
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        phoneNO = changerphone;
                        page = "main";
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: size.height*0.075,
                      width: size.width*0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: size.width*0.005,
                            color: Theme.of(context).primaryColor,
                          )
                      ),
                      child: Center(
                        child: Text(
                          (phoneNO == "")?"Add":"Change",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins'),
                        ),
                      ),
                    ),
                  ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          page = "main";
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: size.height*0.075,
                        width: size.width*0.4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: size.width*0.005,
                              color: Colors.black54,
                            )
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins'),
                          ),
                        ),
                      ),
                    )
                ],)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _MonthsName(int d){
    switch(d){
      case 1 :return "Jan";break;
      case 2 :return "Feb";break;
      case 3 :return "Mar";break;
      case 4 :return "Apr";break;
      case 5 :return "May";break;
      case 6 :return "Jun";break;
      case 7 :return "Jul";break;
      case 8 :return "Aug";break;
      case 9 :return "Sep";break;
      case 10 :return "Oct";break;
      case 11 :return "Nov";break;
      case 12 :return "Des";break;

    }
  }

  _showModalBottomSheetContainer(){
    Size size = MediaQuery.of(context).size;
    return StatefulBuilder(
        builder: (context ,StateSetter setState)
    {
      return Container(
        margin: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom),
        padding: EdgeInsets.only(top: size.height * 0.03),
        width: size.width,
        height: size.height * 0.55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      FontAwesomeIcons.times,
                      size: 15,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  Text(
                    "Message the host",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            SizedBox(
              height: size.height * 0.001,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Container(
                color: Colors.black54,
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.07,
                  right: size.width * 0.07),
              child: Text(
                "Message the host",
                style: TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'poppinsbold'),
              ),
            ),
            SizedBox(height: size.height * 0.015,),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.07,
                  right: size.width * 0.07),
              child: Flexible(
                child: Text(
                  "message your host and let him know when you'll check in",
                  style: TextStyle(fontFamily: 'poppinslight',
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.025,),
            Padding(
                padding: EdgeInsets.only(left: size.width * 0.07,
                    right: size.width * 0.07),
                child: Row(
                  children: [
                    Container(
                      //  height: size.height*0.07,width: size.width*0.2,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage:
                          (image == "" || image == null) ?
                          AssetImage(
                              'assets/images/5.jpg') :
                          NetworkImage(image)
                      ),
                    ),
                    SizedBox(width: size.width * 0.035,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$name', style: TextStyle(color: Colors.black,
                            fontSize: 17.5,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold),),
                        Text("Joined in ${_MonthsName(joinedDate
                            .toDate()
                            .month)} ${joinedDate
                            .toDate()
                            .year}", style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 12.5,
                            fontFamily: 'poppinslight'))
                      ],
                    )
                  ],
                )
            ),
            SizedBox(height: size.height * 0.02,),
            Padding(
                padding: EdgeInsets.only(left: size.width * 0.07,
                    right: size.width * 0.07),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 0.75,
                          color: Colors.black45
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, bottom: 1),
                    child: TextFormField(
                      initialValue: mesj,
                      onChanged: (v) {
                        setState(() {
                          mesj = v;
                        });
                      },
                      maxLines: 4,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'poppins',
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Hi $name ...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  ),
                )
            ),
            SizedBox(height: size.height * 0.02,),
            Padding(
                padding: EdgeInsets.only(left: size.width * 0.07,
                    right: size.width * 0.07),
                child: GestureDetector(
                  onTap: () {
                    if (widget.user.uid.hashCode <= widget.hostid.hashCode) {
                      GruopChatID = '${widget.user.uid}-${widget.hostid}';
                    } else {
                      GruopChatID = '${widget.hostid}-${widget.user.uid}';
                    }
                    if (mesj.length > 0) {
                      Random rnd = Random();
                      var rnd1 = rnd.nextInt(500000000).toString();
                      var msgNO = rnd.nextInt(500000000).toString();
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(GruopChatID)
                          .collection(GruopChatID)
                          .doc(rnd1)
                          .set({
                        "is_read": "0",
                        "id": "$rnd1",
                        "type": 0,
                        "send_ID": widget.user.uid,
                        'reserver_ID': widget.hostid,
                        'msg': mesj,
                        'msgTime': DateTime
                            .now()
                            .millisecondsSinceEpoch
                            .toString()
                      });
                      FirebaseFirestore.instance.collection('chats').
                      doc(GruopChatID).set({
                        "chat_id": GruopChatID,
                        "users": [widget.user.uid, widget.hostid
                        ],
                        'lastTime': DateTime
                            .now()
                            .millisecondsSinceEpoch
                            .toString()
                      });
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc(GruopChatID)
                          .get().then((value) {
                        value.reference.update(<String, dynamic>{
                          'lastTime': DateTime
                              .now()
                              .millisecondsSinceEpoch
                              .toString()
                        });
                      });
                      Navigator.pop(context);
                      fToast.showToast(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery
                              .of(context)
                              .size
                              .height * .025),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Theme
                                    .of(context)
                                    .highlightColor,
                              ),
                              child: Text("Message sent", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'poppins'),)),
                        ),
                        gravity: ToastGravity.TOP,

                        toastDuration: Duration(seconds: 2),
                      );
                    }
                  },
                  child: (mesj.length > 0) ? Container(
                    width: size.width,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        borderRadius: BorderRadius.circular(7.5),

                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Center(
                          child: Text("Send message", style: TextStyle(
                              fontFamily: 'poppins', color: Colors.white,
                              fontSize: 15, fontWeight: FontWeight.bold),)),
                    ),
                  ) : Container(
                    width: size.width,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(7.5),

                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Center(
                          child: Text("Send message", style: TextStyle(
                              fontFamily: 'poppins', color: Colors.white,
                              fontSize: 15, fontWeight: FontWeight.bold),)),
                    ),
                  ),
                )
            ),


          ],
        ),
      );
    });
  }

  DateTime d ;
  _widgetMaxDate(){
    if(_blackoutDates.isEmpty || d ==null){
      return null;
    }else if(d!=null&&ET==null ){
      for(int i=0;i<_blackoutDates.length;i++){
        if(d.isBefore(_blackoutDates[i])){
          return _blackoutDates[i];
        }
      }
    }else if(d!=null &&ET!=null){
        return  null;
    }
  }
  _widgetMinDate(){
    if(_blackoutDates.isEmpty || d==null){
      return DateTime.now();
    }else if(d!=null&&ET==null ){
      for(int i =0;i<_blackoutDates.length;i++){
        if(d.isAfter(_blackoutDates[i])){
          return  _blackoutDates[i];
        }else{return DateTime.now();}
      }
    }else if(d!=null &&ET!=null){
      return  DateTime.now();
    }
  }
}



class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
            '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }

}
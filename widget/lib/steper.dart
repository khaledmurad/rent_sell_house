import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 4;
  List T = [
    "Connect your Email 1","Connect your Email 2","Connect your Email 3","Connect your Email 4"
  ];
  StepNO(no,tit){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (int.parse(no)>=_counter)?Colors.white:Colors.lightGreen,
                  border:(int.parse(no)>=_counter)? Border.all(
                      color: Colors.black54,
                      width: 1
                  ):null,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Center(
                child: Text(no,
                  style: TextStyle(
                    color: (int.parse(no)>=_counter)?Colors.black:Colors.white,
                    fontWeight: FontWeight.bold,),),
              ),
            ),
            (int.parse(no)<4)?space():Container(height: 0,width: 0,)
          ],
        ),
        SizedBox(width: 10,),
        Flexible(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("$tit",style: TextStyle(fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width*0.0105),),
            ],
          ),
        )
      ],
    );
  }

  VD(){
   return Container(color: Colors.black45, height: 25, width: 2,);
  }

  space(){
    return Column(
      children: [
        SizedBox(height: 5,),
        VD(),
        SizedBox(height: 5,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(size.width*0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             padding: EdgeInsets.all(size.width*0.02),
             width: size.width*0.18,
             height: size.height*.5,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               color: Colors.white,
               boxShadow:[
                 BoxShadow(
                   color: Colors.grey,
                   spreadRadius: 2,
                   blurRadius: 3,
                   offset: Offset(0, 3), // changes position of shadow
                 ),
               ],
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                     Column(
                       // mainAxisAlignment: MainAxisAlignment.center,
                       // crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         StepNO("1",T[0]),
                         StepNO("2",T[1]),
                         StepNO("3",T[2]),
                         StepNO("4",T[3]),
                       ],
                     )

               ],
             ),
           ),
           SizedBox(width: size.width*0.05,),
           Container(
             width: size.width*0.67,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(T[_counter-1],style: TextStyle(fontSize: size.width*0.025),),
                     SizedBox(height: size.height*0.05,),
                     Text("sdvdssdbsds sdv sdvsdv sdvsdjvnsdijvnsdv sdvjnsdjvsdnv",
                       style: TextStyle(fontSize: size.width*0.015),),
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     (_counter>1)?
                     InkWell(
                       onTap: (){
                         setState(() {
                           if(_counter>1&&_counter<=4) {
                             _counter = _counter - 1;
                           }
                         });
                       },
                       child: Container(
                         height: size.height*0.06,
                         width: size.width*0.04,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.5),
                           border: Border.all(
                             color: Colors.redAccent,
                             width: 2
                           )
                         ),
                         child: Center(child: Text("Back",style: TextStyle(
                           fontSize: size.width*0.0125,fontWeight: FontWeight.bold,color: Colors.redAccent,
                         ),)),
                       ),
                     ):Container(height: 0,),
                     InkWell(
                       onTap: (){
                         setState(() {
                           if(_counter>=1&&_counter<4) {
                             _counter = _counter + 1;
                           }
                         });
                       },
                       child: Container(
                         height: size.height*0.06,
                         width: size.width*0.04,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(7.5),
                           border: Border.all(
                             color: Colors.blueAccent,
                             width: 2
                           )
                         ),
                         child: Center(child: Text((_counter==4)?"Done":"Next",style: TextStyle(
                           fontSize: size.width*0.0125,fontWeight: FontWeight.bold,color: Colors.blueAccent,
                         ),)),
                       ),
                     ),
                   ],
                 )
               ],
             ),
           ),
         ],
      ),
      )
    );
  }
}

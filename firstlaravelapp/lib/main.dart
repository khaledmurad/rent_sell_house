import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage('Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title) ;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    late int num1,num2;
    int sum=0;
     Divid(num1 , num2){
       setState(() {
         if(num1>0 && num2 >0){
           while(num1>=num2){
             num1-=num2;
             ++sum;
           }
         }else if(num1>0 && num2 <0){
           int prno;
           prno = num2;
           while(num1>=-num2){
             num2+=prno;
             --sum;
           }
         }
         else if(num1<0 && num2 <0){
           int prno;
           prno = num2;
           while(num1<=num2){
             num2+=prno;
             ++sum;
           }
         }else if(num1<0 && num2 >0){
           while(-num1>=num2){
             num1+=num2;
             --sum;
           }
         }
       });
       return sum;
    }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width*.45,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder()
                    ),

                    onChanged: (v){
                      setState(() {
                        sum=0;
                        num1 = int.parse(v);
                      });
                    },
                  ),
                ),
                Container(
                  width: size.width*.45,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    onChanged: (v){
                      setState(() {
                        sum=0;
                        num2 = int.parse(v);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 25,),
            InkWell(
              onTap: (){
                sum=0;
                Divid(num1, num2);
                print(sum);
              },
              child: Container(
                width: size.width*.75,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Center(
                  child: Text("Calculate"),
                ),
              ),
            ),
            SizedBox(height: 25,),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: .5,color: Colors.black
                )
              ),
              width: size.width*.75,
              child: Text("Sum = $sum"),
            ),
            SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
}

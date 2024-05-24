import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../theme/AppBar.dart';
import 'dashboardPage.dart';



class orientationPage extends StatefulWidget {
  const orientationPage({super.key});

  @override
  State<orientationPage> createState() => _orientationPageState();
}

class _orientationPageState extends State<orientationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ORIENTATION',
        backgroundColor: Color(0xff071390),
        icon: Icons.dashboard, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => dashboardPage()));

      },
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey,
                    width: 4.0,
                    style: BorderStyle.solid), //Border.all
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ), //BorderRadius.all
              ),
              //BoxDecoration
            ),

          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 50,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 2500,
              percent: 0.6,
              center: Text("60.0%"),
              progressColor: Colors.green,
            ),

          ),



        ],

      ),


    );
  }

}

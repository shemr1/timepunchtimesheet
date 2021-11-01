import 'package:flutter/material.dart';


class DayHighLight extends StatelessWidget {


  final Color color;
  final String day;

  const DayHighLight({Key key, this.day, this.color}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        circularContainer(Colors.transparent, "Mon"),
        circularContainer(Colors.transparent, "Tue"),
        circularContainer(Colors.transparent, "Wed"),
        circularContainer(Colors.transparent, "Thu"),
        circularContainer(Colors.transparent, "Fri"),
        circularContainer(Colors.transparent, "Sat"),
        circularContainer(Colors.transparent, "Sun")
      ],
    );
  }
}

circularContainer(Color color, String day){
 Container(
   height: 10,
     margin: EdgeInsets.all(1.0),
     decoration: BoxDecoration(
     color: color,
     shape: BoxShape.circle
 ),
   child: Text(day,
   style: TextStyle(color: Colors.white),),
 );

}
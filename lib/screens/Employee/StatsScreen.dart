import 'package:flutter/material.dart';



class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}




class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // body:StreamBuilder (
      //   stream: userTime.snapshots(),
      //   builder: (context,snapshot){
      //     return !snapshot.hasData
      //     ? Center(child: CircularProgressIndicator(backgroundColor: Colors.red,))
      //     : ListView.builder(
      //       itemCount: snapshot.data.docs.length,
      //     itemBuilder: (context,index){
      //       DocumentSnapshot data = snapshot.data.docs[index];
      //       return Card(
      //         child: ListTile(
      //                 title: Text(data["Start Time"]),
      //                 subtitle: Text(data ["Duration"]),
      //           ),
      //       );
      //
      //     }
      //     );
      //   },
      // )
    );
  }

}
// class Listy {
//   String title;
//   String subtitle;
//
//   Listy (this.title, this.subtitle){
//     ListTile(
//       title: Text(title),
//       subtitle: Text(subtitle),
//     );
//   }
// }

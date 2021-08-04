import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
class NewsScreen extends StatefulWidget {
  const NewsScreen({Key key}) : super(key: key);



  @override
  _NewsScreenState createState() => _NewsScreenState();
}
String x;
DateTime _today = DateTime.now();


class _NewsScreenState extends State<NewsScreen> {


  @override
  void initState() {

    abc(2);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {




    return Text(x);

  }

  String  abc(int y){

    FirebaseFirestore.instance
        .collection('${hDates(y)}')
        .doc('KL').collection('districts').doc('Malappuram')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      print(data['delta']['confirmed'].toString());

      if (documentSnapshot.exists) {
        print(data['delta']['confirmed'].toString());
        x=data['delta']['confirmed'].toString();

        return data['delta']['confirmed'].toString();
      } else {
        print(data['delta']['confirmed'].toString());

        return 0.toString();
      }
    });
  }
  String hDates(int x) {
    DateTime pvDate = _today.subtract(Duration(days: x));

    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(pvDate);
  }






}




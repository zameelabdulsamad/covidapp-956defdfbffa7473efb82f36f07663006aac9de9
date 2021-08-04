import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'homeScreen.dart';

class DistrictScreen extends StatefulWidget {
  final String district;
  final String state;
  const DistrictScreen({Key key, this.district, this.state}) : super(key: key);

  @override
  _DistrictScreenState createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> {
  final adDistrictStatus = NativeAdmobController();



  bool loadedDistrictStatus = false;

  StreamSubscription adDistrictStatusSubscription;


  @override
  void dispose() {
    adDistrictStatusSubscription.cancel();

    adDistrictStatus.dispose();

    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedDistrictStatus = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedDistrictStatus = true;
        });
        break;

      default:
        break;
    }
  }
  @override
  void initState() {


    adDistrictStatusSubscription =
        adDistrictStatus.stateChanged.listen(_onStateChanged);

    // TODO: implement initState
    super.initState();
  }


  String formatDate() {
    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(_selectedDay);
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();





  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgGrey,
        elevation: 0,
        title: Text(widget.district),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgGrey,
              ),
              child: Wrap(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 01, 30),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  )
                ],
              ),
            ),
            DataCard(
              district: widget.district,
              date: formatDate(),
              cardColor: cardYellow,
              graphColor: Color(0xFFC7971D),
              state: widget.state,
              cardHeading: "CONFIRMED CASES",
              item: "confirmed",
              currentDate: _selectedDay,
            ),
            DataCard(
              district: widget.district,
              date: formatDate(),
              cardColor: cardGreen,
              graphColor: Color(0xFF27905D),
              state: widget.state,

              cardHeading: "RECOVERED CASES",
              item: "recovered",
              currentDate: _selectedDay,
            ),
            DataCard(
              district: widget.district,
              date: formatDate(),
              graphColor: Color(0xFFA22C29),
              state: widget.state,

              cardColor: primaryRed,
              cardHeading: "DECEASED",
              item: "deceased",
              currentDate: _selectedDay,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: !loadedDistrictStatus?0:maxHeight * 0.5,
                decoration: BoxDecoration(
                  color: primaryRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NativeAdmob(
                    adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                    controller: adDistrictStatus,
                    type: NativeAdmobType.full,
                    loading: Container(),
                    error: Text("error"),
                    options: NativeAdmobOptions(
                        showMediaContent: true,
                        ratingColor: bgGrey,
                        callToActionStyle: NativeTextStyle(
                            backgroundColor: bgGrey, color: primaryText),
                        bodyTextStyle:
                        NativeTextStyle(color: Colors.white),
                        advertiserTextStyle:
                        NativeTextStyle(color: Colors.white),
                        headlineTextStyle:
                        NativeTextStyle(color: Colors.white),
                        priceTextStyle:
                        NativeTextStyle(color: Colors.white),
                        storeTextStyle:
                        NativeTextStyle(color: Colors.white)),




                  ),
                ),

              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final Color cardColor;
  final Color graphColor;

  final String item;
  final String cardHeading;
  final String district;
  final String state;
  final String date;
  final DateTime currentDate;

  const DataCard(
      {Key key,
      this.cardColor,
      this.cardHeading,
      this.district,
      this.date,
      this.item,
      this.currentDate,
      this.graphColor,
      this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
        child:FutureBuilder(
            future: dCard(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Container(
                  height: maxHeight*0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            cardHeading,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              NumberFormat.decimalPattern().format(int.parse(snapshot.data["delta"]))

                              ,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: maxHeight*0.1,
                            child: LineChart(LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                      barWidth: 6,
                                      colors: [graphColor],
                                      spots: snapshot.data["graph"],
                                      isCurved: false,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(show: false))
                                ]))
                            ,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 8),
                            child: Text(
                              "Total till Date",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child:Text( NumberFormat.decimalPattern().format(int.parse(snapshot.data["total"]))

                                  ,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ))
                              ,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

              )



              ;
              }
              if(snapshot.hasError){
                return Shimmer.fromColors(
                  baseColor: shimmerbasecolor,
                  highlightColor: shimmerhighlightcolor,
                  child: Container(
                    height: maxHeight * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }
              return Shimmer.fromColors(
                baseColor: shimmerbasecolor,
                highlightColor: shimmerhighlightcolor,
                child: Container(
                  height: maxHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }
        )

      ));
  }

  String previousDates(int x) {
    DateTime pvDate = currentDate.subtract(Duration(days: x));

    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(pvDate);
  }

  Future<double> graphgetValues(int y) async {
    double _returnValue = 0;
    await FirebaseFirestore.instance
        .doc('${previousDates(y)}/$state/districts/$district')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = data == null || data['delta'] == null || data['delta']['$item'] == null
            ? 0
            : double.parse(data['delta']['$item'].toString());
      }
      else{
        _returnValue =0;
      }
    });
    return _returnValue;
  }

  Future<List<FlSpot>> getGraph() async{
    return [
      FlSpot(0, await graphgetValues(6)),
      FlSpot(1, await graphgetValues(5)),
      FlSpot(2, await graphgetValues(4)),
      FlSpot(3, await graphgetValues(3)),
      FlSpot(4, await graphgetValues(2)),
      FlSpot(5, await graphgetValues(1)),
      FlSpot(6, await graphgetValues(0)),
    ];
  }

  Future<String> itemNumber(String deltaortotal) async{
    String _returnValue="0";
    await FirebaseFirestore.instance
        .doc('$date/$state/districts/$district')
        .get().then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue=(data == null ||data['$deltaortotal'] == null||data['$deltaortotal']['$item'] == null)?0.toString():_returnValue=data['$deltaortotal']['$item'].toString();


      }
      else{

        _returnValue=0.toString();
      }
    });
    return _returnValue;
  }

  Future<Map> dCard() async{
    Map abc={"delta":await itemNumber("delta"),
      "total":await itemNumber("total"),
    "graph":await getGraph()};
    return abc;
  }


}

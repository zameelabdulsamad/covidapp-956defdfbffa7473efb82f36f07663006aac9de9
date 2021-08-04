import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/main.dart';
import 'package:covidapp/screens/indiaScreen.dart';
import 'package:covidapp/screens/stateScreen.dart';
import 'package:covidapp/screens/vaccinationScreen.dart';
import 'package:covidapp/screens/worldWideScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';
import 'districtScreen.dart';
import 'homeScreen.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key key}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String district = userDistrict;
  String stateName = userState;
  String stateCode = userStateCode;
  DateTime today = DateTime.now();

  final adStatus1 = NativeAdmobController();
  final adStatus2 = NativeAdmobController();

  bool loadedStatus1=false;
  bool loadedStatus2=false;






  StreamSubscription adStatus1Subscription,adStatus2Subscription;

  @override
  void initState() {


    adStatus1Subscription = adStatus1.stateChanged.listen(_onStateChanged1);
    adStatus2Subscription = adStatus2.stateChanged.listen(_onStateChanged2);


    // TODO: implement initState
    super.initState();


  }

  @override
  void dispose() {
    adStatus1Subscription.cancel();
    adStatus2Subscription.cancel();

    adStatus1.dispose();
    adStatus2.dispose();

    super.dispose();
  }

  void _onStateChanged1(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedStatus1=false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedStatus1 = true;
        });
        break;

      default:
        break;
    }
  }
  void _onStateChanged2(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedStatus2=false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedStatus2 = true;
        });
        break;

      default:
        break;
    }
  }

  String formatDate() {
    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(today);
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgGrey,
        elevation: 0,
        title: Text("Status"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: maxHeight * 0.35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: FutureBuilder(
                          future: getBarGroups(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DistrictScreen(
                                                district: district,
                                                state: stateCode,
                                              )));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: bgGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16.0,
                                              left: 10,
                                              bottom: 20,
                                              right: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    district,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: primaryText),
                                                  ),
                                                ],
                                              ),
                                              Icon(Icons.arrow_right)
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(24.0),
                                          child: DistrictWeekChart(
                                            graph: snapshot.data,
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            }
                            if (snapshot.hasError) {
                              return Shimmer.fromColors(
                                baseColor: shimmerbasecolor,
                                highlightColor: shimmerhighlightcolor,
                                child: Container(
                                  height: maxHeight * 0.35,
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
                                height: maxHeight * 0.35,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryRed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.article,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      Text(
                                        "News",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VaccinationScreen()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryRed,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.medical_services_rounded,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        Text(
                                          "Vaccination",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: getGraphData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StateScreen(
                                        stateName: stateName,
                                        stateCode: stateCode,
                                      )));
                        },
                        child: Container(
                            height: maxHeight * 0.35,
                            decoration: BoxDecoration(
                              color: bgGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0,
                                      left: 10,
                                      bottom: 20,
                                      right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            stateName,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: primaryText),
                                          ),
                                        ],
                                      ),
                                      Icon(Icons.arrow_right)
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AspectRatio(
                                        aspectRatio: 2,
                                        child: StateChart(
                                          graph: snapshot.data,
                                        )),
                                  ),
                                ),
                              ],
                            )),
                      );
                    }
                    if (snapshot.hasError) {
                      return Shimmer.fromColors(
                        baseColor: shimmerbasecolor,
                        highlightColor: shimmerhighlightcolor,
                        child: Container(
                          height: maxHeight * 0.35,
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
                        height: maxHeight * 0.35,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              Container(
                height: !loadedStatus1?0:maxHeight * 0.2,
                decoration: BoxDecoration(
                  color: bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NativeAdmob(
                    adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                    controller: adStatus1,
                    type: NativeAdmobType.full,
                    loading: Container(),
                    error: Text("error"),


                    options: NativeAdmobOptions(showMediaContent: false,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed) ),


                  ),
                ),

              )
              ,

              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: FutureBuilder(
                    future: rowValue(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IndiaScreen()));
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: bgGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0,
                                      left: 10,
                                      bottom: 20,
                                      right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "India",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: primaryText),
                                          ),
                                        ],
                                      ),
                                      Icon(Icons.arrow_right)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 26, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RowItem(
                                        txColor: cardYellow,
                                        txHeading: "CONFIRMED",
                                        totalNumber:
                                            snapshot.data["totalconfirmed"],
                                        deltaNumber:
                                            snapshot.data["deltaconfirmed"],
                                      ),
                                      RowItem(
                                        txColor: cardGreen,
                                        txHeading: "RECOVERED",
                                        totalNumber:
                                            snapshot.data["totalrecovered"],
                                        deltaNumber:
                                            snapshot.data["deltarecovered"],
                                      ),
                                      RowItem(
                                        txColor: primaryRed,
                                        txHeading: "DECEASED",
                                        totalNumber:
                                            snapshot.data["totaldeceased"],
                                        deltaNumber:
                                            snapshot.data["deltadeceased"],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Shimmer.fromColors(
                          baseColor: shimmerbasecolor,
                          highlightColor: shimmerhighlightcolor,
                          child: Container(
                            height: maxHeight * 0.15,
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
                          height: maxHeight * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(height: 10),
              Container(
                height: !loadedStatus2?0:maxHeight * 0.5,
                decoration: BoxDecoration(
                  color: bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NativeAdmob(
                    adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                    controller: adStatus2,
                    type: NativeAdmobType.full,
                    loading: Container(),
                    error: Text("error"),


                    options: NativeAdmobOptions(showMediaContent: true,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed)),


                  ),
                ),

              )
              ,

              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: !download
                    ? Container(
                        child: Shimmer.fromColors(
                          baseColor: shimmerbasecolor,
                          highlightColor: shimmerhighlightcolor,
                          child: Container(
                            height: maxHeight * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WorldwideScreen()));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: bgGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 10, bottom: 20, right: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Worldwide",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: primaryText),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.arrow_right)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 26, left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                            NumberFormat.decimalPattern()
                                                .format(int.parse(
                                                    WMapResponse[0]
                                                            ["todayCases"]
                                                        .toString())),
                                            style: TextStyle(
                                              color: primaryText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text("CONFIRMED",
                                            style: TextStyle(
                                              color: cardYellow,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Text(
                                            NumberFormat.decimalPattern()
                                                .format(int.parse(
                                                    WMapResponse[0]["cases"]
                                                        .toString())),
                                            style: TextStyle(
                                              color: primaryText,
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            NumberFormat.decimalPattern()
                                                .format(int.parse(
                                                    WMapResponse[0]["active"]
                                                        .toString())),
                                            style: TextStyle(
                                              color: primaryText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text("RECOVERED",
                                            style: TextStyle(
                                              color: cardGreen,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Text(
                                            NumberFormat.decimalPattern()
                                                .format(int.parse(
                                                    WMapResponse[0]["recovered"]
                                                        .toString())),
                                            style: TextStyle(
                                              color: primaryText,
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            NumberFormat.decimalPattern()
                                                .format(int.parse(
                                                    WMapResponse[0]
                                                            ["todayDeaths"]
                                                        .toString())),
                                            style: TextStyle(
                                              color: primaryText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text("DECEASED",
                                            style: TextStyle(
                                              color: primaryRed,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Text(
                                            NumberFormat.decimalPattern()
                                                .format(int.parse(
                                                    WMapResponse[0]["deaths"]
                                                        .toString())),
                                            style: TextStyle(
                                              color: primaryText,
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String previousDates(int x) {
    DateTime pvDate = today.subtract(Duration(days: x));

    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(pvDate);
  }

//districtcard

  Future<double> getData(int y) async {
    double _returnValue = 0;
    await FirebaseFirestore.instance
        .doc('${previousDates(y)}/$stateCode/districts/$district')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = data == null ||
                data['delta'] == null ||
                data['delta']['confirmed'] == null
            ? 0
            : double.parse(data['delta']['confirmed'].toString());
      } else {
        _returnValue = 0;
      }
    });
    return _returnValue;
  }

  Future<List<BarChartGroupData>> getBarGroups() async {
    List<double> barChartDatas = [
      await getData(6),
      await getData(5),
      await getData(4),
      await getData(3),
      await getData(2),
      await getData(1),
      await getData(0)
    ];
    List<BarChartGroupData> barChartGroups = [];
    barChartDatas.asMap().forEach(
        (i, value) => barChartGroups.add(BarChartGroupData(x: i, barRods: [
              BarChartRodData(y: value, colors: [primaryRed], width: 16)
            ])));
    return barChartGroups;
  }

//districtcard

//statecard

  Future<double> getstateData(int y) async {
    double _returnValue = 0;
    await FirebaseFirestore.instance
        .doc('${previousDates(y)}/$stateCode')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = data == null ||
                data['delta'] == null ||
                data['delta']['confirmed'] == null
            ? 0
            : double.parse(data['delta']['confirmed'].toString());
      } else {
        _returnValue = 0;
      }
    });
    return _returnValue;
  }

  Future<List<FlSpot>> getGraphData() async {
    return [
      FlSpot(0, await getstateData(29)),
      FlSpot(1, await getstateData(28)),
      FlSpot(2, await getstateData(27)),
      FlSpot(3, await getstateData(26)),
      FlSpot(4, await getstateData(25)),
      FlSpot(5, await getstateData(24)),
      FlSpot(6, await getstateData(23)),
      FlSpot(7, await getstateData(22)),
      FlSpot(8, await getstateData(21)),
      FlSpot(9, await getstateData(20)),
      FlSpot(10, await getstateData(19)),
      FlSpot(11, await getstateData(18)),
      FlSpot(12, await getstateData(17)),
      FlSpot(13, await getstateData(16)),
      FlSpot(14, await getstateData(15)),
      FlSpot(15, await getstateData(14)),
      FlSpot(16, await getstateData(13)),
      FlSpot(17, await getstateData(12)),
      FlSpot(18, await getstateData(11)),
      FlSpot(19, await getstateData(10)),
      FlSpot(20, await getstateData(9)),
      FlSpot(21, await getstateData(8)),
      FlSpot(22, await getstateData(7)),
      FlSpot(23, await getstateData(6)),
      FlSpot(24, await getstateData(5)),
      FlSpot(25, await getstateData(4)),
      FlSpot(26, await getstateData(3)),
      FlSpot(27, await getstateData(2)),
      FlSpot(28, await getstateData(1)),
      FlSpot(29, await getstateData(0)),
    ];
  }

//statecard

//indiacard

  Future<Map> rowValue() async {
    Map abc = {
      "deltaconfirmed": await finalNumber("delta", "confirmed"),
      "totalconfirmed": await finalNumber("total", "confirmed"),
      "deltarecovered": await finalNumber("delta", "recovered"),
      "totalrecovered": await finalNumber("total", "recovered"),
      "deltadeceased": await finalNumber("delta", "deceased"),
      "totaldeceased": await finalNumber("total", "deceased"),
    };
    return abc;
  }

  Future<String> finalNumber(String deltaortotal, String item) async {
    String abc;

    DateTime _today = DateTime.now();
    String formatDate(DateTime day) {
      var outFormatter = new DateFormat('yyyy-MM-dd');
      return outFormatter.format(day);
    }

    if (await itemNumber(deltaortotal, formatDate(_today), item) == "0") {
      if (await itemNumber(deltaortotal,
              formatDate(_today.subtract(Duration(days: 1))), item) ==
          "0") {
        abc = 0.toString();
      } else {
        abc = await itemNumber(
            deltaortotal, formatDate(_today.subtract(Duration(days: 1))), item);
      }
    } else {
      abc = await itemNumber(deltaortotal, formatDate(_today), item);
    }
    return abc;
  }

  Future<String> itemNumber(
      String deltaortotal, String date, String item) async {
    String _returnValue = "0";
    await FirebaseFirestore.instance
        .doc('$date/TT/')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = (data == null ||
                data['$deltaortotal'] == null ||
                data['$deltaortotal']['$item'] == null)
            ? 0.toString()
            : _returnValue = data['$deltaortotal']['$item'].toString();
      } else {
        _returnValue = 0.toString();
      }
    });
    return _returnValue;
  }

//indiacard

}

class DistrictWeekChart extends StatelessWidget {
  final List<BarChartGroupData> graph;

  const DistrictWeekChart({
    Key key,
    this.graph,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AspectRatio(
              aspectRatio: 1.4,
              child: BarChart(BarChartData(
                  barGroups: graph,
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(showTitles: false),
                  ))))
        ],
      ),
    );
  }
}

class StateChart extends StatelessWidget {
  final List<FlSpot> graph;

  const StateChart({
    Key key,
    this.graph,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
              barWidth: 6,
              colors: [primaryRed],
              spots: graph,
              isCurved: false,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false))
        ]));
  }
}

class RowItem extends StatelessWidget {
  final Color txColor;
  final String txHeading;
  final String totalNumber;
  final String deltaNumber;

  const RowItem({
    Key key,
    this.txColor,
    this.txHeading,
    this.totalNumber,
    this.deltaNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(NumberFormat.decimalPattern().format(int.parse(deltaNumber)),
            style: TextStyle(
              color: primaryText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        Text(txHeading,
            style: TextStyle(
              color: txColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )),
        Text(NumberFormat.decimalPattern().format(int.parse(totalNumber)),
            style: TextStyle(
              color: primaryText,
              fontSize: 12,
            )),
      ],
    );
  }
}

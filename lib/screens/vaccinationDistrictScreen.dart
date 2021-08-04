import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/constants.dart';
import 'package:covidapp/main.dart';
import 'package:covidapp/screens/homeScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
class VaccinationDistrictScreen extends StatefulWidget {
  final String district;
  final String state;
  const VaccinationDistrictScreen({Key key, this.district, this.state}) : super(key: key);
  @override
  _VaccinationDistrictScreenState createState() => _VaccinationDistrictScreenState();
}

class _VaccinationDistrictScreenState extends State<VaccinationDistrictScreen> {
  final adVaccinationDistrict1 = NativeAdmobController();
  final adVaccinationDistrict2 = NativeAdmobController();

  bool loadedVaccinationDistrict1 = false;
  bool loadedVaccinationDistrict2 = false;

  StreamSubscription adVaccinationDistrict1Subscription, adVaccinationDistrict2Subscription;

  @override
  void initState() {
    adVaccinationDistrict1Subscription =
        adVaccinationDistrict1.stateChanged.listen(_onStateChanged1);
    adVaccinationDistrict2Subscription =
        adVaccinationDistrict2.stateChanged.listen(_onStateChanged2);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    adVaccinationDistrict1Subscription.cancel();
    adVaccinationDistrict2Subscription.cancel();

    adVaccinationDistrict1.dispose();
    adVaccinationDistrict2.dispose();

    super.dispose();
  }

  void _onStateChanged1(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedVaccinationDistrict1 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccinationDistrict1 = true;
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
          loadedVaccinationDistrict2 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccinationDistrict2 = true;
        });
        break;

      default:
        break;
    }
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
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: FutureBuilder(
                  future: getValues(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Container(
                          height: maxHeight*0.35,
                          decoration: BoxDecoration(
                            color: bgGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 10, bottom: 20, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dose 1",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText),
                                        ),
                                        Text(
                                          NumberFormat.decimalPattern().format(int.parse(snapshot.data["deltadata1"])),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText,
                                              fontWeight: FontWeight.bold),

                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          "Total till date",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText),
                                        ),
                                        Text(
                                          NumberFormat.decimalPattern().format(int.parse(snapshot.data["totaldata1"])),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText,
                                              fontWeight: FontWeight.bold),

                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AspectRatio(
                                      aspectRatio: 2,
                                      child: StateChart(
                                          graph:snapshot.data["graph1"]
                                      )),
                                ),
                              ),
                            ],
                          ))


                      ;
                    }
                    if(snapshot.hasError){
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
                  }
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Container(
                height: !loadedVaccinationDistrict1?0:maxHeight * 0.2,
                decoration: BoxDecoration(
                  color: bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NativeAdmob(
                    adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                    controller: adVaccinationDistrict1,
                    type: NativeAdmobType.full,
                    loading: Container(),
                    error: Text("error"),


                    options: NativeAdmobOptions(showMediaContent: false,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed) ),


                  ),
                ),

              ),
            )
            ,

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: FutureBuilder(
                  future: getValues(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Container(
                          height: maxHeight*0.35,
                          decoration: BoxDecoration(
                            color: bgGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 10, bottom: 20, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Dose 2",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText),
                                        ),
                                        Text(
                                          NumberFormat.decimalPattern().format(int.parse(snapshot.data["deltadata2"])),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText,
                                              fontWeight: FontWeight.bold),

                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          "Total till date",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText),
                                        ),
                                        Text(
                                          NumberFormat.decimalPattern().format(int.parse(snapshot.data["totaldata2"])),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: primaryText,
                                              fontWeight: FontWeight.bold),

                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AspectRatio(
                                      aspectRatio: 2,
                                      child: StateChart(
                                          graph:snapshot.data["graph2"]
                                      )),
                                ),
                              ),
                            ],
                          ))


                      ;
                    }
                    if(snapshot.hasError){
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
                  }
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16),
              child: Container(
                height: !loadedVaccinationDistrict2?0:maxHeight * 0.5,
                decoration: BoxDecoration(
                  color: bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NativeAdmob(
                    adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                    controller: adVaccinationDistrict2,
                    type: NativeAdmobType.full,
                    loading: Container(),
                    error: Text("error"),


                    options: NativeAdmobOptions(showMediaContent: true,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed) ),


                  ),
                ),

              ),
            )
            ,
            SizedBox(height: 10,),





          ],
        ),
      ),
    );
  }


  Future<String> getTotalVAC(int x, String dort) async {
    String _returnValue = "0";
    await FirebaseFirestore.instance
        .doc('${formatDate()}/${widget.state}/districts/${widget.district}')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = data == null || data['$dort'] == null || data['$dort']['vaccinated$x'] == null
            ? "0"
            : data['$dort']['vaccinated$x'].toString();
      }
      else{
        _returnValue ="0";
      }
    });
    return _returnValue;
  }


  String previousDates(int x) {
    DateTime pvDate = _selectedDay.subtract(Duration(days: x));

    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(pvDate);
  }





  Future<double> getData(int y,int v) async {
    double _returnValue = 0;
    await FirebaseFirestore.instance
        .doc('${previousDates(y)}/${widget.state}/districts/${widget.district}')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = data == null || data['delta'] == null || data['delta']['vaccinated$v'] == null
            ? 0
            : double.parse(data['delta']['vaccinated$v'].toString());
      }
      else{
        _returnValue =0;
      }
    });
    return _returnValue;
  }



  Future<List<FlSpot>> getGraphData1() async{
    return [
      FlSpot(0, await getData(29,1)),
      FlSpot(1, await getData(28,1)),
      FlSpot(2, await getData(27,1)),
      FlSpot(3, await getData(26,1)),
      FlSpot(4, await getData(25,1)),
      FlSpot(5, await getData(24,1)),
      FlSpot(6, await getData(23,1)),
      FlSpot(7, await getData(22,1)),
      FlSpot(8, await getData(21,1)),
      FlSpot(9, await getData(20,1)),
      FlSpot(10, await getData(19,1)),
      FlSpot(11, await getData(18,1)),
      FlSpot(12, await getData(17,1)),
      FlSpot(13, await getData(16,1)),
      FlSpot(14, await getData(15,1)),
      FlSpot(15, await getData(14,1)),
      FlSpot(16, await getData(13,1)),
      FlSpot(17, await getData(12,1)),
      FlSpot(18, await getData(11,1)),
      FlSpot(19, await getData(10,1)),
      FlSpot(20, await getData(9,1)),
      FlSpot(21, await getData(8,1)),
      FlSpot(22, await getData(7,1)),
      FlSpot(23, await getData(6,1)),
      FlSpot(24, await getData(5,1)),
      FlSpot(25, await getData(4,1)),
      FlSpot(26, await getData(3,1)),
      FlSpot(27, await getData(2,1)),
      FlSpot(28, await getData(1,1)),
      FlSpot(29, await getData(0,1)),
    ];
  }
  Future<List<FlSpot>> getGraphData2() async{
    return [
      FlSpot(0, await getData(29,2)),
      FlSpot(1, await getData(28,2)),
      FlSpot(2, await getData(27,2)),
      FlSpot(3, await getData(26,2)),
      FlSpot(4, await getData(25,2)),
      FlSpot(5, await getData(24,2)),
      FlSpot(6, await getData(23,2)),
      FlSpot(7, await getData(22,2)),
      FlSpot(8, await getData(21,2)),
      FlSpot(9, await getData(20,2)),
      FlSpot(10, await getData(19,2)),
      FlSpot(11, await getData(18,2)),
      FlSpot(12, await getData(17,2)),
      FlSpot(13, await getData(16,2)),
      FlSpot(14, await getData(15,2)),
      FlSpot(15, await getData(14,2)),
      FlSpot(16, await getData(13,2)),
      FlSpot(17, await getData(12,2)),
      FlSpot(18, await getData(11,2)),
      FlSpot(19, await getData(10,2)),
      FlSpot(20, await getData(9,2)),
      FlSpot(21, await getData(8,2)),
      FlSpot(22, await getData(7,2)),
      FlSpot(23, await getData(6,2)),
      FlSpot(24, await getData(5,2)),
      FlSpot(25, await getData(4,2)),
      FlSpot(26, await getData(3,2)),
      FlSpot(27, await getData(2,2)),
      FlSpot(28, await getData(1,2)),
      FlSpot(29, await getData(0,2)),
    ];
  }

  Future<Map> getValues() async{
    Map abc={
      "deltadata1":await getTotalVAC(1,"delta"),
      "deltadata2":await getTotalVAC(2,"delta"),
      "totaldata1":await getTotalVAC(1,"total"),
      "totaldata2":await getTotalVAC(2,"total"),

      "graph1":await getGraphData1(),
      "graph2":await getGraphData2()


    };
    return abc;
  }

}



class StateChart extends StatelessWidget {

  final List<FlSpot> graph;

  const StateChart(
      {Key key, this.graph,
        })
      : super(key: key);

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
                ]))

;
  }


}





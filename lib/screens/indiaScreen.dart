import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/main.dart';
import 'package:covidapp/screens/stateScreen.dart';
import 'package:covidapp/statesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants.dart';
import 'homeScreen.dart';

class IndiaScreen extends StatefulWidget {
  const IndiaScreen({Key key}) : super(key: key);

  @override
  _IndiaScreenState createState() => _IndiaScreenState();
}

class _IndiaScreenState extends State<IndiaScreen> {
  final adIndiaState1 = NativeAdmobController();
  final adIndiaState2 = NativeAdmobController();

  bool loadedIndiaState1 = false;
  bool loadedIndiaState2 = false;

  StreamSubscription adIndiaState1Subscription,
      adIndiaState2Subscription;

  @override
  void initState() {
    adIndiaState1Subscription =
        adIndiaState1.stateChanged.listen(_onStateChanged1);
    adIndiaState2Subscription =
        adIndiaState2.stateChanged.listen(_onStateChanged2);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    adIndiaState1Subscription.cancel();
    adIndiaState2Subscription.cancel();

    adIndiaState1.dispose();
    adIndiaState2.dispose();

    super.dispose();
  }

  void _onStateChanged1(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedIndiaState1 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedIndiaState1 = true;
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
          loadedIndiaState2 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedIndiaState2 = true;
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
        title: Text("India"),
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 8),
              child: FutureBuilder(
                  future: rowValue(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: bgGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 26, bottom: 26, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RowItem(
                                txColor: cardYellow,
                                txHeading: "CONFIRMED",
                                totalNumber: snapshot.data["totalconfirmed"],
                                deltaNumber: snapshot.data["deltaconfirmed"],

                              ),
                              RowItem(
                                txColor: cardGreen,
                                txHeading: "RECOVERED",
                                totalNumber: snapshot.data["totalrecovered"],
                                deltaNumber: snapshot.data["deltarecovered"],

                              ),
                              RowItem(
                                txColor: primaryRed,
                                txHeading: "DECEASED",
                                totalNumber: snapshot.data["totaldeceased"],
                                deltaNumber: snapshot.data["deltadeceased"],

                              ),
                            ],
                          ),
                        ),
                      )


                      ;
                    }
                    if(snapshot.hasError){
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
                  }
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                height: !loadedIndiaState1 ? 0 : maxHeight * 0.2,
                decoration: BoxDecoration(
                  color: bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NativeAdmob(
                    adUnitID: 'ca-app-pub-3940256099942544/3986624511',
                    controller: adIndiaState1,
                    type: NativeAdmobType.full,
                    loading: Container(),
                    error: Text("error"),
                    options: NativeAdmobOptions(
                        showMediaContent: false,
                        ratingColor: primaryRed,
                        callToActionStyle:
                        NativeTextStyle(backgroundColor: primaryRed)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 8, bottom: 16),
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
                            top: 15, left: 20, right: 15, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "State",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Confirmed",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      new ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: stateList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new StateCard(
                                date: formatDate(),
                                state: stateList[index],
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StateScreen(
                                                stateCode:
                                                    stateList[index].stateCode,
                                                stateName:
                                                    stateList[index].stateName,
                                              )));
                                },
                                item: stateList[index],
                              ),
                            );
                          },
                        separatorBuilder: (BuildContext context, int index) {
                          return index%10==0?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: !loadedIndiaState2?0:maxHeight * 0.1,
                              decoration: BoxDecoration(
                                color: bgWhite,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: NativeAdmob(
                                  adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                                  controller: adIndiaState2,
                                  type: NativeAdmobType.banner,
                                  loading: Container(),
                                  numberAds: 3,
                                  error: Text("error"),


                                  options: NativeAdmobOptions(showMediaContent: false,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed) ),


                                ),
                              ),

                            ),
                          ):Container();
                        },

                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> itemNumber(String deltaortotal,String item) async {
    String _returnValue = "0";
    await FirebaseFirestore.instance
        .doc('${formatDate()}/TT')
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

  Future<Map> rowValue() async{
    Map abc={
      "deltaconfirmed":await itemNumber("delta", "confirmed"),
      "totalconfirmed":await itemNumber("total", "confirmed"),
      "deltarecovered":await itemNumber("delta", "recovered"),
      "totalrecovered":await itemNumber("total", "recovered"),
      "deltadeceased":await itemNumber("delta", "deceased"),
      "totaldeceased":await itemNumber("total", "deceased"),

    };
    return abc;
  }
}

class StateCard extends StatelessWidget {
  final StateList state;
  final VoidCallback onTap;
  final StateList item;
  final bool selected;
  final String date;

  const StateCard(
      {Key key,
      this.state,
      this.onTap,
      this.item,
      this.selected,
      this.date,
    })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (selected)
    //   textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return FutureBuilder(
        future: itemNumber(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return InkWell(
              onTap: () {
                onTap();
              },
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bgWhite,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          state.stateName,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                        Row(
                          children: [
                            Text(
                              NumberFormat.decimalPattern()
                                  .format(int.parse(snapshot.data)),
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.left,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: primaryRed,
                              size: 14,
                            )
                          ],
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  )),
            )


            ;
          }
          if(snapshot.hasError){
            return Shimmer.fromColors(
              baseColor: shimmerbasecolor,
              highlightColor: shimmerhighlightcolor,
              child: Container(
                height:40,
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
              height:40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
    );
  }



  Future<String> itemNumber() async {
    String _returnValue = "0";
    await FirebaseFirestore.instance
        .doc('$date/${state.stateCode}')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = (data == null ||
            data['delta'] == null ||
            data['delta']['confirmed'] == null)
            ? 0.toString()
            : _returnValue = data['delta']['confirmed'].toString();
      } else {
        _returnValue = 0.toString();
      }
    });
    return _returnValue;
  }
}

class RowItem extends StatelessWidget {
  final Color txColor;
  final String txHeading;


  final String totalNumber;
  final String deltaNumber;

  const RowItem(
      {Key key,
      this.txColor,
      this.txHeading, this.totalNumber, this.deltaNumber,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Text(
                    NumberFormat.decimalPattern()
                        .format(int.parse(deltaNumber)),
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
        Text(
                    NumberFormat.decimalPattern()
                        .format(int.parse(totalNumber)),
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 12,
                    )),
      ],
    );
  }


}

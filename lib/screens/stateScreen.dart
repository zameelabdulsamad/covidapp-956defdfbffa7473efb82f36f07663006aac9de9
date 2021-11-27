import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/districtList.dart';
import 'package:covidapp/main.dart';
import 'package:covidapp/screens/districtScreen.dart';
import 'package:covidapp/statesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

import 'package:table_calendar/table_calendar.dart';

import '../constants.dart';
import 'homeScreen.dart';

class StateScreen extends StatefulWidget {
  final String stateName;
  final String stateCode;

  const StateScreen({Key key, this.stateName, this.stateCode})
      : super(key: key);

  @override
  _StateScreenState createState() => _StateScreenState();
}

class _StateScreenState extends State<StateScreen> {

  final adStatusState1 = NativeAdmobController();
  final adStatusState2 = NativeAdmobController();

  bool loadedStatusState1 = false;
  bool loadedStatusState2 = false;

  StreamSubscription adStatusState1Subscription,
      adStatusState2Subscription;

  @override
  void initState() {
    adStatusState1Subscription =
        adStatusState1.stateChanged.listen(_onStateChanged1);
    adStatusState2Subscription =
        adStatusState2.stateChanged.listen(_onStateChanged2);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    adStatusState1Subscription.cancel();
    adStatusState2Subscription.cancel();

    adStatusState1.dispose();
    adStatusState2.dispose();

    super.dispose();
  }

  void _onStateChanged1(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedStatusState1 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedStatusState1 = true;
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
          loadedStatusState2 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedStatusState2 = true;
        });
        break;

      default:
        break;
    }
  }
  List<DistrictCodeList> getDistrictList() {
    if (widget.stateCode == "AN") {
      return ANList;
    } else if (widget.stateCode == "AP") {
      return APList;
    } else if (widget.stateCode == "AR") {
      return ARList;
    } else if (widget.stateCode == "AS") {
      return ASList;
    } else if (widget.stateCode == "BR") {
      return BRList;
    } else if (widget.stateCode == "CH") {
      return CHList;
    } else if (widget.stateCode == "CT") {
      return CTList;
    } else if (widget.stateCode == "DL") {
      return DLList;
    } else if (widget.stateCode == "DN") {
      return DNList;
    } else if (widget.stateCode == "GA") {
      return GAList;
    } else if (widget.stateCode == "GJ") {
      return GJList;
    } else if (widget.stateCode == "HP") {
      return HPList;
    } else if (widget.stateCode == "HR") {
      return HRList;
    } else if (widget.stateCode == "JH") {
      return JHList;
    } else if (widget.stateCode == "JK") {
      return JKList;
    } else if (widget.stateCode == "KA") {
      return KAList;
    } else if (widget.stateCode == "KL") {
      return KLList;
    } else if (widget.stateCode == "LA") {
      return LAList;
    } else if (widget.stateCode == "LD") {
      return LDList;
    } else if (widget.stateCode == "MH") {
      return MHList;
    } else if (widget.stateCode == "ML") {
      return MLList;
    } else if (widget.stateCode == "MN") {
      return MNList;
    } else if (widget.stateCode == "MP") {
      return MPList;
    } else if (widget.stateCode == "MZ") {
      return MZList;
    } else if (widget.stateCode == "NL") {
      return NLList;
    } else if (widget.stateCode == "OR") {
      return ORList;
    } else if (widget.stateCode == "PB") {
      return PBList;
    } else if (widget.stateCode == "PY") {
      return PYList;
    } else if (widget.stateCode == "RJ") {
      return RJList;
    } else if (widget.stateCode == "SK") {
      return SKList;
    } else if (widget.stateCode == "TG") {
      return TGList;
    } else if (widget.stateCode == "TN") {
      return TNList;
    } else if (widget.stateCode == "TR") {
      return TRList;
    } else if (widget.stateCode == "UP") {
      return UPList;
    } else if (widget.stateCode == "UT") {
      return UTList;
    } else if (widget.stateCode == "WB") {
      return WBList;
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
    double maxWidth = MediaQuery.of(context).size.width;




    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgGrey,
        elevation: 0,
        title: Text(widget.stateName),
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
                height: !loadedStatusState1 ? 0 : maxHeight * 0.28,
                decoration: BoxDecoration(
                  color: bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: NativeAdmob(
                    adUnitID: 'ca-app-pub-3940256099942544/3986624511',
                    controller: adStatusState1,
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
              padding:
                  const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
              child: FutureBuilder(
                  future: tpCard(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Container(
                          decoration: BoxDecoration(
                            color: bgGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 10, bottom: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Test Positivity",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: primaryText),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 16, left: 16),
                                      child:  new CircularPercentIndicator(
                                        radius: 110.0,
                                        lineWidth: 30.0,
                                        percent: snapshot.data['percent'],
                                        center: new Text(
                                          "${(snapshot.data['percent'] * 100).toStringAsFixed(1)}%",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryText,
                                              fontSize: 12),
                                        ),
                                        progressColor: primaryRed,
                                        backgroundColor: iconGrey,
                                        circularStrokeCap: CircularStrokeCap.butt,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Total Tested",
                                            style: TextStyle(
                                                fontSize: 14, color: primaryText),
                                          ),
                                          Text(
                                            NumberFormat.decimalPattern()
                                                .format(int.parse(snapshot.data['tested'])),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: primaryText,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
              ),
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
                              "District",
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
                          itemCount: getDistrictList().length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new StateCard(
                                date: formatDate(),
                                state: widget.stateCode,
                                district: getDistrictList()[index].districtName,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DistrictScreen(
                                                state: widget.stateCode,
                                                district:
                                                    getDistrictList()[index]
                                                        .districtName,
                                              )));
                                },
                                item: getDistrictList()[index].districtName,
                              ),
                            );
                          },
                        separatorBuilder: (BuildContext context, int index) {
                          return index%10==0?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: !loadedStatusState2?0:maxHeight * 0.15,
                              decoration: BoxDecoration(
                                color: bgWhite,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: NativeAdmob(
                                  adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                                  controller: adStatusState2,
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

  Future<Map> tpCard() async{
    Map abc={"percent":await getPercent(),
      "tested":await tpValues("tested")};
    return abc;
  }


  Future<double> getPercent() async{
    double percent;
    String tested = await tpValues("tested");
    int testedinInt = int.parse(tested);
    String confirmed = await tpValues("confirmed");
    int confirmedinInt = int.parse(confirmed);
    percent = testedinInt == 0 || confirmedinInt == 0 ? 0 : (confirmedinInt / testedinInt);
    return percent;


  }

  Future<String> tpValues(String item) async{
    String _returnValue="0";
    await FirebaseFirestore.instance
        .doc('${formatDate()}/${widget.stateCode}')
        .get().then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue=(data == null ||data['delta'] == null||data['delta']['$item'] == null)?0.toString():_returnValue=data['delta']['$item'].toString();


      }
      else{

        _returnValue=0.toString();
      }
    });
    return _returnValue;
  }

  Future<String> itemNumber(String deltaortotal,String item) async {
    String _returnValue = "0";
    await FirebaseFirestore.instance
        .doc('${formatDate()}/${widget.stateCode}/')
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
  final String district;
  final String state;
  final VoidCallback onTap;
  final String item;
  final bool selected;
  final String date;

  const StateCard(
      {Key key,
      this.district,
      this.onTap,
      this.item,
      this.selected,
      this.date,
      this.state})
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
                          district,
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
                            )
                            ,
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
        .doc('$date/$state/districts/$district')
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
                    NumberFormat.decimalPattern().format(
                      int.parse(totalNumber),
                    ),
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 12,
                    )),
      ],
    );
  }


}

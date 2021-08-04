import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/constants.dart';
import 'package:covidapp/main.dart';
import 'package:covidapp/screens/boardingScreen.dart';
import 'package:covidapp/screens/changeUserLocation.dart';
import 'package:covidapp/screens/cowinAppScreen.dart';
import 'package:covidapp/screens/districtScreen.dart';
import 'package:covidapp/screens/indiaScreen.dart';
import 'package:covidapp/screens/newsScreen.dart';
import 'package:covidapp/screens/settingsPage.dart';
import 'package:covidapp/screens/stateScreen.dart';
import 'package:covidapp/screens/statusScreen.dart';
import 'package:covidapp/screens/vaccinationDistrictScreen.dart';
import 'package:covidapp/screens/vaccinationScreen.dart';
import 'package:covidapp/userPrefs.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


String userDistrict;
String userState;
String userDistrictCode;
String userStateCode;
bool firestoreDownload=false;
DateTime _today = DateTime.now();

String formatdate(DateTime date) {
  var outFormatter = new DateFormat('yyyy-MM-dd');
  return outFormatter.format(date);
}

class _HomeScreenState extends State<HomeScreen> {

   final adHome1 = NativeAdmobController();
   final adHome2 = NativeAdmobController();

   bool loaded1=false;
   bool loaded2=false;






   StreamSubscription adHome1Subscription,adHome2Subscription;

  @override
  void initState() {
    userDistrict = UserPreferences().districtName;
    userState = UserPreferences().stateName;
    userDistrictCode = UserPreferences().districtCode;
    userStateCode = UserPreferences().stateCode;

    adHome1Subscription = adHome1.stateChanged.listen(_onStateChanged1);
    adHome2Subscription = adHome2.stateChanged.listen(_onStateChanged2);


    // TODO: implement initState
    super.initState();


  }

   @override
   void dispose() {
     adHome1Subscription.cancel();
     adHome2Subscription.cancel();

     adHome1.dispose();
     adHome2.dispose();

     super.dispose();
   }

   void _onStateChanged1(AdLoadState state) {
     switch (state) {
       case AdLoadState.loading:
         setState(() {
           loaded1=false;
         });
         break;

       case AdLoadState.loadCompleted:
         setState(() {
           loaded1 = true;
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
           loaded2=false;
         });
         break;

       case AdLoadState.loadCompleted:
         setState(() {
           loaded2 = true;
         });
         break;

       default:
         break;
     }
   }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;





    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding:
              EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgGrey,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 18),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeUserLocation()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: iconGrey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(



                            children: [
                              Icon(
                                Icons.location_on,
                                color: iconGrey,
                                size: 22,
                              ),
                              Text(
                                userDistrict,
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: <Widget>[
                      HomeInfoCard(
                        title: "Confirmed",
                        iconColor: coronaYellow,
                        today: _today,
                        deltaortotal:"delta",
                        item: "confirmed",
                        homeInfoCardPage: DistrictScreen(
                          district: userDistrict,
                          state: userStateCode,
                        ),
                      ),
                      HomeInfoCard(
                        title: "Deceased",
                        iconColor: coronaRed,
                        deltaortotal:"delta",

                        today: _today,
                        item: "deceased",
                        homeInfoCardPage: DistrictScreen(
                          district: userDistrict,
                          state: userStateCode,
                        ),
                      ),
                      HomeInfoCard(
                        title: "Recovered",
                        iconColor: coronaGreen,
                        deltaortotal:"delta",

                        today: _today,
                        item: "recovered",
                        homeInfoCardPage: DistrictScreen(
                          district: userDistrict,
                          state: userStateCode,
                        ),
                      ),
                      HomeInfoCard(
                        title: "Vaccinated",
                        iconColor: coronaBlue,
                        today: _today,
                        deltaortotal:"delta",

                        item: "vaccinated2",
                        homeInfoCardPage: VaccinationDistrictScreen(
                          district: userDistrict,
                          state: userStateCode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:12.0,right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        homeButton(
                          title: "Helpline",
                          buttonIcon: Icons.headset,
                            homeButtonPage: CowinAppScreen(),
                        ),
                        homeButton(
                            title: "Status",
                            buttonIcon: Icons.bar_chart,
                            homeButtonPage: StatusScreen()),
                        homeButton(
                            title: "News",
                            buttonIcon: Icons.article,
                            homeButtonPage: CowinAppScreen()),




                        homeButton(
                          title: "Vaccination",
                          buttonIcon: Icons.medical_services_rounded,
                          homeButtonPage: VaccinationScreen(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: bgGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: !loaded1?0:maxHeight * 0.5,
                    decoration: BoxDecoration(
                      color: bgGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: NativeAdmob(
                        adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                        controller: adHome1,
                        type: NativeAdmobType.full,
                        loading: Container(),
                        error: Text("error"),


                        options: NativeAdmobOptions(showMediaContent: true,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed)),


                      ),
                    ),

                  )
                  ,
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: tpCard(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          return  GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StateScreen(
                                      stateName: userState,
                                      stateCode: userStateCode,
                                    )),
                              );
                            },
                            child: Container(
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
                                          bottom: 8,
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
                                                "Test Positivity",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryText),
                                              ),
                                              Text(
                                                userState,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal,
                                                    color: primaryText),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8, bottom: 16, left: 16),
                                              child: new CircularPercentIndicator(
                                                radius: 110.0,
                                                lineWidth: 30.0,
                                                percent: snapshot.data["percent"],
                                                center: new Text(
                                                  "${(snapshot.data["percent"] * 100).toStringAsFixed(1)}%",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryText,
                                                      fontSize: 12),
                                                ),
                                                progressColor: primaryRed,
                                                backgroundColor: iconGrey,
                                                circularStrokeCap:
                                                CircularStrokeCap.butt,
                                              ),

                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Total Tested",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: primaryText),
                                                ),
                                                Text(
                                                  NumberFormat.decimalPattern()
                                                      .format(int.parse(
                                                      snapshot.data["tested"])),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: primaryText,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                )
                                                ,
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: !loaded2?0:maxHeight * 0.28,
                    decoration: BoxDecoration(
                      color: bgGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: NativeAdmob(
                        adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                        controller: adHome2,
                        type: NativeAdmobType.full,
                        loading: Container(),
                        error: Text("error"),


                        options: NativeAdmobOptions(showMediaContent: false,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed) ),


                      ),
                    ),

                  )
                  ,
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: rowValue() ,
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
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
                                        top: 16.0, left: 10, bottom: 20, right: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                ],
                              ),
                            ),
                          );


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
                  SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Covid Point"),
      backgroundColor: bgGrey,
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => SettingsPage()),
            // );
          },
          color: iconGrey,
        )
      ],
    );
  }





  Future<double> getPercent() async{
    double percent;
    String tested = await testpositivityData("tested");
    int testedinInt = int.parse(tested);
    String confirmed = await testpositivityData("confirmed");
    int confirmedinInt = int.parse(confirmed);
    percent = testedinInt == 0 || confirmedinInt == 0 ? 0 : (confirmedinInt / testedinInt);
    return percent;


  }
  Future<Map> tpCard() async{
    Map abc={"percent":await getPercent(),
      "tested":await testpositivityData("tested")};
    return abc;
  }








  Future<String> tpValues(String item, DateTime date) async{
    String _returnValue="0";
    await FirebaseFirestore.instance
        .doc('${formatdate(date)}/$userStateCode')
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






  Future<String> testpositivityData(String item) async{
    String abc;

    if (await tpValues(item, _today) == "0") {
      if (await tpValues(item, _today.subtract(Duration(days: 1))) == "0") {
        abc =  0.toString();
      } else {
        abc =await  tpValues(item, _today.subtract(Duration(days: 1)));
      }
    } else {
      abc = await tpValues(item, _today);
    }
    return abc;
  }

  Future<Map> rowValue() async{
    Map abc={
      "deltaconfirmed":await finalNumber("delta", "confirmed"),
      "totalconfirmed":await finalNumber("total", "confirmed"),
      "deltarecovered":await finalNumber("delta", "recovered"),
      "totalrecovered":await finalNumber("total", "recovered"),
      "deltadeceased":await finalNumber("delta", "deceased"),
      "totaldeceased":await finalNumber("total", "deceased"),

    };
    return abc;
  }

  Future<String> finalNumber(String deltaortotal,String item) async {
    String abc;

    DateTime _today = DateTime.now();
    String formatDate(DateTime day) {
      var outFormatter = new DateFormat('yyyy-MM-dd');
      return outFormatter.format(day);
    }

    if (await itemNumber(deltaortotal, formatDate(_today),item) == "0") {
      if (await itemNumber(
          deltaortotal, formatDate(_today.subtract(Duration(days: 1))),item) ==
          "0") {
        abc=  0.toString();
      } else {
        abc= await itemNumber(
            deltaortotal, formatDate(_today.subtract(Duration(days: 1))),item);
      }
    } else {
      abc= await  itemNumber(deltaortotal, formatDate(_today),item);
    }
    return abc;
  }




  Future<String> itemNumber(String deltaortotal, String date,String item) async{
    String _returnValue="0";
    await FirebaseFirestore.instance
        .doc('$date/TT/')
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
}

class homeButton extends StatelessWidget {
  final String title;
  final IconData buttonIcon;
  final Widget homeButtonPage;

  const homeButton({
    Key key,
    this.title,
    this.buttonIcon,
    this.homeButtonPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
         GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => homeButtonPage),
            );
          },
          child: Container(
            height: 50,
            width: 50,
            decoration:
            BoxDecoration(color: primaryRed, shape: BoxShape.circle),
            child: Icon(
              buttonIcon,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child:  Text(
            title,
            style: TextStyle(
                 color: primaryText,fontSize: 12),
          ),
        )
      ],
    );
  }
}

class HomeInfoCard extends StatelessWidget {
  final String title;
  final Color iconColor;
  final String item;
  final String deltaortotal;
  final DateTime today;
  final Widget homeInfoCardPage;

  const HomeInfoCard({
    Key key,
    this.title,
    this.iconColor,
    this.item,
    this.today,
    this.homeInfoCardPage, this.deltaortotal,
  }) : super(key: key);

  String formatDate(DateTime date) {
    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(date);
  }

  @override
  Widget build(BuildContext context) {

    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    final curScaleFactor = MediaQuery.of(context).textScaleFactor;
    return LayoutBuilder(builder: (context, constraints) {
      return  FutureBuilder(
          future: homeIC(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => homeInfoCardPage),
                  );
                },
                child: Container(
                  width: constraints.maxWidth / 2 - 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: iconColor.withOpacity(0.12),
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.coronavirus_rounded,
                                size: 18,
                                color: iconColor,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              title,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10.0, left: 10, right: 10),
                              child: RichText(
                                text: TextSpan(
                                    style: TextStyle(color: primaryText),
                                    children: [
                                      TextSpan(
                                          text:
                                          "${NumberFormat.decimalPattern().format(int.parse(snapshot.data["data"]))}\n",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: "People",
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1,
                                          ))
                                    ]),
                              ),
                            ),
                            Expanded(
                                child: AspectRatio(
                                  aspectRatio: 3,
                                  child: LineChart(LineChartData(
                                      gridData: FlGridData(show: false),
                                      titlesData: FlTitlesData(show: false),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                            barWidth: 3,
                                            colors: [primaryRed],
                                            spots: snapshot.data["graph"],
                                            isCurved: true,
                                            dotData: FlDotData(show: false),
                                            belowBarData:
                                            BarAreaData(show: false))
                                      ])),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );



            }
            if(snapshot.hasError){
              return Shimmer.fromColors(
                baseColor: shimmerbasecolor,
                highlightColor: shimmerhighlightcolor,
                child: Container(
                  width: constraints.maxWidth / 2 - 10,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(height: maxHeight * 0.13),
                ),
              );
            }
            return Shimmer.fromColors(
              baseColor: shimmerbasecolor,
              highlightColor: shimmerhighlightcolor,
              child: Container(
                width: constraints.maxWidth / 2 - 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(height: maxHeight * 0.13),
              ),
            );
          }
      );
    });
  }

  String previousDates(int x) {
    DateTime pvDate = _today.subtract(Duration(days: x));

    var outFormatter = new DateFormat('yyyy-MM-dd');
    return outFormatter.format(pvDate);
  }
  Future<Map> homeIC() async{
    Map abc={"graph":await getGraph(),
      "data":await numberOfPeople()};
    return abc;
  }

  Future<double> graphgetValues(int y, String item) async {
    double _returnValue = 0;
    await FirebaseFirestore.instance
        .doc('${previousDates(y)}/$userStateCode/districts/$userDistrict')
        .get()
        .then((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      if (documentSnapshot.exists) {
        _returnValue = data == null || data['$deltaortotal'] == null || data['$deltaortotal']['$item'] == null
            ? 0
            : double.parse(data['$deltaortotal']['$item'].toString());
      }
      else{
        _returnValue =0;
      }
    });
    return _returnValue;
  }

  Future<List<FlSpot>> getGraph() async{
    return [
      FlSpot(0, await graphgetValues(6, "$item")),
      FlSpot(1, await graphgetValues(5, "$item")),
      FlSpot(2, await graphgetValues(4, "$item")),
      FlSpot(3, await graphgetValues(3, "$item")),
      FlSpot(4, await graphgetValues(2, "$item")),
      FlSpot(5, await graphgetValues(1, "$item")),
      FlSpot(6, await graphgetValues(0, "$item")),
    ];
  }



  Future<String> numberOfPeople() async{
    String abc;
    if (await itemNumber(today) == "0") {
      if (await itemNumber(today.subtract(Duration(days: 1))) == "0") {

        abc= "0";
      } else {
        abc= await   itemNumber(today.subtract(Duration(days: 1)));

      }
    } else {
      abc= await  itemNumber(today);

    }
    return abc;
  }

  Future<String> itemNumber(DateTime date) async{
    String _returnValue="0";
    await FirebaseFirestore.instance
        .doc('${formatDate(date)}/$userStateCode/districts/$userDistrict')
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


}

class RowItem extends StatelessWidget {
  final Color txColor;
  final String txHeading;
  final String totalNumber;
  final String deltaNumber;

  const RowItem(
      {Key key,
        this.txColor,
        this.txHeading,
         this.totalNumber, this.deltaNumber})
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
                    ))
                ,
      ],
    );
  }


}



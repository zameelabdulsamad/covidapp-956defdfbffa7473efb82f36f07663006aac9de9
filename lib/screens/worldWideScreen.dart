import 'dart:async';

import 'package:covidapp/main.dart';
import 'package:covidapp/screens/homeScreen.dart';
import 'package:covidapp/statesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class WorldwideScreen extends StatefulWidget {
  const WorldwideScreen({Key key}) : super(key: key);

  @override
  _WorldwideScreenState createState() => _WorldwideScreenState();
}

class _WorldwideScreenState extends State<WorldwideScreen> {
  final adStatusWorldwide = NativeAdmobController();

  bool loadedStatusWorldwide = false;

  StreamSubscription adStatusWorldwideSubscription;


  @override
  void dispose() {
    adStatusWorldwideSubscription.cancel();

    adStatusWorldwide.dispose();

    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedStatusWorldwide = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedStatusWorldwide = true;
        });
        break;

      default:
        break;
    }
  }

  @override
  void initState() {

    adStatusWorldwideSubscription =
        adStatusWorldwide.stateChanged.listen(_onStateChanged);

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgGrey,
          elevation: 0,
          title: Text("Worldwide"),
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),

            child: Column(children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: bgGrey,
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16, right: 16, bottom: 8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bgGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Text(
                                NumberFormat.decimalPattern().format(
                                    int.parse(WMapResponse[0]["todayCases"]
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
                                NumberFormat.decimalPattern().format(
                                    int.parse(
                                        WMapResponse[0]["cases"].toString())),
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Text(
                                NumberFormat.decimalPattern().format(
                                    int.parse(WMapResponse[0]["active"]
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
                                NumberFormat.decimalPattern().format(
                                    int.parse(WMapResponse[0]["recovered"]
                                        .toString())),
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                        SizedBox(height: 30),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Text(
                                NumberFormat.decimalPattern().format(
                                    int.parse(WMapResponse[0]["todayDeaths"]
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
                                NumberFormat.decimalPattern().format(
                                    int.parse(WMapResponse[0]["deaths"]
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
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Container(
                width: double.infinity,
                child: new ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: WMapResponse.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return index==0?Container():Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new CountryCard(
                          country: index,
                        ),
                      );
                    },
                  separatorBuilder: (BuildContext context, int index) {
                    return index % 4 == 0
                        ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: !loadedStatusWorldwide
                            ? 0
                            : maxHeight * 0.2,
                        decoration: BoxDecoration(
                          color: bgGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: NativeAdmob(
                            adUnitID:
                            'ca-app-pub-3940256099942544/3986624511',
                            controller: adStatusWorldwide,
                            type: NativeAdmobType.full,
                            loading: Container(),
                            numberAds: 3,
                            error: Text("error"),
                            options: NativeAdmobOptions(
                                showMediaContent: false,
                                ratingColor: primaryRed,
                                callToActionStyle: NativeTextStyle(
                                    backgroundColor: primaryRed)),
                          ),
                        ),
                      ),
                    )
                        : Container();
                  },
                )),
          ),
        ])));
  }
}

class CountryCard extends StatelessWidget {
  final int country;

  const CountryCard({Key key, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
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
                        WMapResponse[country]["country"].toString(),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 26, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                          NumberFormat.decimalPattern()
                              .format(int.parse(getWorldwide("todayCases"))),
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
                              .format(int.parse(getWorldwide("cases"))),
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
                              .format(int.parse(getWorldwide("active"))),
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
                              .format(int.parse(getWorldwide("recovered"))),
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
                              .format(int.parse(getWorldwide("todayDeaths"))),
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
                              .format(int.parse(getWorldwide("deaths"))),
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
    );
  }

  String getWorldwide(String item) {
    if (WMapResponse[country] == null) {
      return 0.toString();
    } else if (WMapResponse[country][item] == null) {
      return 0.toString();
    } else {
      return WMapResponse[country][item].toString();
    }
  }
}

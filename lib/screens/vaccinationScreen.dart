import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/constants.dart';
import 'package:covidapp/main.dart';
import 'package:covidapp/screens/homeScreen.dart';
import 'package:covidapp/screens/registerVaccinationScreen.dart';
import 'package:covidapp/screens/vaccinationDistrictScreen.dart';
import 'package:covidapp/screens/vaccinationIndiaScreen.dart';
import 'package:covidapp/screens/vaccinationStateScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class VaccinationScreen extends StatefulWidget {
  const VaccinationScreen({Key key}) : super(key: key);

  @override
  _VaccinationScreenState createState() => _VaccinationScreenState();
}

class _VaccinationScreenState extends State<VaccinationScreen> {
  final adVaccination1 = NativeAdmobController();
  final adVaccination2 = NativeAdmobController();

  bool loadedVaccination1 = false;
  bool loadedVaccination2 = false;

  StreamSubscription adVaccination1Subscription, adVaccination2Subscription;

  @override
  void initState() {
    adVaccination1Subscription =
        adVaccination1.stateChanged.listen(_onStateChanged1);
    adVaccination2Subscription =
        adVaccination2.stateChanged.listen(_onStateChanged2);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    adVaccination1Subscription.cancel();
    adVaccination2Subscription.cancel();

    adVaccination1.dispose();
    adVaccination2.dispose();

    super.dispose();
  }

  void _onStateChanged1(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedVaccination1 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccination1 = true;
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
          loadedVaccination2 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccination2 = true;
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

    DateTime _today = DateTime.now();
    String formatDate(DateTime x) {
      var outFormatter = new DateFormat('yyyy-MM-dd');
      return outFormatter.format(x);
    }

    Future<String> getDistrictVaccinated2(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/$userStateCode/districts/$userDistrict')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
                  data['total'] == null ||
                  data['total']['vaccinated2'] == null)
              ? 0.toString()
              : _returnValue = data['total']['vaccinated2'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> getDistrictVaccinated1(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/$userStateCode/districts/$userDistrict')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
              data['total'] == null ||
              data['total']['vaccinated1'] == null)
              ? 0.toString()
              : _returnValue = data['total']['vaccinated1'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> getDistricPopulation(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/$userStateCode/districts/$userDistrict')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
                  data['meta'] == null ||
                  data['meta']['population'] == null)
              ? 0.toString()
              : _returnValue = data['meta']['population'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> getStateVaccinated2(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/$userStateCode')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
                  data['total'] == null ||
                  data['total']['vaccinated2'] == null)
              ? 0.toString()
              : _returnValue = data['total']['vaccinated2'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> getStateVaccinated1(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/$userStateCode')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
              data['total'] == null ||
              data['total']['vaccinated1'] == null)
              ? 0.toString()
              : _returnValue = data['total']['vaccinated1'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> getStatePopulation(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/$userStateCode')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
                  data['meta'] == null ||
                  data['meta']['population'] == null)
              ? 0.toString()
              : _returnValue = data['meta']['population'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> getIndiaVaccinated2(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/TT')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
                  data['total'] == null ||
                  data['total']['vaccinated2'] == null)
              ? 0.toString()
              : _returnValue = data['total']['vaccinated2'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }
    Future<String> getIndiaVaccinated1(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/TT')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
              data['total'] == null ||
              data['total']['vaccinated1'] == null)
              ? 0.toString()
              : _returnValue = data['total']['vaccinated1'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> getIndiaPopulation(DateTime date) async {
      String _returnValue = "0";
      await FirebaseFirestore.instance
          .doc('${formatdate(date)}/TT')
          .get()
          .then((documentSnapshot) {
        Map<String, dynamic> data = documentSnapshot.data();
        if (documentSnapshot.exists) {
          _returnValue = (data == null ||
                  data['meta'] == null ||
                  data['meta']['population'] == null)
              ? 0.toString()
              : _returnValue = data['meta']['population'].toString();
        } else {
          _returnValue = 0.toString();
        }
      });
      return _returnValue;
    }

    Future<String> peoplePercent(String gds) async {
      if (gds == "getDistrictVaccinated2") {
        if (await getDistrictVaccinated2(_today) == "0") {
          if (await getDistrictVaccinated2(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getDistrictVaccinated2(
                _today.subtract(Duration(days: 1)));
          }
        } else {
          return await getDistrictVaccinated2(_today);
        }
      }
      if (gds == "getDistrictVaccinated1") {
        if (await getDistrictVaccinated1(_today) == "0") {
          if (await getDistrictVaccinated1(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getDistrictVaccinated1(
                _today.subtract(Duration(days: 1)));
          }
        } else {
          return await getDistrictVaccinated1(_today);
        }
      }
      if (gds == "getDistricPopulation") {
        if (await getDistricPopulation(_today) == "0") {
          if (await getDistricPopulation(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getDistricPopulation(
                _today.subtract(Duration(days: 1)));
          }
        } else {
          return await getDistricPopulation(_today);
        }
      }
      if (gds == "getStateVaccinated2") {
        if (await getStateVaccinated2(_today) == "0") {
          if (await getStateVaccinated2(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getStateVaccinated2(_today.subtract(Duration(days: 1)));
          }
        } else {
          return await getStateVaccinated2(_today);
        }
      }
      if (gds == "getStateVaccinated1") {
        if (await getStateVaccinated1(_today) == "0") {
          if (await getStateVaccinated1(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getStateVaccinated1(_today.subtract(Duration(days: 1)));
          }
        } else {
          return await getStateVaccinated1(_today);
        }
      }
      if (gds == "getStatePopulation") {
        if (await getStatePopulation(_today) == "0") {
          if (await getStatePopulation(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getStatePopulation(_today.subtract(Duration(days: 1)));
          }
        } else {
          return await getStatePopulation(_today);
        }
      }
      if (gds == "getIndiaVaccinated2") {
        if (await getIndiaVaccinated2(_today) == "0") {
          if (await getIndiaVaccinated2(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getIndiaVaccinated2(_today.subtract(Duration(days: 1)));
          }
        } else {
          return await getIndiaVaccinated2(_today);
        }
      }
      if (gds == "getIndiaVaccinated1") {
        if (await getIndiaVaccinated1(_today) == "0") {
          if (await getIndiaVaccinated1(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getIndiaVaccinated1(_today.subtract(Duration(days: 1)));
          }
        } else {
          return await getIndiaVaccinated1(_today);
        }
      }
      if (gds == "getIndiaPopulation") {
        if (await getIndiaPopulation(_today) == "0") {
          if (await getIndiaPopulation(_today.subtract(Duration(days: 1))) ==
              "0") {
            return 0.toString();
          } else {
            return await getIndiaPopulation(_today.subtract(Duration(days: 1)));
          }
        } else {
          return await getIndiaPopulation(_today);
        }
      }
    }

    Future<double> getDistrictPercent1() async {
      double percent;
      String vaccinated = await peoplePercent("getDistrictVaccinated1");
      int vaccinatedinInt = int.parse(vaccinated);
      String population = await peoplePercent("getDistricPopulation");
      int populationinInt = int.parse(population);
      percent = vaccinatedinInt == 0 || populationinInt == 0
          ? 0
          : (vaccinatedinInt / populationinInt);
      return percent;
    }

    Future<double> getStatePercent1() async {
      double percent;
      String vaccinated = await peoplePercent("getStateVaccinated1");
      int vaccinatedinInt = int.parse(vaccinated);
      String population = await peoplePercent("getStatePopulation");
      int populationinInt = int.parse(population);
      percent = vaccinatedinInt == 0 || populationinInt == 0
          ? 0
          : (vaccinatedinInt / populationinInt);
      return percent;
    }

    Future<double> getIndiaPercent1() async {
      double percent;
      String vaccinated = await peoplePercent("getIndiaVaccinated1");
      int vaccinatedinInt = int.parse(vaccinated);
      String population = await peoplePercent("getIndiaPopulation");
      int populationinInt = int.parse(population);
      percent = vaccinatedinInt == 0 || populationinInt == 0
          ? 0
          : (vaccinatedinInt / populationinInt);
      return percent;
    }

    Future<double> getDistrictPercent2() async {
      double percent;
      String vaccinated = await peoplePercent("getDistrictVaccinated2");
      int vaccinatedinInt = int.parse(vaccinated);
      String population = await peoplePercent("getDistricPopulation");
      int populationinInt = int.parse(population);
      percent = vaccinatedinInt == 0 || populationinInt == 0
          ? 0
          : (vaccinatedinInt / populationinInt);
      return percent;
    }

    Future<double> getStatePercent2() async {
      double percent;
      String vaccinated = await peoplePercent("getStateVaccinated2");
      int vaccinatedinInt = int.parse(vaccinated);
      String population = await peoplePercent("getStatePopulation");
      int populationinInt = int.parse(population);
      percent = vaccinatedinInt == 0 || populationinInt == 0
          ? 0
          : (vaccinatedinInt / populationinInt);
      return percent;
    }

    Future<double> getIndiaPercent2() async {
      double percent;
      String vaccinated = await peoplePercent("getIndiaVaccinated2");
      int vaccinatedinInt = int.parse(vaccinated);
      String population = await peoplePercent("getIndiaPopulation");
      int populationinInt = int.parse(population);
      percent = vaccinatedinInt == 0 || populationinInt == 0
          ? 0
          : (vaccinatedinInt / populationinInt);
      return percent;
    }

    Future<Map> distictData() async {
      Map abc = {
        "percent1": await getDistrictPercent1(),
        "percent2": await getDistrictPercent2(),

        "vaccinated": await peoplePercent("getDistrictVaccinated2")
      };
      return abc;
    }

    Future<Map> stateData() async {
      Map abc = {
        "percent1": await getStatePercent1(),
        "percent2": await getStatePercent2(),

        "vaccinated": await peoplePercent("getStateVaccinated2")
      };
      return abc;
    }

    Future<Map> indiaData() async {
      Map abc = {
        "percent1": await getIndiaPercent1(),
        "percent2": await getIndiaPercent2(),


        "vaccinated": await peoplePercent("getIndiaVaccinated2")
      };
      return abc;
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgGrey,
          elevation: 0,
          title: Text("Vaccination"),
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  FutureBuilder(
                      future: distictData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PercentageCard(
                            percentage1: snapshot.data["percent1"],
                            percentage2: snapshot.data["percent2"],

                            name: "$userDistrict",
                            totalVaccinated: snapshot.data["vaccinated"],
                            page: VaccinationDistrictScreen(
                              state: "$userStateCode",
                              district: "$userDistrict",
                            ),
                          );
                        }
                        if (snapshot.hasError) {
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
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: stateData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PercentageCard(
                            percentage1: snapshot.data["percent1"],
                            percentage2: snapshot.data["percent2"],

                            totalVaccinated: snapshot.data["vaccinated"],
                            name: "$userState",
                            page: VaccinationStateScreen(
                              stateCode: "$userStateCode",
                              stateName: "$userState",
                            ),
                          );
                        }
                        if (snapshot.hasError) {
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
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: indiaData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return PercentageCard(
                            percentage1: snapshot.data["percent1"],
                            percentage2: snapshot.data["percent2"],

                            totalVaccinated: snapshot.data["vaccinated"],
                            name: "India",
                            page: VaccinationIndiaScreen(),
                          );
                        }
                        if (snapshot.hasError) {
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
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: !loadedVaccination1 ? 0 : maxHeight * 0.5,
                    decoration: BoxDecoration(
                      color: bgGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: NativeAdmob(
                        adUnitID: 'ca-app-pub-3940256099942544/3986624511',
                        controller: adVaccination1,
                        type: NativeAdmobType.full,
                        loading: Container(),
                        error: Text("error"),
                        options: NativeAdmobOptions(
                            showMediaContent: true,
                            ratingColor: primaryRed,
                            callToActionStyle:
                                NativeTextStyle(backgroundColor: primaryRed)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RegisterVaccinationScreen()));
                    },
                    child: Container(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: primaryRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: new SvgPicture.asset(
                                  'assets/icons/edit.svg',
                                  height: 35,
                                  width: 35,
                                  color: Colors.white,

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "REGISTER",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "for Vaccination",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: !loadedVaccination2 ? 0 : maxHeight * 0.2,
                    decoration: BoxDecoration(
                      color: primaryRed,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: NativeAdmob(
                        adUnitID: 'ca-app-pub-3940256099942544/3986624511',
                        controller: adVaccination2,
                        type: NativeAdmobType.full,
                        loading: Container(),
                        error: Text("error"),
                        options: NativeAdmobOptions(
                            showMediaContent: false,
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: maxHeight * 0.20,
                    child: Row(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 16),
                                    child: Icon(
                                      Icons.download_rounded,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "DOWNLOAD",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "Certificate",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 16),
                                    child: Icon(
                                      Icons.article,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                  Text(
                                    "NEWS",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }
}

class PercentageCard extends StatelessWidget {
  const PercentageCard({
    Key key,
    this.totalVaccinated,
    this.name,
    this.page, this.percentage1, this.percentage2,
  }) : super(key: key);

  final String totalVaccinated;
  final double percentage1;
  final double percentage2;

  final String name;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
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
                    top: 16.0, left: 10, bottom: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
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
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8, bottom: 16, left: 12),
                      child: Column(
                        children: [
                          new CircularPercentIndicator(
                            radius: 80.0,
                            lineWidth: 15.0,
                            percent: percentage1,
                            center: new Text(
                              "${(percentage1 * 100).toStringAsFixed(1)}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                  fontSize: 12),
                            ),
                            progressColor: primaryRed,
                            backgroundColor: iconGrey,
                            circularStrokeCap: CircularStrokeCap.butt,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Dose 1"),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 8, bottom: 16),
                      child: Column(
                        children: [
                          new CircularPercentIndicator(
                            radius: 80.0,
                            lineWidth: 15.0,
                            percent: percentage2,
                            center: new Text(
                              "${(percentage2 * 100).toStringAsFixed(1)}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                  fontSize: 12),
                            ),
                            progressColor: primaryRed,
                            backgroundColor: iconGrey,
                            circularStrokeCap: CircularStrokeCap.butt,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Dose 2"),
                          )

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Vaccinated both",
                            style: TextStyle(fontSize: 14, color: primaryText),
                          ),
                          Text(
                            NumberFormat.decimalPattern()
                                .format(int.parse(totalVaccinated)),
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
          )),
    );
  }
}

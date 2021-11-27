import 'dart:async';

import 'package:covidapp/constants.dart';
import 'package:covidapp/districtCodeList.dart';
import 'package:covidapp/districtList.dart';
import 'package:covidapp/screens/boardingScreen.dart';
import 'package:covidapp/screens/homeScreen.dart';
import 'package:covidapp/screens/slotDisplayScreen.dart';
import 'package:covidapp/statesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class RegisterVaccinationScreen extends StatefulWidget {
  const RegisterVaccinationScreen({Key key}) : super(key: key);

  @override
  _RegisterVaccinationScreenState createState() =>
      _RegisterVaccinationScreenState();
}

class _RegisterVaccinationScreenState extends State<RegisterVaccinationScreen> {
  String _selectedState = userState;
  String selectedStateCode=userStateCode;
  String selectedDistrictCode=userDistrictCode;
  String ageGroupValue;
  String doseValue;
  final myController = TextEditingController();


  final adVaccinationRegister1 = NativeAdmobController();
  final adVaccinationRegister2 = NativeAdmobController();
  final adVaccinationRegister3 = NativeAdmobController();
  final adVaccinationRegister4 = NativeAdmobController();

  bool loadedVaccinationRegister1 = false;
  bool loadedVaccinationRegister2 = false;
  bool loadedVaccinationRegister3 = false;
  bool loadedVaccinationRegister4 = false;

  StreamSubscription adVaccinationRegister1Subscription, adVaccinationRegister2Subscription,adVaccinationRegister3Subscription, adVaccinationRegister4Subscription;

  @override
  void initState() {
    adVaccinationRegister1Subscription =
        adVaccinationRegister1.stateChanged.listen(_onStateChanged1);
    adVaccinationRegister2Subscription =
        adVaccinationRegister2.stateChanged.listen(_onStateChanged2);
    adVaccinationRegister3Subscription =
        adVaccinationRegister3.stateChanged.listen(_onStateChanged3);
    adVaccinationRegister4Subscription =
        adVaccinationRegister4.stateChanged.listen(_onStateChanged4);

    // TODO: implement initState
    super.initState();
  }



  void _onStateChanged1(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedVaccinationRegister1 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccinationRegister1 = true;
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
          loadedVaccinationRegister2 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccinationRegister2 = true;
        });
        break;

      default:
        break;
    }
  }
  void _onStateChanged3(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedVaccinationRegister3 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccinationRegister3 = true;
        });
        break;

      default:
        break;
    }
  }
  void _onStateChanged4(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedVaccinationRegister4 = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccinationRegister4 = true;
        });
        break;

      default:
        break;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    adVaccinationRegister1Subscription.cancel();
    adVaccinationRegister2Subscription.cancel();

    adVaccinationRegister1.dispose();
    adVaccinationRegister2.dispose();
    adVaccinationRegister3.dispose();
    adVaccinationRegister4.dispose();
    super.dispose();
  }

  String _selectedDistrict = userDistrict;

  List<DistrictCodeList> getDistrictList() {
    if (selectedStateCode == "AN") {
      return ANList;
    } else if (selectedStateCode == "AP") {
      return APList;
    } else if (selectedStateCode == "AR") {
      return ARList;
    } else if (selectedStateCode == "AS") {
      return ASList;
    } else if (selectedStateCode == "BR") {
      return BRList;
    } else if (selectedStateCode == "CH") {
      return CHList;
    } else if (selectedStateCode == "CT") {
      return CTList;
    } else if (selectedStateCode == "DL") {
      return DLList;
    } else if (selectedStateCode == "DN") {
      return DNList;
    } else if (selectedStateCode == "GA") {
      return GAList;
    } else if (selectedStateCode == "GJ") {
      return GJList;
    } else if (selectedStateCode == "HP") {
      return HPList;
    } else if (selectedStateCode == "HR") {
      return HRList;
    } else if (selectedStateCode == "JH") {
      return JHList;
    } else if (selectedStateCode == "JK") {
      return JKList;
    } else if (selectedStateCode == "KA") {
      return KAList;
    } else if (selectedStateCode == "KL") {
      return KLList;
    } else if (selectedStateCode == "LA") {
      return LAList;
    } else if (selectedStateCode == "LD") {
      return LDList;
    } else if (selectedStateCode == "MH") {
      return MHList;
    } else if (selectedStateCode == "ML") {
      return MLList;
    } else if (selectedStateCode == "MN") {
      return MNList;
    } else if (selectedStateCode == "MP") {
      return MPList;
    } else if (selectedStateCode == "MZ") {
      return MZList;
    } else if (selectedStateCode == "NL") {
      return NLList;
    } else if (selectedStateCode == "OR") {
      return ORList;
    } else if (selectedStateCode == "PB") {
      return PBList;
    } else if (selectedStateCode == "PY") {
      return PYList;
    } else if (selectedStateCode == "RJ") {
      return RJList;
    } else if (selectedStateCode == "SK") {
      return SKList;
    } else if (selectedStateCode == "TG") {
      return TGList;
    } else if (selectedStateCode == "TN") {
      return TNList;
    } else if (selectedStateCode == "TR") {
      return TRList;
    } else if (selectedStateCode == "UP") {
      return UPList;
    } else if (selectedStateCode == "UT") {
      return UTList;
    } else if (selectedStateCode == "WB") {
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
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: bgGrey,
            elevation: 0,
            title: Text("Register"),
            bottom: const TabBar(
              indicatorColor: primaryRed,

              labelColor: primaryRed,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              unselectedLabelColor: primaryText,
              tabs: [
                Tab(
                  text: "Search by PIN Code",
                ),
                Tab(
                  text: "Search by District",
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),

              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          height: !loadedVaccinationRegister1?0:maxHeight * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: NativeAdmob(
                              adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                              controller: adVaccinationRegister1,
                              type: NativeAdmobType.full,
                              loading: Container(),
                              error: Text("error"),


                              options: NativeAdmobOptions(showMediaContent: false,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed) ),


                            ),
                          ),

                        ),
                      )
                      ,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Wrap(
                            children: [
                              TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now().add(Duration(days: 30)),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("PIN Code",
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: myController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(left: 16),
                              hintText: "Enter your PIN Code"),
                          style: TextStyle(fontSize: 12),


                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Age Group",
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: "18-44",
                                activeColor: Color(0xFF5C6BC0),
                                groupValue: ageGroupValue,
                                onChanged: (value) {
                                  ageGroupValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("18-44",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "45+",
                                activeColor: Color(0xFF5C6BC0),
                                groupValue: ageGroupValue,
                                onChanged: (value) {
                                  ageGroupValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("45+",style: TextStyle(fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Dose",
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: "Dose1",
                                activeColor: Color(0xFF5C6BC0),
                                groupValue: doseValue,
                                onChanged: (value) {
                                  doseValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("Dose 1",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Color(0xFF5C6BC0),
                                value: "Dose2",
                                groupValue: doseValue,
                                onChanged: (value) {
                                  doseValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("Dose 2",style: TextStyle(fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (myController.text == "") {
                            showErrorPage("Please enter a valid PIN Code");
                          } else if ((myController.text.length) < 6) {
                            showErrorPage("Please enter a valid PIN Code");
                          } else if (ageGroupValue == null) {
                            showErrorPage("Please select your age group");
                          } else if (doseValue == null) {
                            showErrorPage("Please select your dose");
                          } else
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SlotDisplayScreen(
                                          pincode: myController.text,
                                          ageGroup: ageGroupValue,
                                          date: _selectedDay,
                                          dose: doseValue,
                                          page: "pincode",
                                        )));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: primaryRed),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Check availability",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          width: double.infinity,
                          height: !loadedVaccinationRegister2?0:maxHeight * 0.5,
                          decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: NativeAdmob(
                              adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                              controller: adVaccinationRegister2,
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
                      SizedBox(height: 10,),
                    ],

                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),

              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          height: !loadedVaccinationRegister3?0:maxHeight * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: NativeAdmob(
                              adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                              controller: adVaccinationRegister3,
                              type: NativeAdmobType.full,
                              loading: Container(),
                              error: Text("error"),


                              options: NativeAdmobOptions(showMediaContent: false,ratingColor: primaryRed,callToActionStyle: NativeTextStyle(backgroundColor: primaryRed) ),


                            ),
                          ),

                        ),
                      )
                      ,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Wrap(
                            children: [
                              TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now().add(Duration(days: 30)),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("State",
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => selectNewState(),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(_selectedState,style: TextStyle(fontSize: 12),),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("District",
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () =>selectNewDistrict(),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text('$_selectedDistrict',style: TextStyle(fontSize: 12),),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Age Group",
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: "18-44",
                                activeColor: Color(0xFF5C6BC0),
                                groupValue: ageGroupValue,
                                onChanged: (value) {
                                  ageGroupValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("18-44",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "45+",
                                activeColor: Color(0xFF5C6BC0),
                                groupValue: ageGroupValue,
                                onChanged: (value) {
                                  ageGroupValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("45+",style: TextStyle(fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Dose",
                                style: TextStyle(
                                    color: primaryText,
                                    fontWeight: FontWeight.w600))),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: "Dose1",
                                activeColor: Color(0xFF5C6BC0),
                                groupValue: doseValue,
                                onChanged: (value) {
                                  doseValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("Dose 1",style: TextStyle(fontSize: 12),)
                            ],
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Row(
                            children: [
                              Radio(
                                activeColor: Color(0xFF5C6BC0),
                                value: "Dose2",
                                groupValue: doseValue,
                                onChanged: (value) {
                                  doseValue = value;
                                  setState(() {});
                                },
                              ),
                              Text("Dose 2",style: TextStyle(fontSize: 12),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_selectedState == "Select your State") {
                            showErrorPage("Please select your State");
                          } else if (_selectedDistrict ==
                              "Select your District") {
                            showErrorPage("Please select your District");
                          } else if (ageGroupValue == null) {
                            showErrorPage("Please select your age group");
                          } else if (doseValue == null) {
                            showErrorPage("Please select your dose");
                          }else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SlotDisplayScreen(
                                          districtCode: selectedDistrictCode,
                                          ageGroup: ageGroupValue,
                                          dose: doseValue,
                                          date: _selectedDay,
                                          page: "district",
                                        )));
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: primaryRed),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Check availability",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          width: double.infinity,
                          height: !loadedVaccinationRegister4?0:maxHeight * 0.5,
                          decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: NativeAdmob(
                              adUnitID: 'ca-app-pub-3940256099942544/3986624511',

                              controller: adVaccinationRegister4,
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
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          ])),
    );
  }

  void selectNewState() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Select Your State",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                          fontSize: 20)),
                ),
                Container(
                    width: double.infinity,
                    child: new ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stateList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new StateCard(
                              state: stateList[index],
                              onTap: () {
                                changeState(stateList[index]);
                              },
                            ),
                          );
                        })),
              ],
            ),
          );
        });
  }

  void showErrorPage(String errorMessage) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: primaryRed,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(errorMessage,style: TextStyle(fontSize: 12),),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: primaryRed),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ]);
        });
  }

  void selectNewDistrict() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Select Your District",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                          fontSize: 20)),
                ),
                Container(
                    width: double.infinity,
                    child: new ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: getDistrictList().length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new DistrictCard(
                              district: getDistrictList()[index].districtName,
                              onTap: () {
                                changeDistrict(
                                    getDistrictList()[index].districtName,
                                    getDistrictList()[index].districtCode);
                              },
                            ),
                          );
                        })),
              ],
            ),
          );
        });
  }

  void changeState(StateList name) {
    Navigator.pop(context);

    setState(() {
      _selectedState = name.stateName;
      _selectedDistrict = "Select your District";
      selectedStateCode = name.stateCode;
    });
  }

  void changeDistrict(String name, String code) {
    Navigator.pop(context);

    setState(() {
      _selectedDistrict = name;
      selectedDistrictCode = code;
    });
  }
}

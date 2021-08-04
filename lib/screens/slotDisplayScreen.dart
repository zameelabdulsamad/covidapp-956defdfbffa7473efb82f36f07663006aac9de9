import 'dart:async';
import 'dart:convert';

import 'package:covidapp/constants.dart';
import 'package:covidapp/screens/cowinAppScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class SlotDisplayScreen extends StatefulWidget {
  final String districtCode;
  final String pincode;
  final String ageGroup;
  final String dose;
  final String page;
  final DateTime date;

  SlotDisplayScreen(
      {Key key, this.districtCode, this.ageGroup, this.dose, this.page, this.pincode, this.date})
      : super(key: key);

  @override
  _SlotDisplayScreenState createState() => _SlotDisplayScreenState();
}

Map slotResponse;
List slotListResponse=[];
bool download=false;

class _SlotDisplayScreenState extends State<SlotDisplayScreen> {
  final adVaccinationSlot = NativeAdmobController();

  bool loadedVaccinationSlot = false;

  StreamSubscription adVaccinationSlotSubscription;


  @override
  void dispose() {
    adVaccinationSlotSubscription.cancel();

    adVaccinationSlot.dispose();

    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          loadedVaccinationSlot = false;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          loadedVaccinationSlot = true;
        });
        break;

      default:
        break;
    }
  }



  String formatToday(DateTime day) {
    var outFormatter = new DateFormat('dd-MM-yyyy');
    return outFormatter.format(day);
  }


  Future fetchData() async {
    http.Response response1;
    var url = Uri.parse(
        "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=${widget.districtCode}&date=${formatToday(widget.date)}");
    response1 = await http.get(url, headers: {
      "accept": "application/json",
      "Accept-Language": "hi_IN",
    });

    print(response1.statusCode);

    if (response1.statusCode == 200) {
      setState(() {
        slotResponse = json.decode(response1.body);
        slotListResponse = slotResponse["sessions"];
        download=true;
      });
    }
  }

  Future fetchData1() async {
    http.Response response1;
    var url = Uri.parse(
        "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=${widget.pincode}&date=${formatToday(widget.date)}");
    response1 = await http.get(url, headers: {
      "accept": "application/json",
      "Accept-Language": "hi_IN",
    });

    print(response1.statusCode);

    if (response1.statusCode == 200) {
      setState(() {
        slotResponse = json.decode(response1.body);
        slotListResponse = slotResponse["sessions"];
        download=true;
      });
    }
  }

  @override
  void initState() {
    if(widget.page=="pincode"){
      fetchData1();
    }
    else
      fetchData();

    adVaccinationSlotSubscription =
        adVaccinationSlot.stateChanged.listen(_onStateChanged);

    // TODO: implement initState
    super.initState();
  }

  List dosetwoagefortyfive() {
    List a = [];
    for (int i = 0; i < slotListResponse.length; i++) {
      if (slotListResponse[i]["min_age_limit"] == 45 &&
          slotListResponse[i]["available_capacity_dose2"] != 0) {
        a.add(slotListResponse[i]);
      }
    }
    return a;
  }

  List doseoneagefortyfive() {
    List a = [];
    for (int i = 0; i < slotListResponse.length; i++) {
      if (slotListResponse[i]["min_age_limit"] == 45 &&
          slotListResponse[i]["available_capacity_dose1"] != 0) {
        a.add(slotListResponse[i]);
      }
    }
    return a;
  }

  List doseoneageeighteen() {
    List a = [];
    for (int i = 0; i < slotListResponse.length; i++) {
      if ((slotListResponse[i]["min_age_limit"] == 18 || slotListResponse[i]["min_age_limit"] == 40)&&
          slotListResponse[i]["available_capacity_dose1"] != 0) {
        a.add(slotListResponse[i]);
      }
    }
    return a;
  }

  List dosetwoageeighteen() {
    List a = [];
    for (int i = 0; i < slotListResponse.length; i++) {
      if ((slotListResponse[i]["min_age_limit"] == 18 || slotListResponse[i]["min_age_limit"] == 40)&&
          slotListResponse[i]["available_capacity_dose2"] != 0) {
        a.add(slotListResponse[i]);
      }
    }
    return a;
  }

  List slotList() {
    if (widget.dose == "Dose1" && widget.ageGroup == "18-44")
      return doseoneageeighteen();
    else if (widget.dose == "Dose2" && widget.ageGroup == "18-44")
      return dosetwoageeighteen();
    else if (widget.dose == "Dose1" && widget.ageGroup == "45+")
      return doseoneagefortyfive();
    else if (widget.dose == "Dose2" && widget.ageGroup == "45+")
      return dosetwoagefortyfive();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;



    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgGrey,
          elevation: 0,
          title: Text("Slots for ${widget.dose}"),
        ),
        body: slotList().length==0&&download? Image(fit:BoxFit.fill,height:maxHeight,width:maxWidth,image: AssetImage('assets/icons/results.png')): SingleChildScrollView(
            physics: BouncingScrollPhysics(),

            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: !download?Column(
                children: [
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),
                  ShimmerWidget(maxHeight: maxHeight),

                ],
              ):new ListView.separated(
                  physics: NeverScrollableScrollPhysics(),

                  itemCount: slotList().length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new SlotCard(
                        name: slotList()[index]["name"],
                        fee: slotList()[index]["fee_type"] == "Free"
                            ? "Free"
                            : "₹${slotList()[index]["fee"]}",
                        capacity: widget.dose == "Dose1"
                            ? slotList()[index]["available_capacity_dose1"]
                                .toString()
                            : slotList()[index]["available_capacity_dose2"]
                                .toString(),
                        vaccine: slotList()[index]["vaccine"],
                        address: slotList()[index]["address"],
                        onTap: ()=>showCowinBottomSheet(slotList()[index]["name"], slotList()[index]["address"]),
                      ),
                    );
                  },
                separatorBuilder: (BuildContext context, int index) {
                  return index % 4 == 0
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: !loadedVaccinationSlot
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
                          controller: adVaccinationSlot,
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
                },),
            ),
          )
        ])));


  }
  void showCowinBottomSheet(String name,String address){
    showModalBottomSheet(context: context, builder: (context){
      return Wrap(
          children: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:10.0,top: 10),
                    child: Align(alignment:Alignment.topLeft,child: Text(name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),

                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Align(alignment:Alignment.topLeft,child: Text(address,style: TextStyle(fontSize: 14),)),

                  ),
                  SizedBox(height: 30,),

                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
                    child: Text("You will be taken to the Co-Win Mini App to book your appointment",style: TextStyle(fontSize: 12),),

                  ),

                  SizedBox(height: 30,),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CowinAppScreen()));
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: primaryRed


                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Continue", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14), textAlign: TextAlign.center,),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],

              ),
            ),
          ),
          ]
      );

    });
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    Key key,
    @required this.maxHeight,
  }) : super(key: key);

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: shimmerbasecolor,
        highlightColor: shimmerhighlightcolor,
        child: Container(
          height: maxHeight*0.15,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class SlotCard extends StatelessWidget {
  final String name;
  final String fee;
  final String capacity;
  final String vaccine;
  final String address;

  final VoidCallback onTap;

  const SlotCard(
      {Key key,
      this.onTap,
      this.name,
      this.fee,
      this.capacity,
      this.vaccine,
      this.address})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery
        .of(context)
        .size
        .height;
    double maxWidth = MediaQuery
        .of(context)
        .size
        .width;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: bgGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width:maxWidth*0.5,


                              child: Text(
                                name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                            Container(
                                width:maxWidth*0.5,child: Text(address,style: TextStyle(
                                 fontSize: 12),)),

                          ],
                        ),
                        Text(fee,
                            style:
                                TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryRed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            vaccine,
                            style: TextStyle(color: primaryRed,fontSize: 10),
                          ),
                        )),

                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: returnColor(int.parse(capacity)),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom:8,top: 8,left: 16),
                      child: Text(
                        "$capacity left",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),


                  ],
                )

              )
            ],
          ),

        ),
      ),
    );
  }
}

Color returnColor(int capacity) {
  if(capacity<10){
    return primaryRed;
  }
  else if(capacity<20){
    return cardYellow;
  }
  else
    return cardGreen;
}

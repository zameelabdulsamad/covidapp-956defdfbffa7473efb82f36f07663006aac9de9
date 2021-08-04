import 'package:covidapp/constants.dart';
import 'package:covidapp/districtList.dart';
import 'package:covidapp/screens/boardingScreen.dart';
import 'package:covidapp/screens/homeScreen.dart';
import 'package:covidapp/statesList.dart';
import 'package:covidapp/userPrefs.dart';
import 'package:flutter/material.dart';
class ChangeUserLocation extends StatefulWidget {
  const ChangeUserLocation({Key key}) : super(key: key);

  @override
  _ChangeUserLocationState createState() => _ChangeUserLocationState();
}

String _selectedState = "Select your State";
String _selectedDistrict="Select your District";
String selectedStateCode;
String selectedDistrictCode;
List<DistrictCodeList> getDistrictList() {
  if (selectedStateCode == "AN") {
    return ANList;
  }
  else if (selectedStateCode == "AP") {
    return APList;
  }
  else if (selectedStateCode == "AR") {
    return ARList;
  }
  else if (selectedStateCode == "AS") {
    return ASList;
  }
  else if (selectedStateCode == "BR") {
    return BRList;
  }
  else if (selectedStateCode == "CH") {
    return CHList;
  }
  else if (selectedStateCode == "CT") {
    return CTList;
  }
  else if (selectedStateCode == "DL") {
    return DLList;
  }
  else if (selectedStateCode == "DN") {
    return DNList;
  }
  else if (selectedStateCode == "GA") {
    return GAList;
  }
  else if (selectedStateCode == "GJ") {
    return GJList;
  }
  else if (selectedStateCode == "HP") {
    return HPList;
  }
  else if (selectedStateCode == "HR") {
    return HRList;
  }
  else if (selectedStateCode == "JH") {
    return JHList;
  }
  else if (selectedStateCode == "JK") {
    return JKList;
  }
  else if (selectedStateCode == "KA") {
    return KAList;
  }
  else if (selectedStateCode == "KL") {
    return KLList;
  }
  else if (selectedStateCode == "LA") {
    return LAList;
  }
  else if (selectedStateCode == "LD") {
    return LDList;
  }
  else if (selectedStateCode == "MH") {
    return MHList;
  }
  else if (selectedStateCode == "ML") {
    return MLList;
  }
  else if (selectedStateCode == "MN") {
    return MNList;
  }
  else if (selectedStateCode == "MP") {
    return MPList;
  }
  else if (selectedStateCode == "MZ") {
    return MZList;
  }
  else if (selectedStateCode == "NL") {
    return NLList;
  }
  else if (selectedStateCode == "OR") {
    return ORList;
  }
  else if (selectedStateCode == "PB") {
    return PBList;
  }
  else if (selectedStateCode == "PY") {
    return PYList;
  }
  else if (selectedStateCode == "RJ") {
    return RJList;
  }
  else if (selectedStateCode == "SK") {
    return SKList;
  }
  else if (selectedStateCode == "TG") {
    return TGList;
  }
  else if (selectedStateCode == "TN") {
    return TNList;
  }
  else if (selectedStateCode == "TR") {
    return TRList;
  }
  else if (selectedStateCode == "UP") {
    return UPList;
  }
  else if (selectedStateCode == "UT") {
    return UTList;
  }
  else if (selectedStateCode == "WB") {
    return WBList;
  }
}

class _ChangeUserLocationState extends State<ChangeUserLocation> {
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:8,bottom: 8,left: 8,right: 8),
                child: Container(width: maxWidth*0.5,
                    child: Image(image: AssetImage('assets/icons/location.png'),)),
              ),
              Text("Select Your Location",style: TextStyle(color:primaryText,fontWeight: FontWeight.bold,fontSize: 24),),
              Text("You can change it later from the Home Page",style: TextStyle(color:primaryText,fontWeight: FontWeight.w400,fontSize: 16)),
              SizedBox(
                height: maxHeight*0.08,
              ),


              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(alignment: Alignment.topLeft, child: Text(
                    "State", style: TextStyle(
                    color: primaryText, fontWeight: FontWeight.w600))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => selectNewState(),
                  child: Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),

                        border: Border.all(
                            color: Colors.grey
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(_selectedState),
                          ),
                          Icon(Icons.keyboard_arrow_down_outlined,
                            color: Colors.grey,),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(alignment: Alignment.topLeft, child: Text(
                    "District", style: TextStyle(
                    color: primaryText, fontWeight: FontWeight.w600))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _selectedState == "Select your State"?print(""):selectNewDistrict(),

                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: Colors.grey
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text('$_selectedDistrict'),
                          ),
                          Icon(Icons.keyboard_arrow_down_outlined,
                            color: Colors.grey,),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () {
                  if(_selectedState == "Select your State"){
                    showErrorPage("Please select your State");


                  }
                  else if(_selectedDistrict=="Select your District"){
                    showErrorPage("Please select your District");
                  }
                  else{
                    UserPreferences().districtName=_selectedDistrict;
                    UserPreferences().districtCode=selectedDistrictCode;
                    UserPreferences().stateName=_selectedState;
                    UserPreferences().stateCode=selectedStateCode;




                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        HomeScreen()), (Route<dynamic> route) => false);

                  }

                },

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
                        fontSize: 16), textAlign: TextAlign.center,),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectNewState() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Select Your State",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                          fontSize: 26)),
                ),
                Container(
                    width: double.infinity,
                    child: new ListView.builder(
                        shrinkWrap: true,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemCount: stateList.length,
                        itemBuilder: (BuildContext context,
                            int index) {
                          return Padding(
                            padding:
                            const EdgeInsets.all(8.0),
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
  void showErrorPage(String errorMessage){
    showModalBottomSheet(context: context, builder: (context){
      return Wrap(
          children: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Icon(Icons.error_outline,size: 60,color: primaryRed,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(errorMessage),
                  ),
                  SizedBox(height: 30,),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {

                      });
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
                          child: Text("OK", style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16), textAlign: TextAlign.center,),
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

  void selectNewDistrict() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Select Your District",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                          fontSize: 26)),
                ),
                Container(
                    width: double.infinity,
                    child: new ListView.builder(
                        shrinkWrap: true,
                        physics:
                        const NeverScrollableScrollPhysics(),
                        itemCount: getDistrictList().length,
                        itemBuilder: (BuildContext context,
                            int index) {
                          return Padding(
                            padding:
                            const EdgeInsets.all(8.0),
                            child: new DistrictCard(
                              district: getDistrictList()[index].districtName,
                              onTap: () {
                                changeDistrict(getDistrictList()[index].districtName,getDistrictList()[index].districtCode);
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

  void changeDistrict(String name,String code) {
    Navigator.pop(context);


    setState(() {
      _selectedDistrict = name;
      selectedDistrictCode=code;
    });
  }
}

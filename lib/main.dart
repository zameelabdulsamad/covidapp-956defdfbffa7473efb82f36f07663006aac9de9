import 'dart:convert';

import 'package:covidapp/constants.dart';
import 'package:covidapp/screens/boardingScreen.dart';
import 'package:covidapp/screens/homeScreen.dart';
import 'package:covidapp/screens/newsScreen.dart';
import 'package:covidapp/userPrefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';



void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await UserPreferences().init();
  runApp(MyApp());


}
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

List WMapResponse;
bool download = false;

class _MyAppState extends State<MyApp> {

  Future fetchWorldData() async {
    http.Response response2;
    var url2 = Uri.parse("https://coronavirus-19-api.herokuapp.com/countries");
    response2 = await http.get(url2);


    print(response2.statusCode);

    if (response2.statusCode == 200) {
      setState(() {
        WMapResponse = json.decode(response2.body);
        download = true;
      });
    }
  }
  @override
  void initState() {
    fetchWorldData();


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Covid Point',
      theme: ThemeData(
        primaryColor: bgGrey,
        scaffoldBackgroundColor: bgWhite,
        textTheme: Theme.of(context).textTheme.apply(displayColor: primaryText),

      ),


      home: UserPreferences().districtName == null || UserPreferences().districtName == ""?BoardingScreen():HomeScreen(),
    );
  }
}


import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static final UserPreferences _instance =UserPreferences._ctor();
  factory UserPreferences(){
    return _instance;

  }
  UserPreferences._ctor();
  SharedPreferences _prefs;

  init() async{
    _prefs=await SharedPreferences.getInstance();
  }
  get stateName{
    return _prefs.getString('stateName')??'';
  }
  set stateName(String value){
    _prefs.setString('stateName', value);

  }

  get districtName{
    return _prefs.getString('districtName')??'';
  }
  set districtName(String value){
    _prefs.setString('districtName', value);

  }
  get districtCode{
    return _prefs.getString('districtCode')??'';
  }
  set districtCode(String value){
    _prefs.setString('districtCode', value);

  }
  get stateCode{
    return _prefs.getString('stateCode')??'';
  }
  set stateCode(String value){
    _prefs.setString('stateCode', value);

  }

}
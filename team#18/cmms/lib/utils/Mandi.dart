import 'package:shared_preferences/shared_preferences.dart';

class Mandi {
  //common strings
  static String appName = "Mandi";

  //pages titles
  static String profile = "Your profile";
  static String homePage = "Homepage";
  static String signIn = "Sign In";
  static String register = "Register Yourself";

  //common messages
  static String error = "Some Error occured";

  //prefs
  static String languagePref = "languagePref";
  static String namePref = "namePref";
  static String phonePref = "phonePref";
  static String districtPref = "districtPref";
  static String statePref = "statePref";

  static SharedPreferences pref;
}

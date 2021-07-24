//@dart=2.9
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferencesUserEmailKey = 'USEREMAILKEY';

  //saving data to SharedPreference

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserEmailKey, userEmail);
  }

  //getting data from sharedPreference

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    return await prefs.getString(sharedPreferencesUserEmailKey);
  }
}

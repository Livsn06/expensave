import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static String? _isOldUserID;

  static Future<void> setUserSession() async {
    _isOldUserID = DateTime.now().millisecondsSinceEpoch.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('isOldUserID', _isOldUserID!);
  }

  static Future<bool> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isOldUserID = prefs.getString('isOldUserID');
    return _isOldUserID == null;
  }

  static Future<void> removeUserSession() async {
    _isOldUserID = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isOldUserID');
  }
}

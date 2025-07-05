import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String keyUserId = 'userId';
  static const String keyNickname = 'nickname';

  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getUserId() {
    return _prefs.getString(keyUserId);
  }

  static Future<void> setUserId(String userId) async {
    await _prefs.setString(keyUserId, userId);
  }

  static String? getNickname() {
    return _prefs.getString(keyNickname);
  }

  static Future<void> setNickname(String nickname) async {
    await _prefs.setString(keyNickname, nickname);
  }
  
  static Future<void> removeUserData() async {
    await _prefs.remove(keyUserId);
    await _prefs.remove(keyNickname);
  }
}
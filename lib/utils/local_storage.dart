import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Bộ nhớ cục bộ
class LocalStorage {
  static final LocalStorage _instance = LocalStorage._();
  factory LocalStorage() => _instance;
  static late SharedPreferences _prefs;

  LocalStorage._();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs.setString(key, jsonString);
  }

  static dynamic getJSON(String key) {
    String? jsonString = _prefs.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  static Future<bool> setBool(String key, bool val) {
    return _prefs.setBool(key, val);
  }

  static bool getBool(String key) {
    bool? val = _prefs.getBool(key);
    return val ?? false;
  }

  static Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  //get và set String
  static Future<void> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  static String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  //get và set int
  static Future<void> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  static int getInt(String key) {
    return _prefs.getInt(key) ?? 0;
  }

  //clear
  static Future<void> clearAll() {
    return _prefs.clear();
  }

  //get và set list string
  static Future<void> setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    return _prefs.getStringList(key) ?? [];
  }
}

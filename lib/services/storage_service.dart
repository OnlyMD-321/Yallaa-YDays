import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception(
        'StorageService not initialized. Call initialize() first.',
      );
    }
    return _prefs!;
  }

  // String operations
  static Future<bool> setString(String key, String value) async {
    return await prefs.setString(key, value);
  }

  static String? getString(String key) {
    return prefs.getString(key);
  }

  // Int operations
  static Future<bool> setInt(String key, int value) async {
    return await prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return prefs.getInt(key);
  }

  // Bool operations
  static Future<bool> setBool(String key, bool value) async {
    return await prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return prefs.getBool(key);
  }

  // Double operations
  static Future<bool> setDouble(String key, double value) async {
    return await prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return prefs.getDouble(key);
  }

  // List operations
  static Future<bool> setStringList(String key, List<String> value) async {
    return await prefs.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return prefs.getStringList(key);
  }

  // JSON operations
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return await prefs.setString(key, json.encode(value));
  }

  static Map<String, dynamic>? getJson(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }

  // Remove operations
  static Future<bool> remove(String key) async {
    return await prefs.remove(key);
  }

  // Clear all
  static Future<bool> clear() async {
    return await prefs.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  // Get all keys
  static Set<String> getKeys() {
    return prefs.getKeys();
  }
}

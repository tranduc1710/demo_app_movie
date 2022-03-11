import 'package:shared_preferences/shared_preferences.dart';

import '../component/config/share_preferences.dart';
import 'base.dart';

class BSharedPreferences {
  static SharedPreferences? _pref;

  static Future<void> init() async => _pref == null ? _pref = await SharedPreferences.getInstance() : _pref;

  static dynamic get(ConfigSP key) => !_pref!.containsKey(enumValue(key)) ? null : _pref!.get(enumValue(key));

  static int? getInt(ConfigSP key) => !_pref!.containsKey(enumValue(key)) ? 0 : _pref!.getInt(enumValue(key));

  static bool? getBool(ConfigSP key) => !_pref!.containsKey(enumValue(key)) ? false : _pref!.getBool(enumValue(key));

  static double? getDouble(ConfigSP key) => !_pref!.containsKey(enumValue(key)) ? 0 : _pref!.getDouble(enumValue(key));

  static String? getString(ConfigSP key) => !_pref!.containsKey(enumValue(key)) ? "" : _pref!.getString(enumValue(key));

  static List<String>? getStringList(ConfigSP key) => !_pref!.containsKey(enumValue(key)) ? [] : _pref!.getStringList(enumValue(key));

  static Future<bool> setBool(ConfigSP key, bool value) async => await _pref!.setBool(enumValue(key), value);

  static Future<bool> setDouble(ConfigSP key, double value) async => await _pref!.setDouble(enumValue(key), value);

  static Future<bool> setInt(ConfigSP key, int value) async => await _pref!.setInt(enumValue(key), value);

  static Future<bool> setString(ConfigSP key, String value) async => await _pref!.setString(enumValue(key), value);

  static Future<bool> setStringList(ConfigSP key, List<String> value) async => await _pref!.setStringList(enumValue(key), value);

  static void clear() => _pref!.clear();

  static void reload() => _pref!.reload();

  static Set<String> getKeys() => _pref!.getKeys();

  static void remove(ConfigSP key) => _pref!.remove(enumValue(key));

  static void setObject<O>(O object, ConfigSP key) {
    setString(key, jsonEncode(object));
  }

  static Future<Map<String, dynamic>> getObject(ConfigSP key) async {
    var data = getString(key);
    return jsonDecode(data!);
  }
}

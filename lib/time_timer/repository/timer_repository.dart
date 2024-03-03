import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_study/time_timer/models/config_model.dart';
import 'package:flutter_study/time_timer/models/preset_model.dart';
import 'dart:convert';

class TimerRepository {
  final SharedPreferences _prefs;

  TimerRepository(this._prefs);

  Future<void> saveConfig(ConfigModel config) async {
    final jsonString = config.toJson();
    print('저장값 : ${jsonString}');
    await _prefs.setString('config', jsonString);
  }

  Future<ConfigModel?> getConfig() async {
    final jsonString = _prefs.getString('config');
    if (jsonString != null) {
      print('로딩 값 : ${jsonString}');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return ConfigModel.fromJson(jsonMap);
    } else {
      print('default 값 반환');
      return ConfigModel.fromJson(null);
    }
  }

  Future<void> clearConfig() async {
    await _prefs.remove('config');
  }


  Future<void> savePreset(PresetModel preset) async {
    final jsonString = preset.toJson();
    print('저장값 : ${jsonString}');
    await _prefs.setString('preset', jsonString);
  }

  Future<PresetModel?> getPreset() async {
    final jsonString = _prefs.getString('preset');
    if (jsonString != null) {
      print('로딩 값 : ${jsonString}');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      // print('제이슨 : ${jsonMap}');
      return PresetModel.fromJson(jsonMap);
    } else {
      print('default 값 반환');
      // return PresetModel.init();
      return PresetModel.fromJson(null);
    }
  }

  Future<void> clearPreset() async {
    await _prefs.remove('preset');
  }
}
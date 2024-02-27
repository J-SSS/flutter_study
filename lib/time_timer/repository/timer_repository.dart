import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_study/time_timer/models/timer_setup_model.dart';
import 'dart:convert';

class TimerRepository {
  final SharedPreferences _prefs;

  TimerRepository(this._prefs);

  Future<void> saveTimer(TimerSetup timer) async {
    final jsonString = timer.toJson().toString();
    await _prefs.setString('timer', jsonString);
  }

  Future<TimerSetup?> getTimer() async {
    final jsonString = _prefs.getString('timer');
    print('레포지토리'); // jdi
    if (jsonString != null) {
      print("정보찾기"); // jdi
      print(jsonString); // jdi
      // final Map<String, dynamic> json = Map<String, dynamic>.from(jsonString as Map);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return TimerSetup.fromJson(jsonMap);
    }
    return null;
  }

  Future<void> clearTimer() async {
    await _prefs.remove('timer');
  }
}
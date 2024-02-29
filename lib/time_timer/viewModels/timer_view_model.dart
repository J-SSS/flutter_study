import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/models/config_model.dart';
import 'package:flutter_study/time_timer/repository/timer_repository.dart';

class TimerViewModel extends ChangeNotifier {
  final TimerRepository _timerRepository;

  TimerViewModel(this._timerRepository);

  ConfigModel? _config;
  ConfigModel? get config => _config;

  Future<void> saveConfig(String id, String name) async {
    final newConfig = ConfigModel(id: id, name: name);
    await _timerRepository.saveConfig(newConfig);
    _config = newConfig;
    notifyListeners();
  }

  Future<void> loadConfig() async {
    final loadedConfig = await _timerRepository.getConfig();
    _config = loadedConfig;
    print('로드타이머 : ${loadedConfig}');
    notifyListeners();
  }

  Future<void> clearConfig() async {
    await _timerRepository.clearConfig();
    _config = null;
    notifyListeners();
  }
}
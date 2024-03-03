import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/models/config_model.dart';
import 'package:flutter_study/time_timer/models/preset_model.dart';
import 'package:flutter_study/time_timer/repository/timer_repository.dart';

class TimerViewModel extends ChangeNotifier {
  final TimerRepository _timerRepository;

  TimerViewModel(this._timerRepository);

  ConfigModel? _config;
  ConfigModel? get config => _config;

  PresetModel? _preset;
  PresetModel? get preset => _preset;

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

  Future<void> savePreset() async {
    final newPreset = PresetModel(preset: {});
    await _timerRepository.savePreset(newPreset);
    _preset = newPreset;
    notifyListeners();
  }

    Future<void> addPreset(String folderName) async {
      _preset!.preset?[UniqueKey().toString()]={'nodeName' : folderName};
      await _timerRepository.savePreset(_preset!);
      // _preset = newPreset;
      print('에드프리셋 : ${_preset}');
      // print('에드프리셋 : ${_preset?.toJson().toString()}');
      notifyListeners();
    }


  Future<void> loadPreset() async {
     final loadedPreset = await _timerRepository.getPreset();
    _preset = loadedPreset;
    print('로드프리셋 : ${loadedPreset}');
    print('로드프리셋 : ${loadedPreset?.preset}');
    notifyListeners();
  }

  Future<void> clearPreset() async {
    await _timerRepository.clearPreset();
    _preset = null;
    notifyListeners();
  }


}

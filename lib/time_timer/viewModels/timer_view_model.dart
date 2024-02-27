import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/models/timer_setup_model.dart';
import 'package:flutter_study/time_timer/repository/timer_repository.dart';

class TimerViewModel extends ChangeNotifier {
  final TimerRepository _timerRepository;

  TimerViewModel(this._timerRepository);

  TimerSetup? _timerSetup;
  TimerSetup? get user => _timerSetup;

  Future<void> saveUser(String id, String name) async {
    final newTimer = TimerSetup(id: id, name: name);
    await _timerRepository.saveTimer(newTimer);
    _timerSetup = newTimer;
    notifyListeners();
  }

  Future<void> loadTimer() async {
    final loadedTimer = await _timerRepository.getTimer();
    _timerSetup = loadedTimer;
    notifyListeners();
  }

  Future<void> clearTimer() async {
    await _timerRepository.clearTimer();
    _timerSetup = null;
    notifyListeners();
  }
}
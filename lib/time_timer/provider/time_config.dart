import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TimeConfigListener with ChangeNotifier {
  String timeType = 'M'; // min : 분, sec : 초

  int setupTime = 34;
  bool isPlaying = false;
  bool isPause = false;
  bool ableEdit = false;

  Offset clickPoint = Offset(0,0);

  var playBtn = 'btm_play';
  var loopBtn = 'btm_roop_1';

  set setPlayBtn(var btn) {
    this.playBtn = btn;
    notifyListeners();
  }

  set setSetupTime(int setupTime) {
    this.setupTime = setupTime;
    notifyListeners();
  }

  set setClickPoint(Offset clickPoint) {
    this.clickPoint = clickPoint;
    notifyListeners();
  }

  set setLoopBtn(var btn) {
    int currentSet = int.parse(this.loopBtn.split('_')[2]);
    if (currentSet != 4) {
      this.loopBtn = 'btm_roop_${currentSet + 1}';
    } else {
      this.loopBtn = 'btm_roop_1';
    }
    notifyListeners();
  }
}
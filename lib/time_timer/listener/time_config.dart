import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TimeConfigListener with ChangeNotifier {
  String timeType = 'M'; // min : 분, sec : 초

  int remainTime = 60;
  bool isPlaying = false;
  bool isPause = false;
  bool ableEdit = false;

  var playBtn = 'btm_play';
  var loopBtn = 'btm_roop_1';

  set setPlayBtn(var btn) {
    this.playBtn = btn;
    notifyListeners();
  }

  set setRemainTime(int remainTime) {
    this.remainTime = remainTime;
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
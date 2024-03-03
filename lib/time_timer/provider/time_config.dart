import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TimeConfigListener with ChangeNotifier {
  String timeType = 'M'; // min : 분, sec : 초

  int setupTime = 34;
  bool isPlaying = false;
  bool isPause = false;
  bool ableEdit = false;

  Offset clickPoint = Offset(0,0);

  var playBtn = 'btn_play';
  var loopBtn = 'btn_roop_none';

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
    String currentSet = this.loopBtn.split('_')[2];
    if (currentSet == 'none') {
      this.loopBtn = 'btn_roop_one';
    } else if(currentSet == 'one') {
      this.loopBtn = 'btn_roop_list';
    } else {
      this.loopBtn = 'btn_roop_none';
    }
    notifyListeners();
  }
}
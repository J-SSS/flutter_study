import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_study/main.dart';
import 'dart:isolate';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;


class TimerController extends ChangeNotifier {
  // isolate 변수
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  late Isolate _isolate;

  // ~isolate 변수

  // timer 변수
  int _setupTime = 34;
  int _remainTime = 34;
  String loopType = ''; // N : 반복 안함, O : 하나 반복, L : 목록 반복
  // ~timer 변수

  // 기타
  String playBtn = 'btn_play';
  String loopBtn = 'btn_roop_none';




  // ~기타

  bool isPause = false;
  String timeType = 'M'; // min : 분, sec : 초

  bool _isPlyaing = true; // 현재 작동중인지 여부

  bool get isPlaying => _isPlyaing;

  set setIsPlaying(bool value) => _isPlyaing = value;

  set setPlayBtn(var btn) {
    this.playBtn = btn;
    notifyListeners();
  }

  get setupTime => _setupTime;

  get remainTime => _remainTime;

  set setSetupTime(int setupTime) {
    this._setupTime = setupTime;
    this._remainTime = setupTime;
    notifyListeners();
  }

  // 안쓰는 것으로 추정
  bool ableEdit = false;
  Offset clickPoint = Offset(0, 0);

  set setClickPoint(Offset clickPoint) {
    this.clickPoint = clickPoint;
    notifyListeners();
  }

  // 안쓰는 것으로 추정

  /** 반복 버튼 아이콘 변경 */
  set setLoopBtn(var btn) {
    String currentSet = this.loopBtn.split('_')[2];
    if (currentSet == 'none') {
      this.loopBtn = 'btn_roop_one';
      this.loopType = 'O';
    } else if (currentSet == 'one') {
      this.loopBtn = 'btn_roop_list';
      this.loopType = 'L';
    } else {
      this.loopBtn = 'btn_roop_none';
      this.loopType = 'N';
    }
    notifyListeners();
  }

  TimerController() {
    AppManager.log('Isolate Timer Init');
    isolateTimerInit(); // isolate 생성
  }

  String msg = '기본값';

  void runTimer() {
    _sendPort.send({
      'cmd': 'run',
      'setupTime': setupTime,
      'callback': '',
    });
  }

  void cancelTimer() {
    _sendPort.send({
      'cmd': 'cancel',
      'callback': '',
    });
  }

  /** isolate 생성 & 메시지 수신시 처리 */
  isolateTimerInit() async {
    final ReceivePort receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_isolateTimer, receivePort.sendPort);
    receivePort.listen((msg) {
      if (msg is SendPort) {
        _sendPort = msg;
      } else {
        if (msg is Map && msg.containsKey('cmd')) {
          switch (msg['cmd']) {
            case ('run'):
              {
                _remainTime = msg['remainTime'];
              }
            case ('cancel'):
              {}
          }
        }
        notifyListeners();
      }
    });

    _isolate = isolate;
    _receivePort = receivePort;
  }

  void _isolateTimer(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    Timer? timer;
    int remainTime = 60;

    receivePort.listen((msg) {
      if (msg is Map && msg.containsKey('cmd')) {
        switch (msg['cmd']) {
          case ('run'):
            {
              if (timer == null || !timer!.isActive) {
                remainTime = msg['setupTime'].toInt();

                timer = Timer.periodic(Duration(seconds: 1), (timer) {
                  debugPrint('\x1B[33m[ ${--remainTime} 초  ]\x1B[0m');

                  sendPort.send({
                    'cmd': 'run',
                    'remainTime': remainTime,
                  });

                  if(remainTime < -1){
                    timer.cancel();
                  }
                });
              }
            }
          case ('cancel'):
            {
              timer?.cancel();
            }
        }
      }
    });
  }
}

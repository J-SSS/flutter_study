import 'dart:async';
import 'dart:isolate';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_study/main.dart';

class IsolateTimerRunner extends ChangeNotifier {
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  late SendPort _sendPort2;

  get sendPort => _sendPort;
  get receivePort => _receivePort;

  IsolateTimerRunner._(this._isolate, this._sendPort, this._receivePort);

/*!*
  5초마다 백그라운드 Isolate에서 타이머 이벤트 발생
  AppManager.isolateTimer?.runPeriodicTimer(Duration(seconds: 5), (timer) {
    // context.read<TimerViewModel>().testFunc();
    print('백그라운드 타이머 이벤트 발생: ${DateTime.now()}');
  });

 */

  /** IsolateTimer 생성  */
  static Future<IsolateTimerRunner> create() async {
    AppManager.log('IsolateTimer 생성');

    final receivePort = ReceivePort(); // 1. 메인 Isolate에서 사용할 ReceivePort 생성
    final isolate = await Isolate.spawn(_isolateTimer, receivePort.sendPort); // 2. Timer Isolate를 생성하면서, 메인 Isolate의 ReceivePort를 전달한다
    final sendPort = await receivePort.first as SendPort; // 3. Timer Isolate에서 보내오는 첫 번째 메시지를 Timer Isolate의 RecivePort로 저장한다

    return IsolateTimerRunner._(isolate, sendPort, receivePort);
  }

  /** IsolateTimer 명령 */
  void runPeriodicTimer(Duration duration, void Function(Timer) callback) {
    sendPort.send({
      'command': 'runPeriodicTimer',
      'duration': duration.inMilliseconds,
      'callback': callback,
    });
    // _receivePort.listen((message) { print('리시버');});
  }

  /** IsolateTimer 명령 */
  void cancelPeriodicTimer() {
    sendPort.send({
      'command': 'cancelPeriodicTimer'
    });
  }

  static void testFuc(){
    print('함수 호출');
  }

  /** IsolateTimer 기능 정의 */
  static void _isolateTimer(SendPort sendPort) {
    final receivePort = ReceivePort(); // 1. Timer Isolate가 사용할 ReceivePort를 생성한다
    sendPort.send(receivePort.sendPort); // 2. 메인 Isolate에게 Timer Isolate의 ReceivePort를 전달한다
    bool _isPlaying = false;

    Timer? periodicTimer;

    receivePort.listen((message) {
      if (message is Map && message.containsKey('command')) {
        switch(message['command']){
          case('runPeriodicTimer') : {
            final duration = Duration(milliseconds: message['duration']);
            final callback = message['callback'] as void Function(Timer);

            testFuc();
            sendPort.send("테스트메시지");
            periodicTimer = Timer.periodic(duration, callback);
          }
          case('cancelPeriodicTimer') : {
            periodicTimer?.cancel();
          }
        }
      }
    });
  }


}
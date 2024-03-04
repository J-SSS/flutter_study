import 'dart:async';
import 'dart:isolate';
import 'dart:developer';

import 'package:flutter_study/main.dart';

// class IsolateTimerRunner {
//   late SendPort _sendPort;
//   late ReceivePort _mainReceive;
//   late ReceivePort _subReceive;
//   late Isolate _isolate;
//   late SendPort _sendPort2;
//
//   // IsolateTimerRunner._(this._isolate, this._sendPort, this._receivePort);
//
//   IsolateTimerRunner(){
//     _mainReceive = ReceivePort();
//     _subReceive = ReceivePort();
//     create();
//   }
//
//   // void test (){
//   //   _receivePort.listen((message) { print('리시버');});
//   // }
//
//
//   /** IsolateTimer 생성  */
//   Future<void> create() async {
//
//     final isolate = await Isolate.spawn(_isolateTimer, _mainReceive.sendPort); // 2. Timer Isolate를 생성하면서, 메인 Isolate의 ReceivePort를 전달한다
//     // final sendPort = await _receivePort.first as SendPort; // 3. Timer Isolate에서 보내오는 첫 번째 메시지를 Timer Isolate의 RecivePort로 저장한다
//
//     // receivePort.listen((message) { print('리시버');});
//
//   }
//
//   /** IsolateTimer 명령 */
//   void runPeriodicTimer(Duration duration, void Function(Timer) callback) {
//     _sendPort.send({
//       'command': 'runPeriodicTimer',
//       'duration': duration.inMilliseconds,
//       'callback': callback,
//     });
//     _mainReceive.listen((message) { print('리시버');});
//   }
//   //
//   // /** IsolateTimer 명령 */
//   // void cancelPeriodicTimer() {
//   //   _sendPort.send({
//   //     'command': 'cancelPeriodicTimer'
//   //   });
//   // }
//
//   /** IsolateTimer 기능 정의 */
//   void _isolateTimer(SendPort sendPort) {
//     // final receivePort = ReceivePort(); // 1. Timer Isolate가 사용할 ReceivePort를 생성한다
//     // sendPort.send(receivePort.sendPort); // 2. 메인 Isolate에게 Timer Isolate의 ReceivePort를 전달한다
//     bool _isPlaying = false;
//
//     Timer? periodicTimer;
//
//     _subReceive.listen((message) {
//       if (message is Map && message.containsKey('command')) {
//         switch(message['command']){
//           case('runPeriodicTimer') : {
//             final duration = Duration(milliseconds: message['duration']);
//             final callback = message['callback'] as void Function(Timer);
//
//             _mainReceive.sendPort.send("테스트메시지");
//             periodicTimer = Timer.periodic(duration, callback);
//           }
//         }
//       }
//     });
//   }
// }

class IsolateTimerRunner {
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  late SendPort _sendPort2;

  IsolateTimerRunner._(this._isolate, this._sendPort, this._receivePort);

  // void test (){
  //   _receivePort.listen((message) { print('리시버');});
  // }


  /** IsolateTimer 생성  */
  static Future<IsolateTimerRunner> create() async {
    AppManager.log('IsolateTimer 생성');

    final receivePort = ReceivePort(); // 1. 메인 Isolate에서 사용할 ReceivePort 생성
    final isolate = await Isolate.spawn(_isolateTimer, receivePort.sendPort); // 2. Timer Isolate를 생성하면서, 메인 Isolate의 ReceivePort를 전달한다
    final sendPort = await receivePort.first as SendPort; // 3. Timer Isolate에서 보내오는 첫 번째 메시지를 Timer Isolate의 RecivePort로 저장한다


    final newReceivePort = ReceivePort();
    // receivePort.listen((message) { print('리시버');});

    return IsolateTimerRunner._(isolate, sendPort, receivePort);
  }

  /** IsolateTimer 명령 */
  void runPeriodicTimer(Duration duration, void Function(Timer) callback) {
    _sendPort.send({
      'command': 'runPeriodicTimer',
      'duration': duration.inMilliseconds,
      'callback': callback,
    });
    // _receivePort.listen((message) { print('리시버');});
  }

  /** IsolateTimer 명령 */
  void cancelPeriodicTimer() {
    _sendPort.send({
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
    // _sendPort2 = receivePort.sendPort;
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
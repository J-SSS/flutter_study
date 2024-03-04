// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_study/main.dart';
import 'dart:convert';

import 'dart:async';
import 'dart:isolate';

void main() async {
  // 백그라운드 Isolate 시작
  IsolateTimerRunner isolateRunner = await IsolateTimerRunner.create();

  // 5초마다 백그라운드 Isolate에서 타이머 이벤트 발생
  isolateRunner.runPeriodicTimer(Duration(seconds: 5), (timer) {
    print('백그라운드 타이머 이벤트 발생: ${DateTime.now()}');
  });
}

class IsolateTimerRunner {
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  late Isolate _isolate;

  // // 메시지 수신을 위한 이벤트 리스너
  // receivePort.listen((message) {
  // print('메시지 수신: $message');
  // });
  //
  // // 메인 Isolate에서 백그라운드 Isolate로 메시지 전송
  // isolate.send('안녕하세요!');

  static Future<IsolateTimerRunner> create() async {
    final receivePort = ReceivePort(); // 1. 메인 Isolate에서 사용할 ReceivePort 생성
    final isolate = await Isolate.spawn(_isolateTimer, receivePort.sendPort); // 2. Timer Isolate를 생성하면서, 메인 Isolate의 ReceivePort를 전달한다
    final sendPort = await receivePort.first as SendPort; // 3. Timer Isolate에서 보내오는 첫 번째 메시지를 Timer Isolate의 RecivePort로 저장한다

    return IsolateTimerRunner._(isolate, sendPort, receivePort);
  }

  IsolateTimerRunner._(this._isolate, this._sendPort, this._receivePort);

  void runPeriodicTimer(Duration duration, void Function(Timer) callback) {
    _sendPort.send({
      'command': 'runPeriodicTimer',
      'duration': duration.inMilliseconds,
      'callback': callback,
    });
  }

  static void _isolateTimer(SendPort sendPort) {
    final receivePort = ReceivePort(); // 1. Timer Isolate가 사용할 ReceivePort를 생성한다
    sendPort.send(receivePort.sendPort); // 2. 메인 Isolate에게 Timer Isolate의 ReceivePort를 전달한다

    receivePort.listen((message) { // receivePort로 수신되는 메시지를 처리
      if (message is Map && message.containsKey('command')) {
        if (message['command'] == 'runPeriodicTimer') {
          final duration = Duration(milliseconds: message['duration']);
          final callback = message['callback'] as void Function(Timer);

          Timer.periodic(duration, callback);
        }
      }
    });
  }
}


// void main() {
//
//
//
//   // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//   //   // Build our app and trigger a frame.
//   //   await tester.pumpWidget(const MyApp());
//   //
//   //   // Verify that our counter starts at 0.
//   //   expect(find.text('0'), findsOneWidget);
//   //   expect(find.text('1'), findsNothing);
//   //
//   //   // Tap the '+' icon and trigger a frame.
//   //   await tester.tap(find.byIcon(Icons.add));
//   //   await tester.pump();
//   //
//   //   // Verify that our counter has incremented.
//   //   expect(find.text('0'), findsNothing);
//   //   expect(find.text('1'), findsOneWidget);
//   // });
// }

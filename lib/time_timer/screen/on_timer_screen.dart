import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';
import 'package:flutter_study/time_timer/provider/on_timer_listener.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/widgets/pizza_type.dart';
import 'dart:developer';
import 'dart:isolate';

import '../../main.dart';
import '../provider/time_config.dart';

class OnTimerScreen extends StatelessWidget {
  bool isVisible = true;

  final GlobalKey<_onTimerBottomBarState> keyTest = GlobalKey<_onTimerBottomBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          isVisible = false;
          context.read<AppConfigListener>().setOnTimerBottomView = true;
          print('터치');
          // utils.showOverlayBottomBar(context);
          // setState(() {
          //   });
        },
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 200,
                left: 30,
                child: PizzaTypeBase(
                  size: Size(350, 350),
                ),
              ),
              Positioned(
                top: 200,
                left: 30,
                child: PizzaType(
                    size: Size(350, 350),
                    isOnTimer: isVisible,
                    setupTime: context.read<TimeConfigListener>().setupTime),
              ),
              Positioned(
                bottom: 0,
                child: OnTimerBottomBar(key : keyTest),
              ),
            ],
          ),
        ),
      ),
    );
  }

// @override
// State<StatefulWidget> createState() {
//   return print("object");
// }

// @override
// _OnTimerScreen createState() => _OnTimerScreenState();
}

// Visibility(
// visible: context.watch<AppConfigListener>().isOnTimerBottomViewYn,
// child:  Container(
// width: MediaQuery.of(context).size.width,
// height: 150,
// color: Colors.green,
// ),
// )

class OnTimerBottomBar extends StatefulWidget {

  // const OnTimerBottomBar({Key? key}) : super(key: key);
  const OnTimerBottomBar({super.key});

  void testFunc(){
    print('키!');
  }

  @override
  State<StatefulWidget> createState() => _onTimerBottomBarState();
}

class _onTimerBottomBarState extends State<OnTimerBottomBar> {
  late TimerRun timerRun;
  ReceivePort receivePort = ReceivePort();

  @override
  Widget build(BuildContext context) {
    timerRun = TimerRun(receivePort);
    receivePort.listen((message) {
      if(message is SendPort){
        print('샌드포트');
        context.read<TimerViewModel>().testFunc();
      } else {
        print('메시지수신');
      }
    });
    return Visibility(
      // visible: context.watch<AppConfigListener>().isOnTimerBottomViewYn,
      visible: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180, // jdi 높이 수정 필요함
        color: Colors.grey.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                // print(widget.key);
                // context.read<TimerViewModel>().loadTimer();
                // 백그라운드 Isolate 시작
                // IsolateTimerRunner isolateTimer = await IsolateTimerRunner.create();

                timerRun.runPeriodicTimer();


                // 5초마다 백그라운드 Isolate에서 타이머 이벤트 발생
                // AppManager.isolateTimer?.runPeriodicTimer(Duration(seconds: 5), (timer) {
                //   // context.read<TimerViewModel>().testFunc();
                //   print('백그라운드 타이머 이벤트 발생: ${DateTime.now()}');
                // });

                // context.read<OnTimerListener>().setIsPlaying = false;
                // widget.key?.currentState?.testFunc();
              },
              child: Text('시작'),
            ),
            ElevatedButton(
              onPressed: () async {
                // 5초마다 백그라운드 Isolate에서 타이머 이벤트 발생
                // AppManager.isolateTimer?.cancelPeriodicTimer();
              },
              child: Text('정지'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        )



      ),
    );
  }
}

class TimerRun {
  // final ReceivePort _mainReceive = ReceivePort();
  late ReceivePort _subReceive;
  late SendPort sendPort;
  // late BuildContext context;

  TimerRun(ReceivePort receivePort2){
    // print(_mainReceive.sendPort);
    // this.context = context;
     final receivePort = ReceivePort();
     // _mainReceive = receivePort;
    Isolate.spawn(_isolateTimer, receivePort2.sendPort);
     // receivePort.listen((message) {
     //   if(message is SendPort){
     //     sendPort = message as SendPort;
     //   } else {
     //     // context.read<TimerViewModel>().testFunc();
     //     print('메시지수신');
     //   }
     // });
  }

  /** IsolateTimer 명령 */
  void runPeriodicTimer() {
    sendPort.send("msg");
    // _receivePort.listen((message) { print('리시버');});
  }

    void _isolateTimer(SendPort sendPort) {
    print('아이솔');
    ReceivePort receivePort = ReceivePort(); // 1. Timer Isolate가 사용할 ReceivePort를 생성한다
    sendPort.send(receivePort.sendPort); // 2. 메인 Isolate에게 Timer Isolate의 ReceivePort를 전달한다
    // _subReceive = receivePort;

    // print(_subReceive);
    // context.read<TimerViewModel>().testFunc();
    // receivePort.listen((message) {
    //   print('메세지 수신');
    //   sendPort.send('메세지 응답');
    // });
  }

}

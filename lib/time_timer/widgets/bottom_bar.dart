import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'package:flutter_study/time_timer/screen/on_timer_screen.dart' as on_timer_screen;
import 'package:flutter_study/time_timer/screen/theme_screen.dart' as theme_screen;
import 'package:flutter_study/time_timer/screen/setting_screen.dart' as setting_screen;
import 'package:flutter_study/time_timer/provider/timer_controller.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';


class ButtomBarWidget extends StatefulWidget{
  const ButtomBarWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ButtomBarWidgetState();
}

class _ButtomBarWidgetState extends State<ButtomBarWidget>{
  late Timer _timer; // 타이머
  var _time = 60; // 실제 늘어날 시간
  var _isPause = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox( /** 배경 영역 */
          width: 300,
          height: 150,
        ),
        Positioned( /** 상단 반원 영역 */
            left : 105,
            top: 5,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.00),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, -0),
                  ),
                ],
              ),
            )
        ),
        Positioned( /** 하단 사각 영역 */
          top: 50,
          child:  Container(
              width: 300,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.00),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton( /** 좌버튼 */
                    onPressed: () {
                      // _reset();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => theme_screen.ThemeScreen()),
                        // MaterialPageRoute(builder: (context) => setting_screen.MySettingScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10.0),
                      fixedSize: Size(70.0, 70.0),
                    ),
                    child:  Image.asset(
                      'assets/icon/btm_theme.png',
                      width: 45.0,
                      height: 45.0,
                    ),
                  ),
                  SizedBox(width: 100,),
                  TextButton( /** 우버튼 */
                    onPressed: () {
                      context.read<TimerController>().setLoopBtn = 'set';
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10.0),
                      fixedSize: Size(70.0, 70.0),
                    ),
                    child:  Image.asset(
                      'assets/icon/${context.select((TimerController t) => t.loopBtn)}.png',
                      width: 45.0,
                      height: 45.0,
                    ),
                  ),
                ],
              )
          ),
        ),
        Positioned( /** 재생버튼 */
            left : 110,
            top: 10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.00),
              ),
              child: TextButton(
                onPressed: () {
                  // _click(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => on_timer_screen.OnTimerScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10.0),
                  fixedSize: Size(90.0, 90.0),
                ),
                child:  Image.asset(
                  'assets/icon/${context.select((TimerController t) => t.playBtn)}.png',
                  width: 120.0,
                  height: 120.0,
                ),
              ),
            )
        ),
      ],
    );
  }

  // void _click(BuildContext context) {
  //   var _isPlaying = !context.read<TimerController>().isPlaying;
  //
  //   if(_isPlaying) {
  //     context.read<TimerController>().isPlaying = true;
  //     context.read<TimerController>().isPause = false;
  //     context.read<TimerController>().ableEdit = false;
  //     context.read<TimerController>().setPlayBtn = 'btn_pause';
  //
  //     _start(context);
  //   } else {
  //     context.read<TimerController>().isPlaying = false;
  //     context.read<TimerController>().isPause = true;
  //     context.read<TimerController>().ableEdit = true;
  //     context.read<TimerController>().setPlayBtn = 'btn_play';
  //
  //     _pause();
  //   }
  // }

  // 타이머 시작
  // void _start(BuildContext context) {
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     _time--;
  //     context.read<TimerController>().setSetupTime = _time;
  //   });
  //
  // }
  //
  // // 타이머 정지
  // void _pause() {
  //   _timer?.cancel();
  // }
  //
  // // 초기화
  // void _reset() {
  //   context.read<TimerController>().setPlayBtn = 'btn_play';
  //   context.read<TimerController>().isPlaying = false;
  //   context.read<TimerController>().setSetupTime = 60;
  //
  //   _timer?.cancel();
  // }
}
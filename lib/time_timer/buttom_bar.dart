import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/timer.dart';
import 'package:flutter_study/time_timer/on_timer.dart' as onTimer;

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
        Container(
          width: 350,
          height: 150,
        ),
        Positioned(
            left : 130,
            top: 5,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.00), // 테두리 둥글기 설정
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, -0), // 음영의 위치 조절
                  ),
                ],
              ),
            )
        ),
        Positioned(
          top: 50,
          child:  Container(
              width: 350,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.00), // 테두리 둥글기 설정
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // 음영의 위치 조절
                  ),
                ],
              ),
              child : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // 간격을 균등하게 배치
                children: [
                  TextButton(
                    onPressed: () {
                      _reset();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), // 동그란 모양을 지정
                      padding: EdgeInsets.all(10.0), // 아이콘과 버튼의 경계
                      fixedSize: Size(70.0, 70.0), // 버튼의 크기를 지정
                    ),
                    child:  Image.asset(
                      'assets/icon/btm_reset.png',
                      width: 45.0,
                      height: 45.0,
                    ),
                  ),
                  SizedBox(width: 100,),
                  TextButton(
                    onPressed: () {
                      context.read<TimeObserver>().setLoopBtn = 'set';
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), // 동그란 모양을 지정
                      padding: EdgeInsets.all(10.0), // 아이콘과 버튼의 경계
                      fixedSize: Size(70.0, 70.0), // 버튼의 크기를 지정
                    ),
                    child:  Image.asset(
                      'assets/icon/${context.select((TimeObserver t) => t.loopBtn)}.png',
                      width: 45.0,
                      height: 45.0,
                    ),
                  ),
                ],
              )
          ),
        ),
        Positioned(
            left : 135,
            top: 10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.00), // 테두리 둥글기 설정
              ),
              child: TextButton(
                onPressed: () {
                  // _click(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => onTimer.OnTimerScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(), // 동그란 모양을 지정
                  padding: EdgeInsets.all(10.0), // 아이콘과 버튼의 경계
                  fixedSize: Size(90.0, 90.0), // 버튼의 크기를 지정
                ),
                child:  Image.asset(
                  'assets/icon/${context.select((TimeObserver t) => t.playBtn)}.png',
                  width: 120.0,
                  height: 120.0,
                ),
              ),
            )
        ),
      ],
    );
  }

  void _click(BuildContext context) {
    var _isPlaying = !context.read<TimeObserver>().isPlaying;

    if(_isPlaying) {
      context.read<TimeObserver>().isPlaying = true;
      context.read<TimeObserver>().isPause = false;
      context.read<TimeObserver>().ableEdit = false;
      context.read<TimeObserver>().setPlayBtn = 'btm_pause';

      _start(context);
    } else {
      context.read<TimeObserver>().isPlaying = false;
      context.read<TimeObserver>().isPause = true;
      context.read<TimeObserver>().ableEdit = true;
      context.read<TimeObserver>().setPlayBtn = 'btm_play';

      _pause();
    }
  }

  // 타이머 시작
  void _start(BuildContext context) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _time--;
      context.read<TimeObserver>().setRemainTime = _time;
    });

  }

  // 타이머 정지
  void _pause() {
    _timer?.cancel();
  }

  // 초기화
  void _reset() {
    context.read<TimeObserver>().setPlayBtn = 'btm_play';
    context.read<TimeObserver>().isPlaying = false;
    context.read<TimeObserver>().setRemainTime = 60;

    _timer?.cancel();
  }
}
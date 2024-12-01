import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'dart:developer';

import 'package:flutter_study/time_timer/provider/app_config.dart';
import 'package:flutter_study/time_timer/provider/timer_controller.dart';

/** 원형 타입에서 클릭 위치를 1/60 시간 단위로 변환 */
int angleToMin(Offset clickPoint, Size size) {
  int angleToMin;

  double centerX = size.width / 2;
  double centerY = size.height / 2;
  double radius = size.width / 2;

  double startAngle = -math.pi / 2; // 12시 방향에서 시작
  double clickAngle =
  math.atan2(clickPoint.dy - centerY, clickPoint.dx - centerX);
  double sweepAngle;

  // print(2 * math.pi/60); // 0.10471975511965977
  // print(sweepAngle/(2 * math.pi/60));

  // print('내림각도 : ${(sweepAngle/(2 * math.pi/60)).floor()}, 원본각도 : ${(sweepAngle/(2 * math.pi/60))}');
  // print( '시작각 : ${startAngle} , 클릭각 : ${clickAngle}, 차이각 : ${sweepAngle}, 임시 : ${(math.pi/2-clickAngle)} ');

  // print(clickPoint);
  // print(clickPoint.direction);

  if (clickAngle > -math.pi && clickAngle < startAngle) {
    // 180 ~ -90(270)도
    sweepAngle = 2 * math.pi + clickAngle - startAngle;
  } else {
    // -90 ~ 180도
    sweepAngle = clickAngle - startAngle;
  }

  angleToMin = (sweepAngle / (2 * math.pi / 60)).floor();
  angleToMin == 0 ? angleToMin = 60 : angleToMin;

  return angleToMin;
}

int clickToMin2(Offset clickPoint, Size size) {
  int angleToMin;

  double sizeH = size.height * 0.6;
  double strokeW = (sizeH * 0.03).floorToDouble(); // 선 굵기 3프로

  double netH = sizeH - (strokeW * 3); // 배경 여백 밑 테두리 제외한 높이 좌표
  double netLength = sizeH - (strokeW * 6); // 상, 하 여백 밑 테두리 제외한 빈공간 절대높이

  // print('섹션 갭 ${sectionGap}, 네트 높이 :  $netLength, 가용공간 : ${netLength - sectionGap * 9}',);
  // print('섹션높이 : ${(netLength - sectionGap * 9)/10}',);
  // print('네트높이 : ${netLength}, 시간 : ${clickToMin}, 클릭Y : ${clickPoint.dy}, 최대좌표 : ${netH}, 상단여백 : ${strokeW*2.5}');

  double sectionGap = (sizeH * 0.015).floorToDouble(); // 섹션 사이의 거리 // ex) 7
  double sectionLength = (netLength - sectionGap * 9) / 10; // ex) 33.231428571428566
  double sectionAmount = sectionLength + sectionGap; // gap 포함한 섹션 크기 ex) 40정도
  double clickY = clickPoint.dy;

  int drawCnt = 0;
  int pointToMin = 0;

  /** 클릭 위치에 따른 draw 좌표를 도출한다 */
  if(strokeW * 3 >= clickY){
    angleToMin = 60;
  } else if(netH <= clickY){
    angleToMin = 0;
  } else {
    for(int i = 0 ; i<10 ; i++){
      if(clickY < netH - (sectionAmount * i) && clickY > netH - (sectionAmount * (i+1))){
        double btm = netH - (sectionAmount * i);
        double top = netH - (sectionAmount * (i+1) - sectionGap);
        double gap = (btm-top)/6;
        double min = ((btm - clickY)/gap).floor()+1;

        if(min > 0 && min < 6){
          pointToMin = min.toInt();
        } else {
          pointToMin = 6;
        }
        drawCnt = i;
      }
    }
    angleToMin = (drawCnt * 6) + pointToMin;
  }
  return angleToMin;
}

/** 설정한 시간을 Overlay 위젯으로 표시 */
void showOverlayText(BuildContext context) {
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height / 2,
      left: MediaQuery.of(context).size.width / 2 - 50.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 120.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.01),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              context.select(
                  (TimerController t) => t.setupTime.toString() + " mins"),
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  // 1초 후에 OverlayEntry를 제거하여 텍스트를 사라지게 함
  Future.delayed(Duration(milliseconds: 500), () {
    overlayEntry.remove();
  });
}

// CarouselSlider(
//     options: CarouselOptions(
//       height: 500,
//       aspectRatio: 16 / 9, // 화면 비율(16/9)
//       viewportFraction: 1.0, // 페이지 차지 비율(0.8)
//       // autoPlay: false, // 자동 슬라이드(false)
//       // autoPlayInterval: const Duration(seconds: 4), // 자동 슬라이드 주기(4seconds)
//       onPageChanged: ((index, reason) {
//         // 페이지가 슬라이드될 때의 기능 정의
//         print('미디어쿼리');
//         print(MediaQuery.of(context).size);
//       }),
//     ),
//     items: ['pizza', 'battery'].map((type) {
//       return Builder(
//         builder: (BuildContext context) {
//           return Padding(
//               padding: EdgeInsets.fromLTRB(
//                   10.0, 5.0, 10.0, 5.0), //좌 상 우 하
//               child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.symmetric(horizontal: 5.0),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(0, 3), // 음영의 위치 조절
//                         ),
//                       ]),
//                   child: Center(
//                     child: Stack(children: [
//                       pizzaTypeBase(),
//                       pizzaType(),
//                     ]),
//                   )));
//         },
//       );
//     }).toList()),

// // 제네릭 함수를 사용하여 특정 타입의 위젯을 찾기
// T? findWidgetByKey<T>(BuildContext context, Key key) {
//   return context.findAncestorWidgetOfExactType<T>();
// }




//   final customTimer = CustomTimer(duration: Duration(seconds: 5));
//
//   customTimer.start();
//
//   // 3초 후에 타이머 일시 정지
//   Future.delayed(Duration(seconds: 3), () {
//     customTimer.pause();
//     print('Timer paused at 3 seconds');
//   });
//
//   // 6초 후에 타이머 재개
//   Future.delayed(Duration(seconds: 6), () {
//     customTimer.resume();
//     print('Timer resumed at 6 seconds');
//   });
// }

/** 베이스 타이머 */
class BaseTimer {
  final Duration duration;
  late StreamController<int> _controller;
  late StreamSubscription<int> _subscription;

  BaseTimer({required this.duration}) {
    _controller = StreamController<int>();
    _subscription = _controller.stream.listen((event) {
      print('Timer tick: $event');
    });
  }

  void start() {
    int tick = 0;
    Timer.periodic(Duration(seconds: 1), (timer) {
      tick++;
      _controller.add(tick);
      if (tick == duration.inSeconds) {
        timer.cancel();
      }
    });
  }

  void pause() {
    _subscription.pause();
  }

  void resume() {
    _subscription.resume();
  }
}

/** 미디어쿼리 너비,높이 */
double mediaWidth(BuildContext context, double scale) => MediaQuery.of(context).size.width * scale;
double mediaHeight(BuildContext context, double scale) => MediaQuery.of(context).size.height * scale;

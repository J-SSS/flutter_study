import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/base_timer.dart';

import 'package:flutter_study/time_timer/provider/app_config.dart';
import 'package:flutter_study/time_timer/provider/time_config.dart';

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
                  (TimeConfigListener t) => t.setupTime.toString() + " mins"),
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

import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/provider/on_timer_listener.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';
import 'package:flutter_study/time_timer/provider/time_config.dart';

class BatteryType extends StatefulWidget {
  bool isOnTimer = false;
  int setupTime;
  Size size;
  final Offset clickPoint;

  BatteryType({super.key,required this.size, required this.isOnTimer, required this.setupTime, required this.clickPoint});

  @override
  State<StatefulWidget> createState() {
    return _BatteryTypeState();
  }
}

class _BatteryTypeState extends State<BatteryType> {
  late Timer _timer;

  _BatteryTypeState();

  @override
  void initState() {
    if (widget.isOnTimer) {
      print('한 번만 작동');
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        bool isPlaying = context.read<OnTimerListener>().isPlaying;
        if(isPlaying){
          widget.setupTime -= 1;
          if(widget.setupTime > -2){
            setState(() { print('남은 시간 : ${widget.setupTime}'); });
          } else {
            _timer.cancel();
          }
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.isOnTimer) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomPaint(
      size: widget.size, // 원하는 크기로 지정
      painter: BatteryTypePainter(
        angleToMin: widget.isOnTimer ? widget.setupTime : context.watch<TimeConfigListener>().setupTime, clickPoint: context.watch<TimeConfigListener>().clickPoint
      ),
    );
  }
}

class BatteryTypePainter extends CustomPainter {
  int angleToMin;
  Offset clickPoint;

  BatteryTypePainter({
    required this.angleToMin, required this.clickPoint
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    Paint paint2 = Paint() // 구분선용
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double sizeH = size.height;
    double sizeW = size.width;

    double strokeW = (sizeH * 0.03).floorToDouble(); // 선 굵기 3프로
    double paddingL = (sizeH * 0.15).floorToDouble(); // 시간 부분 패딩 사이즈

    // double lineH = (sizeH * 0.015).floorToDouble(); // 구분선은 외곽선의 절반?

    double netH = sizeH - (strokeW * 3); // 배경 여백 밑 테두리 제외한 높이 좌표
    double netLength = sizeH - (strokeW * 6); // 상, 하 여백 밑 테두리 제외한 빈공간 절대높이


    double width = size.width;

    int clickToMin = ((netH - clickPoint.dy)/netLength * 60).floor();

    // print('네트높이 : ${netLength}, 시간 : ${clickToMin}, 클릭Y : ${clickPoint.dy}, 최대좌표 : ${netH}, 상단여백 : ${strokeW*2.5}');

    int sectionCnt = (clickToMin/6).floor();
    // print(sectionCnt);
    double sectionLength = (netLength - 7 * 9) / 10;
    // print(sectionLength);



    double minToPoint = netH - (netLength / 60) * clickToMin;

    // print(minToPoint);

    // 10등분을 하려면 여백선은 11개가 필요하다

    if(clickToMin <= 15){
      paint.color = Colors.red;
    } else if (clickToMin <= 30) {
      paint.color = Colors.orange;
    } else if (clickToMin <= 60) {
      paint.color = Colors.greenAccent;
    }

    double dy = clickPoint.dy;
    int intDy = dy.floor();
    double radius = 15.0;
    Rect rect;
    RRect rRect;
    // print(size.height); // 500??

    if(clickToMin >= 0 && clickToMin < 60){
      rect  = Rect.fromLTRB(paddingL, minToPoint, width-paddingL, netH);
      RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

      rRect = RRect.fromRectAndCorners(rect,
    bottomLeft: Radius.circular(radius), bottomRight: Radius.circular(radius));
      canvas.drawRRect(rRect, paint);

    } else if (clickToMin >= 60) {
      rect  = Rect.fromLTRB(paddingL, strokeW * 3, width-paddingL, netH);
      rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(rRect, paint);
    }

    for(double i = netH ; i > 30 ; i-=sectionLength+7){
      canvas.drawRect(Rect.fromLTRB(paddingL, i+5, paddingL * 1.8, i), paint2);
    }

    // for(int i = 0 ; i < sectionCnt ; i++){
    //   // print('i : ${i} , section : ${sectionCnt}');
    //   if(i < sectionCnt){
    //     print('선 : ${i}');
    //     canvas.drawRect(Rect.fromLTRB(paddingL, netH-sectionLength * (i+1) -4 - (i*8), width-paddingL, netH-sectionLength * (i+1) - (i * 8)), paint2);
    //   }
    // }
    }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class BatteryTypeBase extends StatefulWidget {

  Size size;

  BatteryTypeBase({super.key,required this.size});

  @override
  State<StatefulWidget> createState() {
    return _BatteryTypeBaseState();
  }
}

class _BatteryTypeBaseState extends State<BatteryTypeBase> {
  late Timer _timer;

  _BatteryTypeBaseState();


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size, // 원하는 크기로 지정
      painter: BatteryTypeBasePainter(
      ),
    );
  }
}

class BatteryTypeBasePainter extends CustomPainter {
  final Color _color = Colors.grey;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintBody = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke;

    Paint paintHead = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;

    double sizeH = size.height;
    double sizeW = size.width;

    double strokeW = (sizeH * 0.03).floorToDouble(); // 선 굵기 3프로
    double paddingL = (sizeH * 0.15).floorToDouble(); // 시간 부분 패딩 사이즈
    double paddingHeadL = (sizeH * 0.30).floorToDouble(); // +극 부분 패딩 사이즈
    double paddingBaseL = paddingL-strokeW; // 테두리 부분 패딩 사이즈

    double width = size.width;
    double radius = strokeW; // 원하는 둥근 모서리 반지름

    /**
     * 선 굵기 : 세로 길이의 3프로
     * 테두리 패딩 + 선굵기 = 시간 부분 패딩
     * +극 부분은 선 굵기의 2배 높이, 배터리 하단에도 같은 만큼의 여유 공간을 부여한다
     */

    Rect rect = Rect.fromLTRB(paddingBaseL, strokeW * 2, width-paddingBaseL, size.height - strokeW * 2);
    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    Rect rectHead = Rect.fromLTRB(paddingHeadL, 0, width-paddingHeadL, strokeW * 2);

    canvas.drawRRect(rRect, paintBody..strokeWidth = strokeW);
    canvas.drawRect(rectHead, paintHead);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


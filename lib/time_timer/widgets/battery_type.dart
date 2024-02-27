import 'package:flutter/material.dart';
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
      ..style = PaintingStyle.fill; // 채우기로 변경

    Paint paint2 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // 채우기로 변경

    // print(clickPoint);
    double rectSize = 50.0;
    // print(clickPoint.dx);
    print(clickPoint.dy.floor() / 60);

    int clickToMin = ((400 - clickPoint.dy.floor())/400 * 60).floor();


    double dy = clickPoint.dy;
    int intDy = dy.floor();

    if(intDy >= 0){
      canvas.drawRect(Rect.fromLTRB(50, dy.roundToDouble(), 300, 400), paint);
    } else {
      canvas.drawRect(Rect.fromLTRB(50, 0, 300, 400), paint);
    }

    for(double i = 0 ; i < 400 ; i+=80){
      canvas.drawRect(Rect.fromLTRB(50, i+5, 300, i), paint2);
    }
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

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill; // 채우기로 변경

    Paint paint2 = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
    ..strokeWidth = 10.0;


    canvas.drawRect(Rect.fromLTRB(35, 10, 315, 350), paint2);

  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


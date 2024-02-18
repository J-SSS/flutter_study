import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import 'package:flutter_study/time_timer/buttom_bar.dart';


class configObserver with ChangeNotifier {

}
class TimeObserver with ChangeNotifier {
  int remainTime = 60;
  bool isPlaying = false;
  bool isPause = false;
  bool ableEdit = false;


  var playBtn = 'btm_play';
  var loopBtn = 'btm_roop_1';


  set setPlayBtn(var btn) {
    this.playBtn = btn;
    notifyListeners();
  }

  set setRemainTime(int remainTime) {
    this.remainTime = remainTime;
    notifyListeners();
  }

  set setLoopBtn(var btn) {
    int currentSet = int.parse(this.loopBtn.split('_')[2]);
    if(currentSet != 4){
      this.loopBtn = 'btm_roop_${currentSet+1}';
    } else {
      this.loopBtn = 'btm_roop_1';
    }
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 이유 찾아보기

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TimeObserver()),
        ChangeNotifierProvider(
            create: (context) => configObserver()),
      ],
      child: MaterialApp(
        home: MyTimeTimer(),
      ),
    );
  }
}



class MyTimeTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시간 ${context.select((TimeObserver p) => p.remainTime)}'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Center(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children:[
                pizzaTypeBase(),
                pizzaType(),
              ]
            ),
            SizedBox(height: 100,),
            ButtomBarWidget()
          ],
        ),
      ),
    );
  }
}

class pizzaType extends StatefulWidget {
  @override
  _pizzaTypeState createState() => _pizzaTypeState();
}

class _pizzaTypeState extends State<pizzaType> {
  Offset clickPoint = Offset(150.0, 150.0); // 초기값: 원의 중심

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
          setState(() {
            if(!context.read<TimeObserver>().isPlaying || context.read<TimeObserver>().isPause) {
              clickPoint = details.localPosition;
              context.read<TimeObserver>().ableEdit = true;
            }
          });
      },
      child: CustomPaint(
        size: Size(350.0, 350.0), // 원하는 크기로 지정
        painter: pizzaTypePainter(
            context : context,
            clickPoint: clickPoint,
            remainTime: context.watch<TimeObserver>().remainTime
        ),
      ),
    );
  }
}

class pizzaTypePainter extends CustomPainter {
  final Offset clickPoint;
  BuildContext context;
  int? remainTime;

  pizzaTypePainter({required this.context, required this.clickPoint, this.remainTime});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = Colors.red
      // ..color = Color(0xFF56B5B7)
      ..color = Color.fromRGBO(106,211,211, 1.0)
      ..style = PaintingStyle.fill; // 채우기로 변경

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    double startAngle = -math.pi / 2; // 12시 방향에서 시작
    double clickAngle = math.atan2(clickPoint.dy - centerY, clickPoint.dx - centerX);
    double sweepAngle;

    if(clickAngle > -math.pi && clickAngle < startAngle){ // 180 ~ -90(270)도
      sweepAngle = 2 * math.pi + clickAngle - startAngle;
    } else { // -90 ~ 180도
      sweepAngle = clickAngle - startAngle;
    }



    var angleToMin = (sweepAngle/(2 * math.pi/60)).floor();

    // context.read<TimeObserver>().remainTime = angleToMin;
    sweepAngle = (2 * math.pi)/60 * angleToMin;

    if(!context.read<TimeObserver>().ableEdit){
      if(context.read<TimeObserver>().isPlaying || context.read<TimeObserver>().isPause){
        final remainTime = this.remainTime;
        if(remainTime != null){
          sweepAngle = (2 * math.pi)/60 * remainTime;
        }
      }
    }


    // print(2 * math.pi/60); // 0.10471975511965977
    // print(sweepAngle/(2 * math.pi/60));

    // print('내림각도 : ${(sweepAngle/(2 * math.pi/60)).floor()}, 원본각도 : ${(sweepAngle/(2 * math.pi/60))}');
    // print( '시작각 : ${startAngle} , 클릭각 : ${clickAngle}, 차이각 : ${sweepAngle}, 임시 : ${(math.pi/2-clickAngle)} ');

    // print(clickPoint);
    // print(clickPoint.direction);

    if(sweepAngle == 0.0 || sweepAngle == 2 * math.pi){ // 시간 꽉 채우는 경우
      Offset center = Offset(size.width / 2, size.height / 2);
      canvas.drawCircle(center, radius, paint);
    } else {
      Path path = Path()
        ..moveTo(centerX, centerY) // 중심으로 이동
        ..lineTo(centerX + radius * math.cos(startAngle), centerY + radius * math.sin(startAngle)) // 시작점으로 이동
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
        ) // 부채꼴 그리기
        ..close(); // 닫힌 도형으로 만듦

      canvas.drawPath(path, paint);
    }

    Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Paint outerPaint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    double innerRadius = size.width / 50;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, innerRadius, innerPaint);
    canvas.drawCircle(center, innerRadius, outerPaint);

    // Paint currentLinePaint = Paint()
    //   ..color = Colors.black26
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3.0;
    //
    // canvas.drawLine(
    //   Offset(centerX, centerY),
    //   Offset(centerX + radius * math.cos(sweepAngle), centerY + radius * math.sin(sweepAngle)),
    //   currentLinePaint,
    // );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class pizzaTypeBase extends StatefulWidget {
  @override
  _pizzaTypeStateBase createState() => _pizzaTypeStateBase();
}

class _pizzaTypeStateBase extends State<pizzaTypeBase> {

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        size: Size(350.0, 350.0), // 원하는 크기로 지정
        painter: pizzaTypeBasePainter(
            context : context,
        ),
      );
  }
}

class pizzaTypeBasePainter extends CustomPainter {
  BuildContext context;

  pizzaTypeBasePainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {

    double radius = size.width / 2;

    for(int angle = 0 ; angle < 360 ; angle+=5){
      int subRadius = 0;
      final Paint paint = Paint()
        ..color = Colors.grey;

      if(angle%30 == 0){
        paint..strokeWidth = 3.0;
        subRadius = 3;
      } else {
        paint..strokeWidth = 1.0;
        subRadius = 0;
      }

      final double radians = angle * (math.pi / 180); // 각도를 라디안으로 변환

      final double startX = size.width / 2 + (radius - 4) * math.cos(radians);
      final double startY = size.height / 2 + (radius - 4) * math.sin(radians);

      final double endX = size.width / 2 + (radius + subRadius + 4) * math.cos(radians);
      final double endY = size.height / 2 + (radius + subRadius + 4) * math.sin(radians);

      // 원의 둘레를 따라 직선 그리기
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
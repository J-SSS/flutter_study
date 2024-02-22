import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import 'package:flutter_study/time_timer/bottom_bar.dart';
import 'package:flutter_study/time_timer/listener/app_config.dart';
import 'package:flutter_study/time_timer/listener/time_config.dart';
import 'package:flutter_study/time_timer/list_drawer.dart';
import 'package:flutter_study/time_timer/timer_utils.dart' as utils;

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 이유 찾아보기

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimeConfigListener()),
        ChangeNotifierProvider(create: (context) => AppConfigListener()),
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
        // backgroundColor: Colors.green,
        title: Text('타이틀 들어갈 자리'),
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {
        //       Scaffold.of(context).openEndDrawer();
        //     },
        //   ),
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // 팝업 메뉴에서 선택된 항목에 대한 동작 수행
              print('Selected: $value');
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'item1',
                child: Text('Item 1'),
              ),
              PopupMenuItem<String>(
                value: 'item2',
                child: Text('Item 2'),
              ),
              PopupMenuItem<String>(
                value: 'item3',
                child: Text('Item 3'),
              ),
            ],
          ),
        ],
      ),
      drawer: ListDrawer(), // 보조 화면
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                children: [], // 시간 직접입력(손목시계 버튼), 테마버튼, 60min
              ),
            ),
            Stack(children: [
              pizzaTypeBase(),
              pizzaType(),
            ]),
            SizedBox(
              height: 50,
            ),
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
  Size size = Size(350.0, 350.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        utils.showOverlayText(context);

        setState(() {
          if (!context.read<TimeConfigListener>().isPlaying ||
              context.read<TimeConfigListener>().isPause) {
            clickPoint = details.localPosition;
            context.read<TimeConfigListener>().ableEdit = true;
          }
        });

        angleToMin(details.localPosition, size);
      },
      child: CustomPaint(
        size: Size(350.0, 350.0), // 원하는 크기로 지정
        painter: pizzaTypePainter(
          context: context,
          clickPoint: clickPoint,
          remainTime: context.watch<TimeConfigListener>().remainTime,
        ),
      ),
    );
  }

  // 클릭 위치를 1/60 시간 단위로 변환
  void angleToMin(Offset clickPoint, Size size) {
    var angleToMin;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    double startAngle = -math.pi / 2; // 12시 방향에서 시작
    double clickAngle =
        math.atan2(clickPoint.dy - centerY, clickPoint.dx - centerX);
    double sweepAngle;

    if (clickAngle > -math.pi && clickAngle < startAngle) {
      // 180 ~ -90(270)도
      sweepAngle = 2 * math.pi + clickAngle - startAngle;
    } else {
      // -90 ~ 180도
      sweepAngle = clickAngle - startAngle;
    }

    angleToMin = (sweepAngle / (2 * math.pi / 60)).floor();
    angleToMin == 0 ? angleToMin = 60 : angleToMin;

    context.read<TimeConfigListener>().setRemainTime = angleToMin;
  }
}

class pizzaTypePainter extends CustomPainter {
  final Offset clickPoint;
  BuildContext context;
  int? remainTime;

  pizzaTypePainter({
    required this.context,
    required this.clickPoint,
    this.remainTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = Colors.red
      // ..color = Color(0xFF56B5B7) // 진한 민트
      ..color = Color.fromRGBO(106,211,211, 1.0) // 민트
      ..style = PaintingStyle.fill; // 채우기로 변경

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    double startAngle = -math.pi / 2; // 12시 방향에서 시작
    double clickAngle =
        math.atan2(clickPoint.dy - centerY, clickPoint.dx - centerX);
    double sweepAngle;

    if (clickAngle > -math.pi && clickAngle < startAngle) {
      // 180 ~ -90(270)도
      sweepAngle = 2 * math.pi + clickAngle - startAngle;
    } else {
      // -90 ~ 180도
      sweepAngle = clickAngle - startAngle;
    }

    var angleToMin = (sweepAngle / (2 * math.pi / 60)).floor();

    // context.read<TimeConfigListener>().remainTime = angleToMin;
    sweepAngle = (2 * math.pi) / 60 * angleToMin;

    if (!context.read<TimeConfigListener>().ableEdit) {
      if (context.read<TimeConfigListener>().isPlaying ||
          context.read<TimeConfigListener>().isPause) {
        final remainTime = this.remainTime;
        if (remainTime != null) {
          sweepAngle = (2 * math.pi) / 60 * remainTime;
        }
      }
    }

    // print(2 * math.pi/60); // 0.10471975511965977
    // print(sweepAngle/(2 * math.pi/60));

    // print('내림각도 : ${(sweepAngle/(2 * math.pi/60)).floor()}, 원본각도 : ${(sweepAngle/(2 * math.pi/60))}');
    // print( '시작각 : ${startAngle} , 클릭각 : ${clickAngle}, 차이각 : ${sweepAngle}, 임시 : ${(math.pi/2-clickAngle)} ');

    // print(clickPoint);
    // print(clickPoint.direction);

    if (sweepAngle == 0.0 || sweepAngle == 2 * math.pi) {
      // 시간 꽉 채우는 경우
      Offset center = Offset(size.width / 2, size.height / 2);
      canvas.drawCircle(center, radius, paint);
    } else {
      Path path = Path()
        ..moveTo(centerX, centerY) // 중심으로 이동
        ..lineTo(centerX + radius * math.cos(startAngle),
            centerY + radius * math.sin(startAngle)) // 시작점으로 이동
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
        context: context,
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

    for (int angle = 0; angle < 360; angle += 6) {
      int subRadius = 0;
      final Paint paint = Paint()..color = Colors.grey;

      if (angle % 30 == 0) {
        paint..strokeWidth = 3.0;
        subRadius = 3;
      } else {
        paint..strokeWidth = 1.0;
        subRadius = 0;
      }

      final double radians = angle * (math.pi / 180); // 각도를 라디안으로 변환

      final double startX = size.width / 2 + (radius - 4) * math.cos(radians);
      final double startY = size.height / 2 + (radius - 4) * math.sin(radians);

      final double endX =
          size.width / 2 + (radius + subRadius + 4) * math.cos(radians);
      final double endY =
          size.height / 2 + (radius + subRadius + 4) * math.sin(radians);

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

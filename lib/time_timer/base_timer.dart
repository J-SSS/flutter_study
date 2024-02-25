import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

import 'package:flutter_study/time_timer/bottom_bar.dart';
import 'package:flutter_study/time_timer/utils/app_config.dart';
import 'package:flutter_study/time_timer/utils/time_config.dart';
import 'package:flutter_study/time_timer/list_drawer.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  // GlobalKey 생성
  // final GlobalKey<_PizzaTypeState> pizzaTypeKey = GlobalKey<_PizzaTypeState>();



  @override
  Widget build(BuildContext context) {
    late Size mainSize;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<AppConfigListener>().setMediaQuery = MediaQuery.of(context);
      print('### 미디어쿼리 정보 ###');
      print(MediaQuery.of(context));
      print('### 미디어쿼리 정보 ###');

      double painterSize = context.read<AppConfigListener>().painterSize;
      mainSize = Size(painterSize,painterSize);
    });
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.green,
        title: Text('타이틀 들어갈 자리'),
        toolbarHeight: MediaQuery.of(context).size.height / 10,
      ),
      drawer: ListDrawer(), // 보조 화면
      body: Center(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * (6 / 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      // 60mins 라인
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 105,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.00),
                            // 테두리 둥글기 설정
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3), // 음영의 위치 조절
                              ),
                            ],
                          ),
                          child: TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  // Icon(Icons.timer_outlined),
                                  Icon(Icons.hourglass_empty_sharp),
                                  Text(
                                    ' 60 mins',
                                    style: TextStyle(fontSize: 14),
                                  )
                                  // 누르면 다이어로그가 뜨면서 알람/타이머 및 목표시간/토탈타임 설정 할 수 있게
                                ],
                              )),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onPanUpdate: (point) {
                        utils.showOverlayText(context);
                        Offset clickPoint = point.localPosition;
                        int angleToMin =
                            utils.angleToMin(clickPoint, Size(350,350));
                        context.read<TimeConfigListener>().setSetupTime =
                            angleToMin;
                      },
                      child: Stack(children: [
                        PizzaTypeBase(size : Size(350,350)),
                        PizzaType(size : Size(350,350),
                          isOnTimer: false,
                          setupTime:
                              context.read<TimeConfigListener>().setupTime,
                        ),
                      ]),
                    )
                  ],
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * (2.6 / 10),
              child: const ButtomBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class PizzaType extends StatefulWidget {
  bool isOnTimer = false;
  int setupTime;
  Size size;

  PizzaType({super.key,required this.size, required this.isOnTimer, required this.setupTime});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeState();
  }
}

class _PizzaTypeState extends State<PizzaType> {
  late Timer _timer;

  _PizzaTypeState();

  @override
  void initState() {
    if (widget.isOnTimer) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        widget.setupTime -= 1;
        if(widget.setupTime > -1){
          setState(() { print('남은 시간 : ${widget.setupTime}'); });
        } else {
          _timer.cancel();
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
      painter: PizzaTypePainter(
        angleToMin: widget.isOnTimer ? widget.setupTime : context.watch<TimeConfigListener>().setupTime,
      ),
    );
  }
}

class PizzaTypePainter extends CustomPainter {
  int angleToMin;

  PizzaTypePainter({
    required this.angleToMin,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = Colors.red
      // ..color = Color(0xFF56B5B7) // 진한 민트
      ..color = Color.fromRGBO(106, 211, 211, 1.0) // 민트
      ..style = PaintingStyle.fill; // 채우기로 변경

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2;

    double startAngle = -math.pi / 2; // 12시 방향에서 시작

    var sweepAngle = (2 * math.pi) / 60 * angleToMin!;

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

class PizzaTypeBase extends StatefulWidget {
  Size size;

  PizzaTypeBase({required this.size});

  @override
  State<StatefulWidget> createState() {
    return _PizzaTypeStateBase();
  }
}

class _PizzaTypeStateBase extends State<PizzaTypeBase> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size, // 원하는 크기로 지정
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
        paint..strokeWidth = 3.5;
        subRadius = 3;
      } else {
        paint..strokeWidth = 1.0;
        subRadius = 0;
      }

      final double radians = angle * (math.pi / 180); // 각도를 라디안으로 변환

      final double startX = size.width / 2 + (radius - 8) * math.cos(radians);
      final double startY = size.height / 2 + (radius - 8) * math.sin(radians);

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

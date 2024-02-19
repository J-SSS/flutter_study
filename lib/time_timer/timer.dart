import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_study/time_timer/buttom_bar.dart';
import 'package:flutter_study/time_timer/list_drawer.dart';


class configObserver with ChangeNotifier {

  /*
  - 남은 시간 표시 여부
  - 초침 표시

  - 입력 / 특정 시간까지

  - 작동 중 메뉴 숨김
  - 꽉 채운 원으로 시작
  - 알림 스타일 (소리 / 진동 / 무음)
  - 알림시 화면 효과
  - 알림 종료(자동, 정지 할 때 까지)

  - 중간 알림 (설정 안함 / 분 / 초)
  - 중간 알림 스타일 (소리 / 진동 / 무음)
  - 종료임박시 깜빡임 (설정 안함 / 분 / 초)

  - 위젯 만들 수 있나?

  - 테마 설정
  - 후원
  - 피드백
  - 오픈소스라이선스

  //////////반복기능//////////
  반복없음 / 현재 반복 / 프리셋 순서대로


  //////////사전설정//////////
  순서 변경 기능
   */

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
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
            options: CarouselOptions(
                height: 400,
                aspectRatio: 16 / 9, // 화면 비율(16/9)
                viewportFraction: 1.0, // 페이지 차지 비율(0.8)
                autoPlay: false, // 자동 슬라이드(false)
                autoPlayInterval: const Duration(seconds: 4), // 자동 슬라이드 주기(4seconds)
                onPageChanged: ((index, reason) { // 페이지가 슬라이드될 때의 기능 정의
                  print('미디어쿼리');
                  print(MediaQuery.of(context).size);
                }),
            ),
            items: ['pizza','battery','heart','spped'].map((type) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(3, -5), // 음영의 위치 조절
                          ),
                        ]
                      ),
                      child: Text('text ${type}', style: TextStyle(fontSize: 16.0),)
                  );
                },
              );
            }).toList()),
            // Stack(
            //   children:[
            //     pizzaTypeBase(),
            //     pizzaType(),
            //   ]
            // ),
            SizedBox(height: 90,),
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
          showOverlayText(context);

          setState(() {
            if(!context.read<TimeObserver>().isPlaying || context.read<TimeObserver>().isPause) {
              clickPoint = details.localPosition;
              context.read<TimeObserver>().ableEdit = true;
            }
          });

          angleToMin(details.localPosition, size);
      },
      child: CustomPaint(
        size: Size(350.0, 350.0), // 원하는 크기로 지정
        painter: pizzaTypePainter(
            context : context,
            clickPoint: clickPoint,
            remainTime: context.watch<TimeObserver>().remainTime,
            callbackFunc: callbackFunc
        ),
      ),
    );
  }

  // 클릭 위치를 1/60 시간 단위로 변환
  void angleToMin (Offset clickPoint, Size size){

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

    // print(angleToMin);

  }

  void callbackFunc (BuildContext context, angleToMin){

  }

  void showOverlayText(BuildContext context) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height / 2 - 110.0,
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
                '60:00',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
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

}

class pizzaTypePainter extends CustomPainter {
  final Offset clickPoint;
  BuildContext context;
  int? remainTime;

  Function? callbackFunc;

  pizzaTypePainter({required this.context, required this.clickPoint, this.remainTime, this.callbackFunc});

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

    for(int angle = 0 ; angle < 360 ; angle+=6){
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

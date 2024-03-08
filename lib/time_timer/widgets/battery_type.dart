import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/provider/timer_controller.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';

class BatteryType extends StatefulWidget {
  bool isOnTimer = false;
  int setupTime;
  Size size;

  BatteryType({super.key,required this.size, required this.isOnTimer, required this.setupTime});

  @override
  State<StatefulWidget> createState() {
    return _BatteryTypeState();
  }
}

class _BatteryTypeState extends State<BatteryType> {

  _BatteryTypeState();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size, // 원하는 크기로 지정
      painter: BatteryTypePainter(
        setupTime: widget.isOnTimer ? widget.setupTime : context.watch<TimerController>().setupTime
      ),
    );
  }
}

class BatteryTypePainter extends CustomPainter {
  int setupTime;

  BatteryTypePainter({
    required this.setupTime});

  @override
  void paint(Canvas canvas, Size size) {
    if(setupTime == 0) return;

    Paint paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    double sizeH = size.height;
    double sizeW = size.width;

    double strokeW = (sizeH * 0.03).floorToDouble(); // 선 굵기 3프로
    double paddingL = (sizeH * 0.15).floorToDouble(); // 시간 부분 패딩 사이즈

    double netH = sizeH - (strokeW * 3); // 배경 여백 밑 테두리 제외한 높이 좌표
    double netLength = sizeH - (strokeW * 6); // 상, 하 여백 밑 테두리 제외한 빈공간 절대높이

    double sectionGap = (sizeH * 0.015).floorToDouble(); // 섹션 사이의 거리 // ex) 7
    double sectionLength = (netLength - sectionGap * 9) / 10; // ex) 33.231428571428566
    double sectionAmount = sectionLength + sectionGap; // gap 포함한 섹션 크기 ex) 40정도

    int drawCnt = 0;
    int remainMin = 0;
    double minToPoint = 0.0;
    Map<int,double> sectionMap = {};

    for(int i = 0 ; i<10 ; i++){
      sectionMap[i] = netH - (sectionAmount * (i+1) - sectionGap); // 섹션의 상단
    }
    remainMin = (setupTime % 6).floor();
    drawCnt = remainMin == 0 ? (setupTime / 6).floor() - 1 : (setupTime / 6).floor();

    double btm = netH - (sectionAmount * drawCnt);
    double top = netH - (sectionAmount * (drawCnt+1) - sectionGap);
    double gap = (btm-top)/6;

    if(remainMin != 0){
      minToPoint = remainMin * gap;
    } else {
      minToPoint = 6 * gap;
    }

    double radius = 7.0;
    Rect rect;
    RRect rRect;

    if(drawCnt <= 2){
      paint.color = Colors.red;
    } else if (drawCnt <= 5) {
      paint.color = Colors.orange;
    } else {
      paint.color = Colors.greenAccent;
    }

    if(drawCnt == 0){ // 한 칸만 있을 때

      /** 좌표에 따라 그려지는 부분 */
      rect  = Rect.fromLTRB(paddingL, netH-minToPoint, sizeW-paddingL, netH);
      rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(rRect, paint);

    } else if(drawCnt < 10) { // 두 칸 이상일 때

      /** 꽉 찬 섹션 부분 */
      for(int i = 0 ; i < drawCnt ; i++){
        double? sectionTop = sectionMap[i];
        rect  = Rect.fromLTRB(paddingL, sectionTop!, sizeW-paddingL, sectionTop!+sectionLength);
        rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
        canvas.drawRRect(rRect, paint);
      }

      /** 좌표에 따라 그려지는 부분 */
      double? sectionBtm = sectionMap[drawCnt-1]!-sectionGap;
      rect  = Rect.fromLTRB(paddingL, sectionBtm!-minToPoint, sizeW-paddingL, sectionBtm!);
      rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(rRect, paint);

    }
    }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BatteryTypeBase extends StatelessWidget{
  Size size;

  BatteryTypeBase({super.key,required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size, // 원하는 크기로 지정
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


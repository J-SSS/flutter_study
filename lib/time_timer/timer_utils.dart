import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/base_timer.dart';

import 'package:flutter_study/time_timer/listener/app_config.dart';
import 'package:flutter_study/time_timer/listener/time_config.dart';

/** 설정한 시간을 Overlay 위젯으로 표시 */
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
              context.select(
                  (TimeConfigListener t) => t.remainTime.toString() + " mins"),
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 30,
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

/** OnTimer 화면에서 바텀 바를 Overlay위젯으로 표시 */
void showOverlayBottomBar(BuildContext context) {
  OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height - 100.0,
      left: MediaQuery.of(context).size.width / 2 - 50.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          child: Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: CircleBorder(), // 동그란 모양을 지정
                padding: EdgeInsets.all(10.0), // 아이콘과 버튼의 경계
                fixedSize: Size(90.0, 90.0), // 버튼의 크기를 지정
              ),
              child: Image.asset(
                // 'assets/icon/${context.select((TimeObserver t) => t.playBtn)}.png',
                'assets/icon/btm_play.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);
  // Overlay.of(context).
  // print

  // 1초 후에 OverlayEntry를 제거하여 텍스트를 사라지게 함
  Future.delayed(Duration(milliseconds: 1500), () {
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

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/timer.dart';


// class TimerUtils

// 오버레이
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
              context.select((TimeObserver t) => t.remainTime.toString() + ":00"),
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
import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'package:flutter_study/time_timer/timer_utils.dart' as utils;

class OnTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:GestureDetector(
        onTap: () {
          utils.showOverlayBottomBar(context);
          // setState(() {
          //   });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey.withOpacity(0.1),
        ),
      )
    );
  }

  // @override
  // State<StatefulWidget> createState() {
  //   return print("object");
  // }

  // @override
  // _OnTimerScreen createState() => _OnTimerScreenState();
}


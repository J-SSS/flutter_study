import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:provider/provider.dart';

import '../utils/time_config.dart';

class OnTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        utils.showOverlayBottomBar(context);
        // setState(() {
        //   });
      },
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Stack(
              children: [
                PizzaTypeBase(size: Size(350,350),),
                PizzaType(size: Size(350,350), isOnTimer: true, setupTime : context.read<TimeConfigListener>().setupTime),
              ],
            ),
          )),
    ));
  }

// @override
// State<StatefulWidget> createState() {
//   return print("object");
// }

// @override
// _OnTimerScreen createState() => _OnTimerScreenState();
}

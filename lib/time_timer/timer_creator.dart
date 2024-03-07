import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/provider/timer_controller.dart';
import 'package:flutter_study/time_timer/widgets/battery_type.dart';
import 'package:flutter_study/time_timer/widgets/pizza_type.dart';
import 'package:provider/provider.dart';

class TimerCreator extends StatelessWidget {
  // 타이머 받아서 처리

  String type = 'pizza';

  @override
  Widget build(BuildContext context) {
    Size mainSize = MediaQuery.sizeOf(context);

    switch (type) {
      case ('pizza'):
        {
          return Stack(children: [
            PizzaTypeBase(size: Size(350, 350)),
            PizzaType(
              size: Size(350, 350),
              isOnTimer: false,
              setupTime: context.read<TimerController>().setupTime,
            ),
          ]);
        }
      case ('battery'):
        {
          return Stack(children: [
            BatteryTypeBase(size: Size(mainSize.width, mainSize.height)),
            BatteryType(
                size: Size(mainSize.width, mainSize.height),
                isOnTimer: false,
                setupTime: context.read<TimerController>().setupTime,
                clickPoint: context.read<TimerController>().clickPoint),
          ]);
        }
      default:
        return SizedBox();
    }
  }
}

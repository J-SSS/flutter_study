import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';
import 'package:flutter_study/time_timer/provider/on_timer_listener.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/widgets/pizza_type.dart';

import '../provider/time_config.dart';

class OnTimerScreen extends StatelessWidget {
  bool isVisible = true;

  final GlobalKey<_onTimerBottomBarState> keyTest = GlobalKey<_onTimerBottomBarState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          isVisible = false;
          context.read<AppConfigListener>().setOnTimerBottomView = true;
          print('터치');
          // utils.showOverlayBottomBar(context);
          // setState(() {
          //   });
        },
        child: Center(
          child: Stack(
            children: [
              Positioned(
                top: 200,
                left: 30,
                child: PizzaTypeBase(
                  size: Size(350, 350),
                ),
              ),
              Positioned(
                top: 200,
                left: 30,
                child: PizzaType(
                    size: Size(350, 350),
                    isOnTimer: isVisible,
                    setupTime: context.read<TimeConfigListener>().setupTime),
              ),
              Positioned(
                bottom: 0,
                child: OnTimerBottomBar(key : keyTest),
              ),
            ],
          ),
        ),
      ),
    );
  }

// @override
// State<StatefulWidget> createState() {
//   return print("object");
// }

// @override
// _OnTimerScreen createState() => _OnTimerScreenState();
}

// Visibility(
// visible: context.watch<AppConfigListener>().isOnTimerBottomViewYn,
// child:  Container(
// width: MediaQuery.of(context).size.width,
// height: 150,
// color: Colors.green,
// ),
// )

class OnTimerBottomBar extends StatefulWidget {

  // const OnTimerBottomBar({Key? key}) : super(key: key);
  const OnTimerBottomBar({super.key});

  void testFunc(){
    print('키!');
  }

  @override
  State<StatefulWidget> createState() => _onTimerBottomBarState();
}

class _onTimerBottomBarState extends State<OnTimerBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      // visible: context.watch<AppConfigListener>().isOnTimerBottomViewYn,
      visible: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180, // jdi 높이 수정 필요함
        color: Colors.grey.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // print(widget.key);
                context.read<TimerViewModel>().loadTimer();

                context.read<OnTimerListener>().setIsPlaying = false;
                // widget.key?.currentState?.testFunc();
              },
              child: Text('정지'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('닫기'),
            ),
          ],
        )



      ),
    );
  }
}

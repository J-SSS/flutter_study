import 'package:flutter/material.dart';

import 'package:flutter_study/time_timer/provider/on_timer_listener.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';
import 'package:flutter_study/time_timer/provider/time_config.dart';
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';
import 'package:flutter_study/time_timer/repository/timer_repository.dart';

import 'package:provider/provider.dart';

import 'package:flutter_study/time_timer/widgets/bottom_bar.dart';
import 'package:flutter_study/time_timer/widgets/pizza_type.dart';
import 'package:flutter_study/time_timer/widgets/battery_type.dart';

import 'package:flutter_study/time_timer/list_drawer.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimeConfigListener()),
        ChangeNotifierProvider(create: (context) => AppConfigListener()),
        ChangeNotifierProvider(create: (context) => OnTimerListener()),
        ChangeNotifierProvider(
            create: (context) => TimerViewModel(TimerRepository(prefs))),
        // shared preferences 컨트롤
      ],
      child: MaterialApp(
        title: 'My Time Timer',
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
    Offset clickPoint = Offset(150, -150);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // jdi 찾아보기
      context.read<AppConfigListener>().setMediaQuery = MediaQuery.of(context);
      print('### 미디어쿼리 정보 ###');
      print(MediaQuery.of(context));

      double painterSize = context.read<AppConfigListener>().painterSize;
      mainSize = Size(painterSize, painterSize);
    });
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.green,
        title: Text('타이틀 들어갈 자리'),
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height / 10,
      ),
      drawer: ListDrawer(), // 보조 화면
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * (6 / 10),
                child: Center(
                  child:
                  // GestureDetector(
                  //   onPanUpdate: (point) {
                  //     utils.showOverlayText(context);
                  //     Offset clickPoint = point.localPosition;
                  //     int angleToMin =
                  //         utils.angleToMin(clickPoint, Size(350, 350));
                  //     context.read<TimeConfigListener>().setSetupTime =
                  //         angleToMin;
                  //   },
                  //   child: Stack(children: [
                  //     PizzaTypeBase(size: Size(350, 350)),
                  //     PizzaType(
                  //       size: Size(350, 350),
                  //       isOnTimer: false,
                  //       setupTime: context.read<TimeConfigListener>().setupTime,
                  //     ),
                  //   ]),
                  // ),
                  GestureDetector(
                    onPanUpdate: (point) {
                      // utils.showOverlayText(context);

                      Rect.fromPoints(point.globalPosition, point.globalPosition);
                      clickPoint = point.localPosition;
                      int angleToMin =
                      utils.angleToMin(clickPoint, Size(350, 350));
                      context.read<TimeConfigListener>().setSetupTime =
                          angleToMin;
                      context.read<TimeConfigListener>().setClickPoint =
                          clickPoint;
                    },
                    child: Stack(children: [
                      // BatteryType(clickPoint: clickPoint)
                      BatteryTypeBase(size: Size(350, 350)),
                      BatteryType(
                        size: Size(350, 350),
                        isOnTimer: false,
                        setupTime: context.read<TimeConfigListener>().setupTime,
                      clickPoint: context.read<TimeConfigListener>().clickPoint
                      ),
                    ]),
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * (2.0 / 10),
              child: const ButtomBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

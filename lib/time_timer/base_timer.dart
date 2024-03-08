import 'package:flutter/material.dart';
import 'package:flutter_study/main.dart';
import 'dart:developer';

import 'package:flutter_study/time_timer/provider/timer_controller.dart';
import 'package:flutter_study/time_timer/provider/app_config.dart';

import 'package:flutter_study/time_timer/utils/isolate_timer.dart';
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';
import 'package:flutter_study/time_timer/repository/timer_repository.dart';

import 'package:provider/provider.dart';

import 'package:flutter_study/time_timer/widgets/bottom_bar.dart';
import 'package:flutter_study/time_timer/widgets/pizza_type.dart';
import 'package:flutter_study/time_timer/widgets/battery_type.dart';

import 'package:flutter_study/time_timer/list_drawer.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_study/time_timer/screen/setting_screen.dart' as setting_screen;

class ProviderTest  extends StatelessWidget{
  ProviderTest(){
    print('이게되네?');
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 200, height: 200, color: Colors.red,child: Text('dddddddddddddd'),);
  }
}


class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerViewModel(TimerRepository(prefs)), lazy: false,), // shared preference
        ChangeNotifierProvider(create: (context) => TimerController(), lazy: false, child: ProviderTest(),), // isolate timer
        ChangeNotifierProvider(create: (context) => AppConfigListener()),
      ],
      child: MaterialApp(
        title: 'My Time Timer',
          theme: ThemeData(
            // expansionTileTheme: ExpansionTileThemeData(
            //   // tilePadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            //   // childrenPadding : EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            //   backgroundColor: Colors.grey[200],
            //   textColor: Colors.blue,
            // ),
          ),
        home:  MyTimeTimer()),
    );
  }
}



class MyTimeTimer extends StatelessWidget {
// GlobalKey 생성
  // final GlobalKey<_PizzaTypeState> pizzaTypeKey = GlobalKey<_PizzaTypeState>();

  late Size mediaSize;

  bool isPortrait(Size size){
    double w = size.width;
    double h = size.height;

    // Orientation.portrait: 세로 방향
    // Orientation.landscape: 가로 방향

    if(h > w) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.sizeOf(context);
    AppManager.log('메인 생성');
    // 초기화
    context.read<TimerViewModel>().loadPreset();

    late Size mainSize = MediaQuery.sizeOf(context);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // print('초기화');
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('My Time Timer'),
        centerTitle: true,
        toolbarHeight: mainSize.height / 10,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => setting_screen.SettingScreen()),
              );
            },
            icon: Icon(Icons.settings),
            color: Colors.grey,
          )
        ],
      ),
      drawer: ListDrawer(), // 보조 화면
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: mainSize.height * (6 / 10),
                child: Center(
                  child:
                  // GestureDetector(
                  //   onPanUpdate: (point) {
                  //     utils.showOverlayText(context);
                  //     Offset clickPoint = point.localPosition;
                  //     int clickToMin = utils.angleToMin(clickPoint, Size(350, 350));
                  //     context.read<TimerController>().setSetupTime = clickToMin;
                  //   },
                  //   child: Stack(children: [
                  //     PizzaTypeBase(size: Size(350, 350)),
                  //     PizzaType(
                  //       size: Size(350, 350),
                  //       isOnTimer: false,
                  //       setupTime: context.read<TimerController>().setupTime,
                  //     ),
                  //   ]),
                  // ),
                  GestureDetector(
                    onPanUpdate: (point) {
                      utils.showOverlayText(context);
                      Offset clickPoint = point.localPosition;
                      int clickToMin = utils.clickToMin2(clickPoint, mediaSize);
                      context.read<TimerController>().setSetupTime = clickToMin;
                    },
                    child: Stack(children: [
                      BatteryTypeBase(
                          size: Size(mainSize.width, mainSize.height)),
                      BatteryType(
                          size: Size(mainSize.width, mainSize.height),
                          isOnTimer: false,
                          setupTime:
                          context.read<TimerController>().setupTime),
                    ]),
                  ),
                )),
            SizedBox(
              height: mainSize.height * (2.0 / 10),
              child: ButtomBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
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
import 'package:flutter_study/time_timer/screen/setting_screen.dart' as setting_screen;


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

class ResponsiveApp {
  static MediaQueryData? _mediaQueryData;

  MediaQueryData? get mq => _mediaQueryData;

  static void setMq(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
  }
}

class MyTimeTimer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyTimeTimerState();
}

class _MyTimeTimerState extends State<MyTimeTimer> with AutomaticKeepAliveClientMixin{
// GlobalKey 생성
  // final GlobalKey<_PizzaTypeState> pizzaTypeKey = GlobalKey<_PizzaTypeState>();
  late MediaQueryData mediaQueryData;
  late Size mediaSize;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    // 초기화
    context.read<TimerViewModel>().loadPreset();
    //
    // mediaQueryData = MediaQuery.of(context);
    // mediaSize = mediaQueryData.size;
    print('### 메인 위젯 빌드 ###');
    late Size mainSize = MediaQuery.sizeOf(context);
    print(mainSize);

    Offset clickPoint = Offset(150, -150);

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   // jdi 찾아보기
    //   context.read<AppConfigListener>().setMediaQuery = MediaQuery.of(context);

    //   double painterSize = context.read<AppConfigListener>().painterSize;
    // });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: Colors.green,
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
                  // child:Text(''),
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

                      clickPoint = point.localPosition;
                      context.read<TimeConfigListener>().setClickPoint =
                          clickPoint;

                      int angleToMin =
                      utils.angleToMin(clickPoint, Size(350, 350));
                      context.read<TimeConfigListener>().setSetupTime =
                          angleToMin;
                    },
                    child: Stack(children: [
                      // BatteryType(clickPoint: clickPoint)
                      BatteryTypeBase(
                          size: Size(mainSize.width, mainSize.height)),
                      BatteryType(
                          size: Size(mainSize.width, mainSize.height),
                          isOnTimer: false,
                          setupTime:
                          context.read<TimeConfigListener>().setupTime,
                          clickPoint:
                          context.read<TimeConfigListener>().clickPoint),
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
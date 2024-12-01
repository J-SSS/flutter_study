import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:flutter_study/time_timer/widgets/pizza_type.dart';
import 'package:flutter_study/time_timer/screen/select_item_screen.dart' as select_item_screen;
import 'package:provider/provider.dart';

import '../provider/time_config.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('타이틀을 입력 하세요.'),
          toolbarHeight: MediaQuery.of(context).size.height / 10,
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * (6 / 10),
                child: Center(
                  child: Stack(
                    children: [
                      PizzaTypeBase(
                        size: Size(350, 350),
                      ),
                      PizzaType(
                          size: Size(350, 350),
                          isOnTimer: false,
                          setupTime:
                              context.read<TimeConfigListener>().setupTime),
                    ],
                  ),
                )),
            SizedBox(
                height: MediaQuery.of(context).size.height * (2.0 / 10),
                child: Column(
                  children: [
                    Container(
                      width: 320.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5), width: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildItemButton(context),
                          _buildItemButton(context),
                          _buildItemButton(context),
                          _buildItemButton(context),
                          _buildItemButton(context),
                          _buildItemButton(context),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: 95.0,
                      height: 50.0,
                      color: Colors.transparent, // Container의 배경색
                      child: ElevatedButton(
                        onPressed: () {
                          // 버튼이 클릭되었을 때의 동작 추가
                          print('Button clicked!');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // 모서리를 둥글게 만듭니다.
                          ),
                        ),
                        child: Text(
                          'O K',
                          style: TextStyle(
                            color: Colors.white, // 텍스트 색상
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        )));
  }

  Widget _buildItemButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(), // 동그랗게 그림자를 만듭니다.
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: () {
          select_item_screen.CustomDialog.show(context);
        },
        child: Icon(
          Icons.add_circle_rounded,
          color: Colors.grey.withOpacity(0.2),
          size: 50,
        ),
      ),
    );
  }
}

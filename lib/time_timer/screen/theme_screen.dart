import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/base_timer.dart';
import 'package:flutter_study/time_timer/utils/timer_utils.dart' as utils;
import 'package:provider/provider.dart';

import '../utils/time_config.dart';

class ThemeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('테마 선택'),
          toolbarHeight: MediaQuery.of(context).size.height / 10,
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '텍스트 입력', // 플레이스홀더 설정
                          border: OutlineInputBorder(), // 텍스트 필드의 외곽선 설정
                        ),
                      ),
                    )),
                SizedBox(height: 50,),
                Stack(
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
                SizedBox(
                  height: 50,
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorButton(Colors.red),
                      _buildColorButton(Colors.orange),
                      _buildColorButton(Colors.yellow),
                      _buildColorButton(Colors.green),
                      _buildColorButton(Colors.blue),
                      _buildColorButton(Colors.indigo),
                      _buildColorButton(Colors.purple),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 95.0,
                  height: 50.0,
                  color: Colors.white, // Container의 배경색
                  child: ElevatedButton(
                    onPressed: () {
                      // 버튼이 클릭되었을 때의 동작 추가
                      print('Button clicked!');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // 버튼 색상
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
            ))));
  }

  Widget _buildColorButton(Color color) {
    return Material(
      elevation: 5.0,
      color: Colors.transparent,
      shape: CircleBorder(), // 동그랗게 그림자를 만듭니다.
      child: InkWell(
        borderRadius: BorderRadius.circular(50.0),
        onTap: () {
          // 버튼이 클릭되었을 때의 동작 추가
          print('Button clicked! Color: $color');
        },
        child: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

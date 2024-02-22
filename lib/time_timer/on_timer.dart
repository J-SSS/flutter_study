import 'package:flutter/material.dart';
import 'package:flutter_study/time_timer/timer.dart';

class OnTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height-100,color: Colors.red,),
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.00), // 테두리 둥글기 설정
          ),
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: CircleBorder(), // 동그란 모양을 지정
              padding: EdgeInsets.all(10.0), // 아이콘과 버튼의 경계
              fixedSize: Size(90.0, 90.0), // 버튼의 크기를 지정
            ),
            // child: Icon(context.select((TimeObserver t) => t.playBtn)),
            child: Image.asset(
              // 'assets/icon/${context.select((TimeObserver t) => t.playBtn)}.png',
              'assets/icon/btm_play.png',
              width: 120.0,
              height: 120.0,
            ),
          ),
        ),
      ],
    ));
  }
}

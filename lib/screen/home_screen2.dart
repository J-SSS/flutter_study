import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // service 패키지
import 'dart:async'; // async 패키지 > Timer 위젯 사용하기 위해 필요


class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  // StatefulWidget은 createState() 함수를 정의해야 하며, State를 반환한다.
 @override
 State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  PageController pageController = PageController(); // PageView를 조작하기 위함

  // initState 함수를 오버라이드하면 statefulWidget 생명주기에서 initState 함수를 사용할 수 있다.
  // 모든 initState() 함수는 부모의 initState() 함수를 실행해줘야 한다.

  @override
  void initState(){
    super.initState(); // 부모 initState() 실행

    Timer.periodic( // Timer.periodic() 등록
        Duration(seconds: 3),
        (timer) {
          // print('실행!');

          int? nextPage = pageController.page?.toInt();
          // page게터를 사용해서 현재 페이지를 가져온다
          // 페이지가 변경 중인 경우 소수점으로 표현되기 때문에 toInt()를 사용
          // animateToPage()함수 실행시 정수가 필요함

          if (nextPage == null){ // 페이지 값이 없을 때 예외 처리
            return;
          }

          if (nextPage == 4) {
            nextPage = 0;
          } else {
            nextPage++;
          }
          pageController.animateToPage
            (nextPage,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease
          );
        },
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 상태바 색상 번경
    return Scaffold(
        body : PageView(
            controller: pageController,
            children: [1,2,3,4,5]
                .map(
                    (number) => Image.asset(
                  'assets/img/image_$number.jpeg',
                  fit: BoxFit.cover, // 전체 화면 차지
                )
            )
                .toList()
        )
    );
  }
}

// class HomeScreen extends {
//
//   HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 상태바 색상 번경
//     return Scaffold(
//         body : PageView(
//             children: [1,2,3,4,5]
//                 .map(
//                     (number) => Image.asset(
//                   'assets/img/image_$number.jpeg',
//                   fit: BoxFit.cover, // 전체 화면 차지
//                 )
//             )
//                 .toList()
//         )
//     );
//   }
// }
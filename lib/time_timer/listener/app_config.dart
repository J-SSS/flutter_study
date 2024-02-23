
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppConfigListener with ChangeNotifier {
  BuildContext? context;

  late MediaQueryData mediaQuery;
  late double painterSize;

  set setMediaQuery(MediaQueryData mediaQuery){
    this.mediaQuery = mediaQuery;

    if(mediaQuery.orientation.toString() == 'portrait'){
      this.painterSize = mediaQuery.size.width * 0.85;
    } else {
      this.painterSize = mediaQuery.size.height * 0.85;
    }

  }

  /*
  - 남은 시간 표시 여부
  - 초침 표시

  - 입력 / 특정 시간까지

  - 작동 중 메뉴 숨김
  - 꽉 채운 원으로 시작
  - 알림 스타일 (소리 / 진동 / 무음)
  - 알림시 화면 효과
  - 알림 종료(자동, 정지 할 때 까지)

  - 중간 알림 (설정 안함 / 분 / 초)
  - 중간 알림 스타일 (소리 / 진동 / 무음)
  - 종료임박시 깜빡임 (설정 안함 / 분 / 초)

  - 위젯 만들 수 있나?

  - 테마 설정
  - 후원
  - 피드백
  - 오픈소스라이선스

  //////////반복기능//////////
  반복없음 / 현재 반복 / 프리셋 순서대로


  //////////사전설정//////////
  순서 변경 기능
   */
}
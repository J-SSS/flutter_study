import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TimerSetup {
  String id;
  String name;

  TimerSetup({
    required this.id,
    required this.name,
  });

  factory TimerSetup.fromJson(Map<String, dynamic> json) {
    return TimerSetup(
      id: json['id'],
      name: json['name'],
    );
  }

  // 다시 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

void test2() {
  // JSON 문자열
  String jsonString = '{"name": "John Doe", "age": 30, "isStudent": false, "grades": [90, 85, 95], "address": {"city": "New York", "zipCode": "10001"}}';

  // JSON 문자열을 Map으로 디코딩
  Map<String, dynamic> decodedMap = json.decode(jsonString);

  // Map을 Person 객체로 변환
  TimerSetup person = TimerSetup.fromJson(decodedMap);

  // 변환된 Person 객체 출력
  print(person);
}


/**
 * 1. 100%부터 표시
 * 2. 색상 변경
 * 3. 텍스트
 * 4. 남은 시간 표시.
 * 5. 알림 여부
 * 6. 중간 알림
 * 6.
 *
 *
 * parentNodeName :
 * nodeName :
 * timerConfig : {
 * type : 'pizza',
 * unit : 'min' // 설정 단위 min,sec,time
 * setupTime : 45, // 설정 시간
 * viewRemainTime : false, // 남은 시간 표시 여부
 * viewDescript : flalse, // 설명 표시 여부
 * descriptText : '123' // 설명 텍스트
 * isAlarmYn : 'N' // 알람 여부
 * alarmType :  // 알람 타입 무음/진동/소리
 * dismissAlarm : 한 번, 버튼 클릭
 * OmitAlarm : // 다음 타이머가 있으면 알림 생략
 *
 * isInterNotif : 'Y' // 중간 알림
 * notifUnit : // 알림 단위
 * notifGap : // 알림 간격
 * notifType : // 알림 타입 무음 / 진동 / 소리
 * }
 *
 *
 *
 */


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


void test() {
// JSON 데이터를 생성할 Map
  Map<String, dynamic> jsonData = {
    'name': 'John Doe',
    'age': 30,
    'isStudent': false,
    'grades': [90, 85, 95],
    'address': {
      'city': 'New York',
      'zipCode': '10001',
    },
  };

  // Map을 JSON 문자열로 인코딩
  String jsonString = json.encode(jsonData);

  // 생성된 JSON 문자열 출력
  print(jsonString);

  // JSON 문자열을 Map으로 디코딩
  Map<String, dynamic> decodedMap = json.decode(jsonString);

  // 디코딩된 Map 출력
  print(decodedMap);
}
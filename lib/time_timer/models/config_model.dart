import 'dart:convert';

class ConfigModel {
  String? id;
  String? name;

  bool? startFull; // 100%부터 시작 여부
  bool? omitAlarm; // 다음 타이머가 있을 때 알람 생략

  String? alarmType; // 알림 스타일 (소리 / 진동 / 무음)
  String? alarmEffect; // 알림시 화면 효과 // jdi 필요 없을 수 있음
  String? alarmExit; // 알림 종료(자동, 정지 할 때 까지)

  String? interAlarmType; // 중간 알림 (설정 안함 / 분 / 초)
  String? interAlarmEffect; // 중간 알림 스타일 (소리 / 진동 / 무음)

  String? interAlarm; // 종료임박시 깜빡임 (설정 안함 / 분 / 초) // jdi 더 생각해보기

  /**
      - 위젯 만들 수 있나?

      - 테마 설정
      - 후원
      - 피드백
      - 오픈소스라이선스

      //////////반복기능//////////
      반복없음 / 현재 반복 / 프리셋 순서대로
   */

  ConfigModel({
    this.id,
    this.name,
  }){
    id ?? '123';
  }

  factory ConfigModel.fromJson(Map<String, dynamic>? json) {
    if (json != null){
      return ConfigModel(
        id: json['id'],
        name: json['name'],
      );
    } else {
      return ConfigModel(
        id: 'default',
        name: 'default',
      );
    }
  }

  String toJson() { // JSON 문자열로 변환하여 반환
    // ObjTest objTest = ObjTest();
    // print('JSON테스트용 : ${json.encode(objTest)}');
    return json.encode({
      'id': id,
      'name': name,
    });
  }
}



class ObjTest {
  String parma1 = "파라미터1";
  String parma2 = "파라미터2";
  String parma3 = "파라미터3";
  String parma4 = "파라미터4";
  List<String> param5 = ['리스트1','리스트2','리스트3','리스트4',];
}
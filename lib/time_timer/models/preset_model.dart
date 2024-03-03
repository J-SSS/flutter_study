import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PresetModel {
  Map<String, Map<String, dynamic>>? preset = {};

  // String? preset;

  late Map<String, String> folder;

  get getPreset => preset;

  PresetModel({this.preset});

  factory PresetModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      Map<String, Map<String, dynamic>>? _prefsPreset = {};

      json['preset'].forEach ((key, value){
        _prefsPreset[key] = value;
        });

      return PresetModel(preset: _prefsPreset);
    } else {
      return PresetModel(
          preset: {
        UniqueKey().toString(): {'parentNodeId': '', 'nodeName': '새 리스트'},
      });
    }
  }

  String toJson() {
    return json.encode({
      'preset': preset,
    });
  }

  Map<String, String> defaultPreset() {
    return {
      'parentNodeId': '',
      'nodeId': '',
      'nodeName': '새 리스트',
      'type': 'pizza',
      'unit': 'min', // 설정 단위 min,sec,time
      'setupTime': '45', // 설정 시간
      'viewRemainTime': '', // 남은 시간 표시 여부
      'viewDescript': 'false', // 설명 표시 여부
      'descriptText': 'test', // 설명 텍스트
      'isAlarmYn': 'N', // 알람 여부
      'alarmType': '', // 알람 타입 무음/진동/소리
      'dismissAlarm': '', // 한 번, 버튼 클릭
      'dismissAlarm': '', // 한 번, 버튼 클릭
      'isInterNotif': '', // 중간 알림
      'notifUnit': '', // 중간 알림
      'notifGap': '', // 알림 간격
      'notifType': '', // 알림 타입 무음 / 진동 / 소리
    };
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PresetModel {
  Map<String, Map<String, dynamic>>? preset = {};

  Map<String, Map<String, dynamic>>? _folderPreset = {}; // 폴더
  Map<String, Map<String, dynamic>>? _timerPreset = {}; // 타이머

  get getPreset => preset;

  get folderPreset => _folderPreset;
  get timerPreset => _timerPreset;

  PresetModel(folderPreset, timerPreset){
    this._folderPreset = folderPreset ?? defaultFolderPreset();
    this._timerPreset = timerPreset ?? defaultTimerPreset();
  }

  factory PresetModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      Map<String, Map<String, dynamic>>? _prefsFolderPreset = {};
      Map<String, Map<String, dynamic>>? _prefsTimerPreset = {};

      json['folderPreset'].forEach ((key, value){
        _prefsFolderPreset[key] = value;
        });
      json['timerPreset'].forEach ((key, value){
        _prefsTimerPreset[key] = value;
      });

      return PresetModel(_prefsFolderPreset,_prefsTimerPreset);
    } else {
      return PresetModel(null, null);
    }
  }

  String toJson() {
    return json.encode({
      'folderPreset': _folderPreset,
      'timerPreset': _timerPreset,
    });
  }


  /** 사용자 폴더 생성 */
  void addFolderPreset(String nodeName) {
    _folderPreset?[UniqueKey().toString()] = {
        'seq' : '0', // 순서
        'nodeId': '[#fabcd]', // 요소 고유 번호
        'nodeName': nodeName, // 요소 이름
    };
  }

  /** 기본 폴더 생성 */
  Map<String,Map<String, dynamic>> defaultFolderPreset() {
    return {
      '[#f1234]' : {
        'seq' : '0', // 순서
        'nodeId': '[#fabcd]', // 요소 고유 번호
        'nodeName': '내 리스트', // 요소 이름
      }
    };
  }

  /** 기본 타이머 생성 생성 */
  Map<String,Map<String, dynamic>> defaultTimerPreset() {
    return {
      '[#t1234]' : {
        'parentNodeId': '[#f1234]',
        'nodeId': '[#t1234]',
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
      }
    };
  }
}

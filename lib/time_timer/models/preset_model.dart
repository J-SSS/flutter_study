class PresetModel {
  late Map<String,Map<String,String>> preset;

  PresetModel(this.preset);
  PresetModel.init(){
    preset = {'key' : defaultPreset()};
  }


  // factory PresetModel.fromJson(Map<String, dynamic> json) {
  //   return PresetModel(
  //     // preset = newPreset(),
  //
  //   );
  // }


  Map<String,String> defaultPreset() {
    return {
      'parentNodeId' : '',
      'nodeId' : '',
      'type' : 'pizza',
      'unit' : 'min', // 설정 단위 min,sec,time
      'setupTime' : '45', // 설정 시간
      'viewRemainTime' : '', // 남은 시간 표시 여부
      'viewDescript' : 'false', // 설명 표시 여부
      'descriptText' : 'test', // 설명 텍스트
      'isAlarmYn' : 'N', // 알람 여부
      'alarmType' : '', // 알람 타입 무음/진동/소리
      'dismissAlarm' : '', // 한 번, 버튼 클릭
      'dismissAlarm' : '', // 한 번, 버튼 클릭
      'isInterNotif' : '', // 중간 알림
      'notifUnit' : '', // 중간 알림
      'notifGap' : '', // 알림 간격
      'notifType' : '', // 알림 타입 무음 / 진동 / 소리
    };
  }
}
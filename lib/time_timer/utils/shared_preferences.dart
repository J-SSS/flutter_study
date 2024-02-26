import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  Map<String, String> keyValuePairs = {};

  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // keyValuePairs = Map.from(prefs.getString('keyValuePairs') ?? {});
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('keyValuePairs', keyValuePairs.toString());
  }

  void _addKeyValuePair() {
    String key = _keyController.text;
    String value = _valueController.text;
    setState(() {
      keyValuePairs[key] = value;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _keyController,
                    decoration: InputDecoration(labelText: 'Key'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _valueController,
                    decoration: InputDecoration(labelText: 'Value'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addKeyValuePair,
              child: Text('Add Key-Value Pair'),
            ),
            SizedBox(height: 20),
            Text('Stored Key-Value Pairs:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: keyValuePairs.entries
                  .map((entry) => Text('${entry.key}: ${entry.value}'))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
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

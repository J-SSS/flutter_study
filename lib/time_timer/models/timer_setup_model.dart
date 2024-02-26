import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TimerSetup {
  String name;
  int age;
  bool isStudent;
  List<int> grades;
  Map<String, String> address;

  TimerSetup({
    required this.name,
    required this.age,
    required this.isStudent,
    required this.grades,
    required this.address,
  });

  factory TimerSetup.fromJson(Map<String, dynamic> json) {
    return TimerSetup(
      name: json['name'],
      age: json['age'],
      isStudent: json['isStudent'],
      grades: List<int>.from(json['grades']),
      address: Map<String, String>.from(json['address']),
    );
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
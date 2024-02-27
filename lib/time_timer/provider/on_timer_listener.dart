import 'package:flutter/material.dart';

class OnTimerListener extends ChangeNotifier {
  bool _isPlyaing = true; // 현재 작동중인지 여부

  bool get isPlaying => _isPlyaing;

  set setIsPlaying (bool value) => _isPlyaing = value;

}
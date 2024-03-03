
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppConfigListener with ChangeNotifier {
  BuildContext? context;

  late MediaQueryData mediaQuery;
  late double painterSize;

  bool isOnTimerBottomViewYn = false;

  set setOnTimerBottomView(bool bool){
    Timer myTimer;
    this.isOnTimerBottomViewYn = true;
    notifyListeners();

    if (bool) {
      myTimer = Timer(Duration(seconds: 3), () {
        this.isOnTimerBottomViewYn = false;
        notifyListeners();
      });

      // myTimer.cancel();
    }

  }

  set setMediaQuery(MediaQueryData mediaQuery){
    this.mediaQuery = mediaQuery;

    if(mediaQuery.orientation.toString() == 'portrait'){
      this.painterSize = mediaQuery.size.width * 0.85;
    } else {
      this.painterSize = mediaQuery.size.height * 0.85;
    }
  }

  set setMediaQueryT(BuildContext context){
    this.mediaQuery = MediaQuery.of(context);
  }

}
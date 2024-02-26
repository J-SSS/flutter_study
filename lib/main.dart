import 'package:flutter/material.dart';

// import 'package:flutter_study/screen/home_screen.dart';
// import 'package:flutter_study/screen/home_screen2.dart';
// import 'package:flutter_study/study/provider.dart'; // 코딩셰프 Provider 입문 1&2


import 'package:flutter_study/time_timer/base_timer.dart';
// import 'package:flutter_study/time_timer/utils/shared_preferences.dart';

/**
  플러터 프로젝트를 실행하면 main() 함수와 그 안의 runApp() 함수가 실행된다.

  1. MaterialApp : Material Design 기반의 위젯들을 사용할 수 있게 해준다
  2. Scaffold : 화면 전체의 레이아웃 및 UI관련 기능(알림, 탭 추가 등)

  3. MaterialApp + scaffold가 가장 기본적인 설정
  4. 앱바 : 상단바 위젯, 스낵바 : 알림창 위젯
 */
void main() {
  runApp(MyApp());

  // runApp(SplashScreen());

  // runApp(MaterialApp(
  //   home: HomeScreen(),
  // ));
}

/*
StatelessWidget 클래스를 상속 받으면
build() 함수를 필수적으로 오버라이드 하게된다.
 */
class SplashScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home :  Scaffold(
        body : Container(
          decoration: BoxDecoration(
            color: Colors.orange
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Splash Screen'),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  )
                ],
              )

            ],
          ),
        ),


      )
    );
  }

}
//
// class MyApp extends StatelessWidget{
//   @override
//   Widget build(BuildContext context){
//     return  MaterialApp(
//         home : Scaffold(
//             // Material Design에서 추구하는 버튼 형태, Scaffold에 바로 사용할 수 있다
//             floatingActionButton: FloatingActionButton(
//                onPressed: (){},
//                child: Text('클릭'),
//             ),
//             body : SizedBox(
//                 width: double.infinity,
//                 child: Column( // 다수의 자식 요소를 가질 수 있는 위젯
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton( // 텍스트 버튼
//                       onPressed: (){},
//                       style : TextButton.styleFrom(
//                         foregroundColor: Colors.red
//                       ),
//                       child: Text('텍스트 버튼')
//                   ),
//                   OutlinedButton( // 아웃라인드 버튼
//                       onPressed: (){},
//                       style : OutlinedButton.styleFrom(
//                           foregroundColor: Colors.red
//                       ),
//                       child: Text('아웃라인드 버튼')
//                   ),
//                   OutlinedButton( // 엘레베이티드 버튼
//                       onPressed: (){},
//                       style : ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red
//                       ),
//                       child: Text('엘레베이티드 버튼')
//                   ),
//                   IconButton( // 아이콘을 버튼으로 만들어주는 위젯
//                       onPressed: (){},
//                       icon: Icon(
//                         Icons.home
//                       )
//                   ),
//                   GestureDetector( // 입력 감지 위젯
//                     onTap: (){
//                       print('on Tab');
//                     },
//                     onDoubleTap: (){
//                       print('on double Tab');
//                     },
//                     onLongPress: (){
//                       print('on long press');
//                     },
//                     child: Container( // 입력 감지 대상
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                       ),
//                       width: 100.0,
//                       height: 100.0,
//                     ),
//                   )
//                 ],
//             ),
//             )
//         )
//     );
//   }
// }



// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

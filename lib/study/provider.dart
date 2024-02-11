import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * MultiProvider
     */
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                FishModel(name: 'Salmon', number: 0, size: 'big')),
        ChangeNotifierProvider(
            create: (context) =>
                SeaFishModel(name: 'Tuna', tunaNumber: 0, size: 'Middle'))
      ],
      child: MaterialApp(
        home: FishOrder(),
      ),
    );

    /**
     * Provider 위젯의 create 메서드를 통해 생성한 인스턴스는,
     * MaterialApp에서 사용할 수 있다
     * => data에 대한 정의를 담은 class를 사용해서 Provicer를 생성한다!
     *
     * Provider.of 메서드는 해당하는 인스턴스를 찾아 반환한다.
     * ex) Provider.of<FishModel>(context).name
     */
    // return Provider(
    //   create: (context) => FishModel(name: 'Salmon', number: 10, size: 'big'),
    //   child: MaterialApp(
    //   home: FishOrder(),
    //   ),
    // )
  }
}

class FishOrder extends StatelessWidget {
  const FishOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fish Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fish name: ${Provider.of<FishModel>(context).name}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            High()
          ],
        ),
      ),
    );
  }
}

class High extends StatelessWidget {
  const High({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SpicyA is located at high place',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        SpicyA()
      ],
    );
  }
}

class SpicyA extends StatelessWidget {
  const SpicyA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Fish number: ${Provider.of<FishModel>(context).number}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        Text(
          'Fish size: ${Provider.of<FishModel>(context).size}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Middle()
      ],
    );
  }
}

class Middle extends StatelessWidget {
  const Middle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SpicyB is located at middle place',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        SpicyB()
      ],
    );
  }
}

class SpicyB extends StatelessWidget {
  const SpicyB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tuna number: ${Provider.of<SeaFishModel>(context).tunaNumber}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        Text(
          'Fish size: ${Provider.of<FishModel>(context).size}',
          style: TextStyle(
              fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: (){
            Provider.of<SeaFishModel>(context, listen: false).changeSeaFishNumber(); // eventListener와 관련된 요소는 rebuild가 필요 없다!
          },
          child: Text('Tuna Number'),
        ),
        Low()
      ],
    );
  }
}

class Low extends StatelessWidget {
  const Low({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SpicyC is located at low place',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SpicyC()
      ],
    );
  }
}

class SpicyC extends StatelessWidget {
  const SpicyC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        'Fish number: ${Provider.of<FishModel>(context).number}',
        style: TextStyle(
            fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
      ),
      Text(
        'Fish size: ${Provider.of<FishModel>(context, listen: false).size}',
        style: TextStyle(
            fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20,
      ),
      ElevatedButton(
        onPressed: () {
          Provider.of<FishModel>(context, listen: false).changeFishNumber();
        },
        child: Text('Change fish number'),
      ),
    ]);
  }
}

/**
 * with는 mixin 문법!
 * extend(상속)는 부모 클래스의 모든 것을 가져옴, 다중 상속 불가
 * with는 단순히 특정 기능을 추가하고 싶을 때 사용, 다중 연결 가능
 *
 * ChangeNotifier 클래스는 변화를 감지하고 관련된 위젯에 rebuild 명령을 내리는 기능을 한다.
 *
 * ChangeNotifier 자체는 addListener 및 removeListener 등을 매번 선언해야하고, UI 리빌드도 수동이다.
 * => ChangeNotifierProvider클래스가 이를 자동화 해준다.
 *
 *
 * ChangeNotifierProvider클래스는?
 * 1. 모든 위젯들이 listen 할 수 있는 changeNotifier 인스턴스 생성
 * 2. 필요없는 changeNotifier는 자동으로 제거
 * 3. Provider.of를 통해서 위젯들이 쉽게 chageNotifier에 접근할 수 있게 해줌
 * 4. 필요시 UI를 리빌드 시켜줄 수 있음
 * 5. 리빌드가 필요 없는 경우를 위해 listen:false 옵션 제공
 */

class FishModel with ChangeNotifier{
  final String name;
  int number;
  final String size;

  FishModel({required this.name, required this.number, required this.size});

  void changeFishNumber(){
    number++;
    notifyListeners();
  }

}

class SeaFishModel with ChangeNotifier{
  final String name;
  int tunaNumber;
  final String size;

  SeaFishModel({required this.name, required this.tunaNumber, required this.size});

  void changeSeaFishNumber(){
    tunaNumber++;
    notifyListeners();
  }

}
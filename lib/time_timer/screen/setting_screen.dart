import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<bool> switchValues = List.generate(10, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Setting 1',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      // switchValues[index] = value;
                    });
                  },
                ),
              ],
            ),
            Divider(),
            TextButton(onPressed: (){
              context.read<TimerViewModel>().clearPreset();
            }, child: Text('설정 초기화'))
          ]
        ),
      ),
    );
  }
}
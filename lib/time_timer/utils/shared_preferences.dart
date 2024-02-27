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
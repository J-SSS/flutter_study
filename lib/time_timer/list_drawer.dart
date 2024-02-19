import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class ListDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // 리스트 항목을 눌렀을 때 수행할 동작
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Item 2'),
            onTap: () {
              // 리스트 항목을 눌렀을 때 수행할 동작
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
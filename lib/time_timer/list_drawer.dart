import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class ListDrawer extends StatelessWidget {
  ListDrawer({super.key});

  // Sample data
  final List<int> _items = List<int>.generate(10, (int index) => index);

  late MediaQueryData mediaSize;

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context);
    return SafeArea(
        child: Drawer(
            backgroundColor: Colors.white,
            width: mediaSize.size.width * 0.8,
            child: Column(
              children: [
                SizedBox(
                  width: mediaSize.size.width * 0.8,
                  height: mediaSize.size.height * 0.2,
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        color: Colors.white,
                      ),
                      Container(
                        width: mediaSize.size.width * 0.75, // 가로 길이
                        height: 70.0, // 세로 길이
                        decoration: BoxDecoration(
                          color: Colors.white, // 배경색
                          borderRadius:
                              BorderRadius.circular(35.0), // 모서리 둥글기 설정
                          border: Border.all(
                            color: Colors.grey, // 테두리 색상
                            width: 2.0, // 테두리 두께
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // 그림자 색상
                              spreadRadius: 5, // 그림자 확산 정도
                              blurRadius: 7, // 그림자 흐림 정도
                              offset: Offset(0, 3), // 그림자 위치 (수평, 수직)
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon:
                                      Icon(Icons.remove_circle_outline_sharp)),
                              // IconButton(onPressed: (){}, icon: Icon(Icons.add)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: MyStatefulWidget()),
                SizedBox(
                  height: 50,
                  // child: Text('[2024] Team Bulgwang. All rights reserved.'),
                )
              ],
            )));
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<int> _items = List<int>.generate(10, (int index) => index);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        for (int index = 0; index < _items.length; index++)
          ListTile(
            key: Key('$index'),
            tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
            title: Text('Item ${_items[index]}'),
            trailing: Icon(Icons.drag_handle),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    );
  }
}

// ListView.separated(
// itemCount: itemList.length,
// itemBuilder: (BuildContext context, int index) {
// return ExpansionTile(
// title: Text(itemList[index]),
// children: <Widget>[
// // 아이템이 펼쳐졌을 때 나타나는 내용
// ListTile(
// title: Text('Subitem 1'),
// onTap: () {
// // Handle subitem tap
// },
// ),
// ListTile(
// title: Text('Subitem 2'),
// onTap: () {
// // Handle subitem tap
// },
// ),
// ],
// );
// },
// separatorBuilder: (BuildContext context, int index) {
// return Divider();
// },
// ),

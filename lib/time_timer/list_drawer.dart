import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

import 'models/preset_model.dart';

class ListDrawer extends StatelessWidget {
  ListDrawer({super.key});

  TextEditingController _textController = TextEditingController();

  late Size mediaSize;

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.sizeOf(context);
    return SafeArea(
        child: Drawer(
            backgroundColor: Colors.white,
            width: mediaSize.width * 0.8,
            child: Column(
              children: [
                SizedBox(
                  height: mediaSize.height * 0.04,
                ),
                SizedBox(
                  height: mediaSize.height * 0.04,
                  child: Row(
                    children: [
                      SizedBox(
                        width: mediaSize.width * 0.05,
                      ),
                      Text('내 타이머', style: TextStyle(fontSize: 20)),
                      SizedBox(
                        width: mediaSize.width * 0.40,
                      ),
                      IconButton(
                          onPressed: () {
                            _showCreateFolderPopup(context);
                          },
                          icon: Icon(
                            MaterialCommunityIcons.folder_plus_outline,
                            size: 25,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                ),
                Divider(
                  indent: mediaSize.width * 0.05,
                  endIndent: mediaSize.width * 0.05,
                ),
                Expanded(child: PresetWidget()),
                Divider(
                  indent: mediaSize.width * 0.05,
                  endIndent: mediaSize.width * 0.05,
                ),
                SizedBox(
                  height: mediaSize.height * 0.05,
                  child: Text(
                    '[2024] Team Bulgwang. All rights reserved.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                )
              ],
            )));
  }

  void _showCreateFolderPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('새 폴더'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '폴더 이름을 입력하세요.',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<TimerViewModel>().addPreset(_textController.text);
              },
              child: Text('생성'),
            ),
          ],
        );
      },
    );
  }
}

class PresetWidget extends StatefulWidget {
  const PresetWidget({Key? key}) : super(key: key);

  @override
  State<PresetWidget> createState() => _PresetWidgetState();
}

class _PresetWidgetState extends State<PresetWidget> {
  final List<int> _items = List<int>.generate(2, (int index) => index);
  List<String> items = ['- 피자타입', '- 배터리타입'];
  bool isExpanded = false; // ExpansionTile의 초기 상태
  List<String> expandedKey = [];

  // int _expandedTileIndex = -1; // 현재 열려 있는 타일의 인덱스를 저장

  late Map<String, Map<String, dynamic>> _preset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _preset = context.watch<TimerViewModel>().preset!.getPreset;
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        // contentPadding :  EdgeInsets.all(0),
        children: _preset
            .map((index, item) {
              print('타일 : ${index}, ${item}');
              return MapEntry(
                  index,
                  ExpansionTile(
                      initiallyExpanded: false,
                      key: Key('$index'),
                      tilePadding : EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                      textColor: Colors.blue,
                      title: expandedKey.contains(index)
                          ? SizedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    MaterialCommunityIcons.folder_open_outline,
                                    color: Colors.grey,
                                  ),
                                  Text('  ${item['nodeName']}'),
                                  SizedBox(
                                    width: 80,
                                  ),
                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: IconButton(
                                        padding: EdgeInsets.all(10.0),
                                        onPressed: () {},
                                        icon: Icon(
                                          FontAwesome.pencil_square_o,
                                          color: Colors.grey,
                                        ),
                                        iconSize: 20),
                                  ),
                                  SizedBox(
                                    // 추가 버튼
                                    width: 35,
                                    height: 35,
                                    child: IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: () {
                                          print(index);
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                        ),
                                        iconSize: 25),
                                  ),
                                ],
                              ),
                            )
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(
                                MaterialCommunityIcons.folder_outline,
                                color: Colors.grey,
                              ),
                              Text('  ${item['nodeName']}'),
                            ]),
                      // trailing: SizedBox(width: 50,child: Icon(Icons.add),),
                      trailing: SizedBox(),
                      onExpansionChanged: (bool expanding) {
                        setState(() {
                          if (expanding) {
                            expandedKey.add(index);
                          } else {
                            expandedKey.remove(index);
                          }
                        });
                      },
                      // children: <Widget>[
                      //   SizedBox(
                      //     height: items.length * 70,
                      //     child: ReorderableListView(
                      //       padding: EdgeInsets.only(left: 16.0),
                      //       onReorder: (oldIndex, newIndex) {
                      //         setState(() {
                      //           if (newIndex > oldIndex) {
                      //             newIndex -= 1;
                      //           }
                      //           final item = items.removeAt(oldIndex);
                      //           items.insert(newIndex, item);
                      //         });
                      //       },
                      //       children: items
                      //           .asMap()
                      //           .map((index, item) => MapEntry(
                      //               index,
                      //               SizedBox(
                      //                 key: Key('$item'),
                      //                 height: 60,
                      //                 child: ListTile(
                      //                   // contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                      //                   title: Text(item,
                      //                       style: TextStyle(fontSize: 15),
                      //                       textAlign: TextAlign.start),
                      //                   subtitle: Text('123',
                      //                       style: TextStyle(fontSize: 13)),
                      //                   onTap: () {},
                      //                 ),
                      //               )))
                      //           .values
                      //           .toList(),
                      //     ),
                      //   )
                      // ],
                    ),
                  );
            })
            .values
            .toList());
  }
}

//     // initiallyExpanded: _expandedTileIndex == index,

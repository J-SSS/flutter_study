import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_study/time_timer/viewModels/timer_view_model.dart';
import 'package:flutter_study/time_timer/screen/theme_screen.dart' as theme_screen;
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                Expanded(child: PresetWidget(mediaSize: mediaSize)),
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
          title: Text('폴더 생성'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '폴더 이름을 입력하세요.',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                if (!(_textController.text ?? '').isNotEmpty) {
                  Fluttertoast.showToast(
                    msg: "폴더 이름을 입력하세요",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  // context.read<TimerViewModel>().addPreset(_textController.text, 'F');
                }
              },
              child: Text('생성'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}

class PresetWidget extends StatefulWidget {
  const PresetWidget({Key? key, this.mediaSize}) : super(key: key);

  final Size? mediaSize;

  @override
  State<PresetWidget> createState() => _PresetWidgetState();
}

class _PresetWidgetState extends State<PresetWidget> {
  List<String> items = ['- 피자타입', '- 배터리타입'];
  bool isExpanded = false; // ExpansionTile의 초기 상태
  List<String> expandedKey = [];

  // int _expandedTileIndex = -1; // 현재 열려 있는 타일의 인덱스를 저장

  late Map<String, Map<String, dynamic>> _folderPreset;
  late Map<String, Map<String, dynamic>> _timerPreset;

  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('타일사이즈 : ${widget.mediaSize}');
    _folderPreset = context.watch<TimerViewModel>().preset!.folderPreset;
    _timerPreset = context.watch<TimerViewModel>().preset!.timerPreset;
    print('폴더 : ${_folderPreset}');
    print('타이머 : ${_timerPreset}');

    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        // contentPadding :  EdgeInsets.all(0),
        children: _folderPreset
            .map((folderId, item) {
              return MapEntry(
                folderId,
                ExpansionTile(
                  initiallyExpanded: false,
                  key: Key('$folderId'),
                  tilePadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                  controlAffinity: ListTileControlAffinity.leading,
                  textColor: Colors.blue,
                  title: expandedKey.contains(folderId)
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item['nodeName']}'),
                            Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: IconButton(
                                      padding: EdgeInsets.all(10.0),
                                      onPressed: () {
                                        _showModifyFolderPopup(
                                            context, "F", folderId);
                                      },
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
                                        _showDeleteFolderPopup(
                                            context, "F", folderId);
                                      },
                                      icon: Icon(
                                        FontAwesome.trash,
                                        color: Colors.grey,
                                      ),
                                      iconSize: 20),
                                ),
                              ],
                            )
                          ],
                        )
                      : Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('${item['nodeName']}'),
                        ]),
                  leading: expandedKey.contains(folderId)
                      ? Icon(
                          MaterialCommunityIcons.folder_open_outline,
                          color: Colors.grey,
                        )
                      : Icon(
                          MaterialCommunityIcons.folder_outline,
                          color: Colors.grey,
                        ),
                  onExpansionChanged: (bool expanding) {
                    setState(() {
                      if (expanding) {
                        expandedKey.add(folderId);
                      } else {
                        expandedKey.remove(folderId);
                      }
                    });
                  },
                  children: <Widget>[
                    SizedBox(
                      height: _timerPreset.values.where((allEle) {
                        return allEle['parentNodeId'] == folderId;
                      }).length * 1.00 * 70,
                      child: ReorderableListView(
                          padding: EdgeInsets.only(left: 16.0),
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              final item = items.removeAt(oldIndex);
                              items.insert(newIndex, item);
                            });
                          },
                          children: _timerPreset.values.where((allEle) {
                            return allEle['parentNodeId'] == folderId;
                          }).map((ele) {
                            return SizedBox(
                              key: Key(ele['nodeId']),
                              height: 60,
                              child: ListTile(
                                // contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                                title: Text(item['nodeName'],
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.start),
                                subtitle:
                                    Text('123', style: TextStyle(fontSize: 13)),
                                onTap: () {},
                              ),
                            );
                          }).toList()),
                    ),
                    Container(
                        height: 35,
                        width: widget.mediaSize!.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(15), // 원하는 곡선의 반지름 값 설정
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => theme_screen.SelectThemeScreen()));
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 20,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            })
            .values
            .toList());
  }

  void _showDeleteFolderPopup(BuildContext context, String type, String key) {
    bool isFolder = type == "F" ? true : false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isFolder ? '폴더 삭제' : '타이머 삭제'),
            content: Text(
                isFolder ? '폴더에 포함된 타이머 목록이 함께 삭제됩니다.' : '선택한 타이머를 삭제합니다.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  context.read<TimerViewModel>().deletePreset(key, 'F');
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('삭제'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
                child: Text('취소'),
              ),
            ],
          );
        });
  }

  void _showModifyFolderPopup(BuildContext context, String type, String key) {
    bool isFolder = type == "F" ? true : false;
    _textController.text = _folderPreset[key]?['nodeName'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('폴더 수정'),
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
                // context.read<TimerViewModel>().addPreset(_textController.text, 'F');
              },
              child: Text('생성'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }
}

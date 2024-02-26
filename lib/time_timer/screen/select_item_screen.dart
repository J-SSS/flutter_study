import 'package:flutter/material.dart';

class CustomDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog Title'),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 9,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  onPressed: () {
                    // 버튼 클릭 시 수행할 동작
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    print('Button $index clicked');
                  },
                  child: Text('Button $index'),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
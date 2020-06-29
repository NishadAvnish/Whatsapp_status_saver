import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImageVideoProvider with ChangeNotifier {
  List<String> _list = new List<String>();

  List<String> get getList {
    return [..._list];
  }

  loadData(String flag, Directory dir) async {
    if (flag == "image") {
      _list = [];
      _list = await dir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);
    } else {
      _list = await dir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList();
    }
    notifyListeners();
  }

  Future<void> delete(String filePath) async {
    try {
      await File(filePath).delete();
    } catch (e) {
      print(e);
    }
    final temp = _list.toList();

    final _index = _list.indexOf(filePath);
    temp.removeAt(_index);
    _list = temp.toList();
    notifyListeners();
  }
}

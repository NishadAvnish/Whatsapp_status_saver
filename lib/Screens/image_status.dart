import 'dart:io';

import 'package:flutter/material.dart';
import 'package:status_downloader/Widgets/grid.dart';

class StatusImage extends StatefulWidget {
  final Directory dir;
  StatusImage({this.dir});

  @override
  _StatusImageState createState() => _StatusImageState();
}

class _StatusImageState extends State<StatusImage>  {
  List<String> _imageList = [];

  @override
  void initState() {
    super.initState();
    _imageList = [];
    _imageList = widget.dir
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".jpg"))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Grid(
        list: _imageList,
        flag: "image",
      ),
    );
  }

  
}

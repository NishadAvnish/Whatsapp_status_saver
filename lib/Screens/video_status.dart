import 'dart:io';

import 'package:flutter/material.dart';
import 'package:status_downloader/Widgets/grid.dart';

class StatusVideo extends StatefulWidget {
  final Directory dir;
  StatusVideo({ this.dir});

  @override
  _StatusVideoState createState() => _StatusVideoState();
}

class _StatusVideoState extends State<StatusVideo> {
  List<String> _videoList=[];
  @override
  void initState() {
    super.initState();
    _videoList=[];
    _videoList=widget.dir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Grid(
              list: _videoList,
              flag: "video",
            ),
    );
  }
}
import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:status_downloader/Widgets/grid.dart';

class StatusVideo extends StatefulWidget {
  final Directory dir;
  StatusVideo({this.dir});

  @override
  _StatusVideoState createState() => _StatusVideoState();
}

class _StatusVideoState extends State<StatusVideo> {
  List<String> _videoList = [];
  @override
  void initState() {
    // syncVideos();

    loadIsolate();
    super.initState();
  }

//creating isolate

  static _isolateEntry(SendPort sendPort) async {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    //receiveing data from LoadIsolate that is main Isolate
    await for (var msg in receivePort) {
      Directory dir = msg[1];
      SendPort replyPort = msg[0];
      //working to fetch list of whatsapp videos
      List<String> response = await dir
          .list()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList();
      replyPort.send(response);
    }
  }

 

  Future loadIsolate() async {
    final receivePort = ReceivePort();
    final _isolate = await Isolate.spawn(_isolateEntry, receivePort.sendPort);
    SendPort sendPort = await receivePort.first;

    //send data to Isolate
    final responsePort=ReceivePort();
     sendPort.send([responsePort.sendPort, widget.dir]);
    _videoList = await responsePort.first;
    if (_videoList != null) {
      setState(() {});
    }
    _isolate.kill();
  }

  // void syncVideos() async {
  //   _videoList = await widget.dir
  //       .list()
  //       .map((item) => item.path)
  //       .where((item) => item.endsWith(".mp4"))
  //       .toList();
  //   setState(() {});
  // }

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

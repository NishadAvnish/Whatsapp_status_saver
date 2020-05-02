import 'dart:io';

import 'package:flutter/material.dart';
import 'package:status_downloader/Utils/config.dart';
import 'package:status_downloader/Widgets/modified_video_player.dart';

class Display extends StatefulWidget {
  final List<String> list;
  final int index;
  final String flag;
  Display({this.list, this.index, this.flag});

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: widget.flag == "image" ? Text("Image") : Text("Video")),
        backgroundColor: darkBackground,
        body: Container(
          width: double.infinity,
          child: Center(
            child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return widget.flag == "image"
                      ? Image.file(
                          File(widget.list[index]),
                          fit: BoxFit.contain,
                        )
                      : VideoPlayerScreen(videoList:widget.list,index:index);
                }),
          ),
        ));
  }
}

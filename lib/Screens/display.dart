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
    final _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: widget.flag == "image" ? Text("Image") : Text("Video"),
      ),
      backgroundColor: darkBackground,
      body: Container(
        width: _mediaQuery.size.width,
        height: _mediaQuery.size.height -
            _mediaQuery.padding.top -
            _mediaQuery.padding.bottom -
            kToolbarHeight,
        child: Center(
            child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return Stack(alignment: Alignment.center, children: [
              widget.flag == "image"
                  ? Image.file(
                      File(widget.list[index]),
                      fit: BoxFit.contain,
                    )
                  : VideoPlayerScreen(videoList: widget.list, index: index),
              Positioned(
                bottom: 5,
                right: 20,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: Text(
                      "Share",
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  onPressed: () {},
                ),
              )
            ]);
          },
        )),
      ),
    );
  }
}

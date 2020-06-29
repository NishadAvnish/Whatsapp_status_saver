import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Grid extends StatelessWidget {
  final String flag;
  final List<String> list;
  const Grid({this.list, this.flag});

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      width: _size.width,
      margin: EdgeInsets.all(2),
      child: GridView.builder(
          cacheExtent: 1.0,
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 2 / 2.4,
            maxCrossAxisExtent: 196,
          ),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                return Navigator.of(context).pushNamed("/display", arguments: {
                  "list": list,
                  "index": index,
                  "flag": flag
                });
              },
              child: Card(
                  child: flag == "image"
                      ? Hero(
                          tag: "image+${index.toString()}",
                          child: Image.file(
                            File(list[index]),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          ),
                        )
                      : ThumbNail(
                          videoPath: list[index],
                        )),
            );
          }),
    );
  }
}

class ThumbNail extends StatefulWidget {
  final String videoPath;
  ThumbNail({this.videoPath});

  @override
  _ThumbNailState createState() => _ThumbNailState();
}

class _ThumbNailState extends State<ThumbNail> {
  VideoPlayerController _playerController;
  @override
  void initState() {
    super.initState();
    getThumbNail();
  }

  getThumbNail() async {
    _playerController = VideoPlayerController.file(File(widget.videoPath));

    await _playerController.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _playerController.value.initialized
        ? VideoPlayer(_playerController)
        : Center(child: CircularProgressIndicator());
  }
}

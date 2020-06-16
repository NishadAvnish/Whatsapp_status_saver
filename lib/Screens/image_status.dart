import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_downloader/Provider/image_video_provider.dart';
import 'package:status_downloader/Widgets/grid.dart';

class StatusImage extends StatefulWidget {
  final Directory dir;
  StatusImage({this.dir});

  @override
  _StatusImageState createState() => _StatusImageState();
}

class _StatusImageState extends State<StatusImage> {
  
  bool _isLoading;
  @override
  void initState() {
    _isLoading = true;

    _loadImage();
    super.initState();
  }

  @override
  void didUpdateWidget(StatusImage oldStatusScreen) {
    super.didUpdateWidget(oldStatusScreen);
    if (oldStatusScreen.dir != widget.dir) {
      _loadImage();
    }
  }

  _loadImage() async{
   await  Provider.of<ImageVideoProvider>(context,listen:false).loadData("image", widget.dir);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _imageList=Provider.of<ImageVideoProvider>(context).getList;
    return Container(
      child: !_isLoading
          ? _imageList.length == 0
              ? Center(
                  child: Image.asset("Assets/image/nodata.png"),
                )
              : Grid(
                  list: _imageList,
                  flag: "image",
                )
          : CircularProgressIndicator(),
    );
  }
}

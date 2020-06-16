import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thumbnails/thumbnails.dart';

class Grid extends StatefulWidget {
  final String flag;
  final List<String> list;
  const Grid({this.list, this.flag});

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> with AutomaticKeepAliveClientMixin {
  var _thumbPath;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  _getImage(videoPathUrl) async {
    String thumb = await Thumbnails.getThumbnail(
        thumbnailFolder: _thumbPath,
        videoFile: videoPathUrl,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 10);
    return thumb;
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      height: _size.height,
      width: _size.width,
      margin: EdgeInsets.all(2),
      child: GridView.builder(
        cacheExtent :1.0,
          itemCount: widget.list.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 2 / 2.4,
            maxCrossAxisExtent: 196,
          ),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () {
                return Navigator.of(context).pushNamed("/display", arguments: {
                  "list": widget.list,
                  "index": index,
                  "flag": widget.flag
                });
              },
              child: Card(
                child: widget.flag == "image"
                    ?  Image.file(
                          File(widget.list[index]),
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.low,
                        )
                      
                    : FutureBuilder(
                        future: _getImage(widget.list[index]),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              break;
                            case ConnectionState.waiting:
                              return Image.asset("Assets/image/loading.gif");
                              break;
                            case ConnectionState.active:
                              break;
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text(snapshot.error.toString()));
                              } else {
                                return  Image.file(
                                    File(snapshot.data),
                                    fit: BoxFit.cover,
                                
                                );
                              }

                              break;
                          }
                        }),
              ),
            );
          }),
    );
  }
}

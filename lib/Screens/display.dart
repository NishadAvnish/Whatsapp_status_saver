import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:status_downloader/Listenable/notifier_value.dart';
import 'package:status_downloader/Provider/image_video_provider.dart';
import 'package:status_downloader/Utils/config.dart';
import 'package:status_downloader/Widgets/modified_video_player.dart';
import 'package:path/path.dart' as path;

class Display extends StatefulWidget {
  final int index;
  final String flag;
  final bool isDownloadedClicked;
  Display({this.index, this.flag, this.isDownloadedClicked});

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  PageController _pageController;
  bool _isStackOpen = false;
  int _modifiedIndex;
  List<String> _list = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _modifiedIndex = widget.index;
  }

  Future<void> _shareContent(index) async {
    try {
      final ByteData bytes = await rootBundle.load(_list[index]);
      // this will return the file name
      final _tempList = _list[_modifiedIndex].split("/");
      final _fileName = _list[_tempList.length - 1];
      await Share.file(
          "Sending a file  using Flutter application",
          _fileName,
          bytes.buffer.asUint8List(),
          "${widget.flag == "image" ? "image/*" : "video/*"}",
          text:
              "Sending using my whatsapp status downloader.Go download it....");
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveFile(BuildContext context) async {
    /*'/storage/emulated/0/WhatsApp/Media/.Statuses/74fd861ea3354097987b53ebcfa63905.jpg' 
    spliting and getting last element result this "74fd861ea3354097987b53ebcfa63905.jpg"*/

    final _nameList = _list[_modifiedIndex].split("/");
    final _fileName = _nameList[_nameList.length - 1];
    Directory _dir = Directory('/storage/emulated/0/statusdownloader');
    if (!_dir.existsSync()) {
      _dir = await _dir.create(recursive: true);
    }

    Uint8List _byteList = await File(_list[_modifiedIndex]).readAsBytes();

    await File(Directory(path.join(_dir.path, _fileName)).path)
        .writeAsBytes(_byteList);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).accentColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        duration: Duration(milliseconds: 400),
        content: Text(
          "File saved to InternalStorage/statusdownloader}",
          textAlign: TextAlign.center,
        )));
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    _list = Provider.of<ImageVideoProvider>(context).getList;
    return Scaffold(
      appBar: AppBar(
        title: widget.flag == "image" ? Text("Image") : Text("Video"),
      ),
      backgroundColor: darkBackground,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isStackOpen = !_isStackOpen;
          });
        },
        child: Container(
          width: _mediaQuery.size.width,
          height: _mediaQuery.size.height -
              _mediaQuery.padding.top -
              _mediaQuery.padding.bottom -
              kToolbarHeight,
          child: Center(
              child: Hero(
            tag: "image+${_modifiedIndex.toString()}",
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return Stack(alignment: Alignment.center, children: [
                  widget.flag == "image"
                      ? Image.file(
                          File(_list[_modifiedIndex]),
                          fit: BoxFit.contain,
                        )
                      : VideoPlayerScreen(
                          videoList: _list, index: _modifiedIndex),
                  _isStackOpen
                      ? Positioned(
                          bottom: 10,
                          left: 20,
                          right: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).accentColor),
                                child: ValueListenableBuilder(
                                    valueListenable: isDownlaoded,
                                    builder: (context, isDownloadedValue, _) {
                                      return isDownloadedValue
                                          ? IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                Provider.of<ImageVideoProvider>(
                                                        context,
                                                        listen: false)
                                                    .delete(
                                                        _list[_modifiedIndex]);
                                                setState(() {
                                                  if (_modifiedIndex ==
                                                              _list.length -
                                                                  1 &&
                                                          _list.length == 1 ||
                                                      _modifiedIndex == 0 &&
                                                          _list.length == 1)
                                                    Navigator.of(context).pop();
                                                  else if (_modifiedIndex ==
                                                      _list.length - 1) {
                                                    _modifiedIndex -= 1;
                                                  }
                                                });
                                              })
                                          : IconButton(
                                              icon: Icon(Icons.arrow_downward),
                                              onPressed: () async {
                                                await _saveFile(context);
                                              },
                                            );
                                    }),
                              ),
                              MaterialButton(
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
                                onPressed: () async {
                                  _shareContent(index);
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ]);
              },
              onPageChanged: (int newIndex) {
                setState(() {
                  _modifiedIndex = newIndex;
                });
              },
            ),
          )),
        ),
      ),
    );
  }
}

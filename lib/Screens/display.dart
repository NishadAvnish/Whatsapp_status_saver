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
  int _modifiedIndex;
  List<String> _list = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _modifiedIndex = widget.index;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _shareContent(index) async {
    try {
      final ByteData bytes = await rootBundle.load(_list[index]);
      // this will return the file name
      final _tempList = _list[index].split("/");
      _tempList.forEach((element) {
        print(element);
      });
      final _fileName = _tempList[_tempList.length - 1];
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
    _list = Provider.of<ImageVideoProvider>(context, listen: true).getList;

    return Scaffold(
        appBar: AppBar(
          title: widget.flag == "image" ? Text("Image") : Text("Video"),
          actions: <Widget>[
            _deleteOrSave(),
            IconButton(
              onPressed: () => _shareContent(_modifiedIndex),
              icon: Icon(Icons.share),
            ),
          ],
        ),
        backgroundColor: darkBackground,
        body: Stack(
          children: <Widget>[
            Container(
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
                    onPageChanged: (int page) {
                      setState(() {
                        _modifiedIndex = page;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _list.length,
                    itemBuilder: (context, index) {
                      return widget.flag == "image"
                          ? Image.file(
                              File(_list[index]),
                              fit: BoxFit.contain,
                            )
                          : VideoPlayerScreen(
                              videoFile: _list[index],
                            );
                    },
                  ),
                ))),
            Align(
                alignment: Alignment.centerRight,
                child: Text(_modifiedIndex.toString()))
          ],
        ));
  }

  Widget _deleteOrSave() {
    return ValueListenableBuilder(
        valueListenable: isDownlaoded,
        builder: (context, isDownloadedValue, _) {
          return isDownloadedValue
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<ImageVideoProvider>(context, listen: false)
                        .delete(_list[_modifiedIndex]);

                    if (_list.length == 1) {
                      Navigator.of(context).pop();
                    } else if (_modifiedIndex == _list.length - 1) {
                      _modifiedIndex -= 1;
                    }
                  })
              : IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () async {
                    await _saveFile(context);
                  },
                );
        });
  }
}

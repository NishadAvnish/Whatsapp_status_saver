import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:status_downloader/Listenable/notifier_value.dart';
import 'package:status_downloader/Screens/image_status.dart';
import 'package:status_downloader/Widgets/bottomButton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'video_status.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Directory _dir;
  bool _isGranted = false;
  bool _isPathValid = true;
  bool _isdownloadedClicked = false;
  @override
  void initState() {
    super.initState();
    _dir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
    _checkPermissionStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _showDialog(title, content, actionButton, [launch]) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title, style: Theme.of(context).textTheme.headline6),
            content:
                Text(content, style: Theme.of(context).textTheme.bodyText1),
            actions: <Widget>[
              FlatButton(
                child: Text(actionButton[0],
                    style: Theme.of(context).textTheme.bodyText1),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              launch != null
                  ? FlatButton(
                      onPressed: () => OpenAppstore.launch(
                          androidAppId: "com.whatsapp&hl=en",
                          iOSAppId: "310633997"),
                      child: Text(actionButton[1],
                          style: Theme.of(context).textTheme.bodyText1))
                  : Container(),
            ],
          );
        });
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      //do nothing in this case
      setState(() {
        _isGranted = true;
      });
      _checkDir();
    } else if (status.isPermanentlyDenied) {
      _showDialog(
          "Open Phone Setting",
          "open phone setting to use the app by granting the required permission",
          ["Ok"]);
    } else {
      _askForPermission();
    }
  }

  Future<void> _askForPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      setState(() {
        _isGranted = true;
      });
      _checkDir(
          title: "Install Whatsapp",
          content:
              "You need to install Whatsapp to get access to your friend's status",
          actionButtons: ["Ok", "Download"],
          launch: "having4thpar");
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  void _checkDir(
      {String title,
      String content,
      List<String> actionButtons,
      String launch}) {
    if (!Directory(_dir.path).existsSync()) {
      setState(() {
        _isPathValid = false;
      });
      _showDialog(title, content, actionButtons, launch);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isdownloadedClicked) {
      _dir = Directory('/storage/emulated/0/statusdownloader');
    } else {
      _dir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
      _checkDir();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Status Downloader"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2,
                        color:
                            _isdownloadedClicked ? Colors.red : Colors.white),
                    shape: BoxShape.circle),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isdownloadedClicked = !_isdownloadedClicked;
                    });
                    isDownlaoded.value = _isdownloadedClicked;
                  },
                  child: Icon(
                    Icons.arrow_downward,
                    color: _isdownloadedClicked ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green,
              Colors.white,
            ],
          )),
          child: ValueListenableBuilder(
              valueListenable: imgOrVideo,
              builder: (BuildContext context, value, Widget child) {
                return Stack(alignment: Alignment.center, children: [
                  Positioned.fill(
                    child: _isGranted && _isPathValid
                        ? value == 0
                            ? StatusImage(dir: _dir)
                            : StatusVideo(dir: _dir)
                        : Container(
                            color: Colors.white,
                          ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: BottomButton(),
                  ),
                ]);
              }),
        ));
  }
}

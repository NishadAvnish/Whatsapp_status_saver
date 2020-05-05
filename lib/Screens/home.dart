import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:status_downloader/Listenable/imgOrVideo.dart';
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
  @override
  void initState() {
    super.initState();
    _dir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.storage.status;

    if (status.isUndetermined || status.isDenied) {
      _askForPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isGranted) {
      //do nothing in this case
      _checkDir();
    }
  }

  Future<void> _askForPermission() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage].request();
    if (statuses[Permission.storage] == PermissionStatus.granted) {
      _checkDir();
    } else if (statuses[Permission.storage] ==
        PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  void _checkDir() {
    if (!Directory(_dir.path).existsSync()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Install Whatsapp",
                style: Theme.of(context).textTheme.subhead),
            content: Text(
                "You need to install Whatsapp to get access to your friend's status",
                style: Theme.of(context).textTheme.body1),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok", style: Theme.of(context).textTheme.body1),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              FlatButton(
                  // if whatsapp is not yet downloaded it will open play store to download whatsapp.
                  onPressed: () => OpenAppstore.launch(
                      androidAppId: "com.whatsapp&hl=en",
                      iOSAppId: "310633997"),
                  child: Text("Download Whatsapp",
                      style: Theme.of(context).textTheme.body1)),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WhatsApp Status")),
      body: ValueListenableBuilder(
        valueListenable: imgOrVideo,
        builder: (BuildContext context, value, Widget child) {
          return Stack(alignment: Alignment.center, children: [
            Positioned.fill(
                child: value == 0
                    ? StatusImage(dir: _dir)
                    : StatusVideo(dir: _dir)),
            Positioned(
              bottom: 15,
              child: BottomButton(),
            )
          ]);
        },
      ),
    );
  }
}

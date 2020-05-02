import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerScreen extends StatefulWidget {
  final List<String> videoList;
  final int index;
  VideoPlayerScreen({Key key, this.videoList,this.index}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  VoidCallback listener;
  Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  bool _isPortrait = true;
  bool _isStackOpen = true;
  double _value = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File(widget.videoList[widget.index]));
    _initializeVideoPlayerFuture = _controller.initialize();
    
    _controller.setVolume(1);
    _controller.setLooping(false);
    //_controller.addListener(_changeValue);

    _controller.addListener(() => setState(() {
          _value = _controller.value.position.inSeconds.toDouble();
        }));
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    // _orientation();
    _controller.dispose();
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.removeListener(listener);
    }
    super.deactivate();
  }

  Widget _getMediaPlayer() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _previewVideo(_controller);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isPortrait
          ? Dialog(
              child: Container(
                 // height: MediaQuery.of(context).size.height * 0.4,
                  child: _getMediaPlayer()),
            )
          : _getMediaPlayer(),
    );
  }

  Widget _previewVideo(VideoPlayerController controller) {
    final height = _isPortrait
        ? MediaQuery.of(context).size.height * 0.4
        : MediaQuery.of(context).size.height;
    if (controller == null) {
      isPlaying = false;
      return const Text('Please Select or Record a Video.');
    } else if (controller.value.initialized) {
      return Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: InkWell(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(
                      controller,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _isStackOpen = !_isStackOpen;
                    });
                  },
                  onDoubleTap: () {
                    if (isPlaying) {
                      _controller.pause();
                      isPlaying = false;
                    } else {
                      _controller.play();
                      isPlaying = true;
                    }
                  }),
            ),
            _isStackOpen
                ? Container()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _isStackOpen = !_isStackOpen;
                      });
                    },
                    child: Container(
                      height: controller.value.size.height,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (_controller.value.isPlaying) {
                                            controller.pause();
                                          } else {
                                            controller.play();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Slider(
                                  onChanged: (double changedValue) {
                                    setState(() {
                                      _value = changedValue;
                                      _controller.seekTo(Duration(
                                          seconds: changedValue.floor()));
                                    });
                                  },
                                  onChangeStart: (changedValue) {
                                    setState(() {
                                      _value = changedValue;
                                    });
                                  },
                                  value: _value,
                                  min: 0.0,
                                  max: controller.value.duration.inSeconds
                                      .toDouble(),
                                  label: _value.toString(),
                                ),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 0,
                                      right: 10.0 +
                                          MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                  child: Icon(
                                    _isPortrait
                                        ? Icons.fullscreen
                                        : Icons.fullscreen_exit,
                                    size: 33,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () => _orientation(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      );
    } else {
      isPlaying = false;
      return const Text('Error Loading Video');
    }
  }

  void _orientation() {
    if (_isPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);

      setState(() {
        _isPortrait = false;
      });
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      setState(() {
        _isPortrait = true;
      });
    }
  }
}
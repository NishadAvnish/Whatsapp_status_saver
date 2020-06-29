import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class VideoViewer extends StatefulWidget {
  final String videoFilePath;
  VideoViewer({this.videoFilePath});

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController _controller;
  VoidCallback listener;
  Future<void> _initializeVideoPlayerFuture;
  double _value = 0.0;
  bool _showbutton = true;
  @override
  void initState() {
    super.initState();

    // Create an store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.file(File(widget.videoFilePath));

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setVolume(1);
    _controller.addListener(() {
      if (mounted)
        setState(
          () {
            //_value to change the slider position based on video position.
            _value = _controller.value.position.inSeconds.toDouble();
          },
        );
    });
    _controller.play();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the VideoPlayer.
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              InkWell(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                onTap: () {
                  setState(() {
                    _showbutton = !_showbutton;
                  });
                },
              ),
              _showbutton
                  ? Container()
                  : Stack(
                      alignment: Alignment.bottomCenter,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 800),
                          opacity: !_showbutton && _controller.value.isPlaying
                              ? 0
                              : 1,
                          curve: Curves.easeInOut,
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black26,
                            ),
                            //height: _controller.value.size.height,

                            child: Center(
                              child: IconButton(
                                iconSize: 80,
                                icon: _controller.value.isPlaying
                                    ? Icon(Icons.pause)
                                    : Icon(Icons.play_arrow),
                                onPressed: () {
                                  !_controller.value.isPlaying
                                      ? _controller.play()
                                      : _controller.pause();
                                },
                                //  child: Icons.play_arrow,
                                color: Colors.white,
                                //  size: 100.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 1000),
                            opacity: _showbutton ? 0 : 1,
                            curve: Curves.easeInOut,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${_controller.value.position.inMinutes.remainder(60).toString().padLeft(2, "0")} : ${_controller.value.position.inSeconds.remainder(60).toString().padLeft(2, "0")} ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: videoSeeker(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Slider videoSeeker() {
    return Slider(
        value: _value,
        min: 0.0,
        max: _controller.value.duration.inSeconds.toDouble(),
        onChanged: (double _changeValue) {
          setState(() {
            _value = _changeValue;
            _controller.seekTo(Duration(seconds: _changeValue.floor()));
          });
        });
  }
}

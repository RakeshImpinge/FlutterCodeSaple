import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../app_themes.dart';
import '../services/preferenecs.dart';

class VideoPlayerView extends StatefulWidget {
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
    //_controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
      Container(
        decoration: ShapeDecoration(
            color: isDarkMode(context)
                ? AppThemes.greyLightColor3
                : Theme.of(context).indicatorColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            )),
              padding: const EdgeInsets.all(0),
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          
          child: VideoPlayer(_controller),)
            : Container(
          decoration: ShapeDecoration(
              color: isDarkMode(context)
                  ? AppThemes.greyLightColor3
                  : Theme.of(context).indicatorColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
        ),
      ),

      IconButton( alignment: Alignment.center,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        icon: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),],
    );
  }
}




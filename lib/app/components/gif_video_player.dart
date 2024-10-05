// Widget to handle video playback of MP4 GIFs
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GifVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const GifVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _GifVideoPlayerState createState() => _GifVideoPlayerState();
}

class _GifVideoPlayerState extends State<GifVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.contentUri(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Update UI once the video is initialized
        _controller.setLooping(true); // Loop the GIF-style video
        _controller.play(); // Automatically play the video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key? key,
    required this.width,
    required this.height,
    this.showControl = true,
    this.controller,
  }) : super(key: key);

  final double width;
  final double height;
  final bool showControl;
  final VideoPlayerController? controller;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ChewieController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      debugPrint('hohohoho');
      _controller = ChewieController(
        videoPlayerController: widget.controller!,
        startAt: widget.controller!.value.position,
        autoPlay: widget.controller?.value.isPlaying ?? false,
        showControls: widget.showControl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          color: Colors.green,
          child: _controller == null
              ? const Center(child: CircularProgressIndicator())
              : Chewie(controller: _controller!),
        )
      ],
    );
  }
}

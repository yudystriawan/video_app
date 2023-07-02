import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    Key? key,
    required this.width,
    required this.height,
    this.showControl = true,
  }) : super(key: key);

  final double width;
  final double height;
  final bool showControl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          buildWhen: (p, c) => p.currentVideo != c.currentVideo,
          builder: (context, state) {
            debugPrint('hohohoho');
            return Container(
              width: width,
              height: height,
              color: Colors.green,
              child: state.currentVideo == null
                  ? const Center(child: CircularProgressIndicator())
                  : Chewie(
                      controller: ChewieController(
                        videoPlayerController: state.controller!,
                        startAt: state.controller!.value.position,
                        autoPlay: state.controller?.value.isPlaying ?? false,
                        showControls: showControl,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}

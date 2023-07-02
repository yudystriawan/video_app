import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/video_player/video_player_bloc.dart';

@RoutePage()
class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoPlayer = context.read<VideoPlayerBloc>();

    return Scaffold(
      body: Chewie(
        controller: ChewieController(
          videoPlayerController: videoPlayer.videoPlayerController!,
          autoPlay: true,
          fullScreenByDefault: true
        ),
      ),
    );
  }
}

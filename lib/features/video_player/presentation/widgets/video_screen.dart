import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          buildWhen: (p, c) => p.status != c.status,
          builder: (context, state) {
            return Container(
              width: width,
              height: height,
              color: Colors.green,
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Chewie(
                      controller: ChewieController(
                        videoPlayerController: context
                            .read<VideoPlayerBloc>()
                            .videoPlayerController!,
                        autoPlay: state.isPlaying,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}

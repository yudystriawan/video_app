import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/core/utils/util.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoDurationWidget extends StatelessWidget {
  const VideoDurationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          context.watch<VideoPlayerBloc>().controller!.videoPlayerController,
      builder: (context, value, child) {
        return Text(
          '${value.position.formatDuration()} / ${value.duration.formatDuration()}',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

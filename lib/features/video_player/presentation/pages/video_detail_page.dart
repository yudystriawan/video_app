import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';

import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';
import '../widgets/expnaded_player_widget.dart';
import '../widgets/mini_player_widget.dart';

@RoutePage()
class VideoDetailPage extends StatelessWidget {
  const VideoDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
      buildWhen: (p, c) => p.currentVideo != c.currentVideo,
      builder: (context, state) {
        ChewieController chewieController = ChewieController(
          videoPlayerController:
              context.watch<VideoPlayerBloc>().videoPlayerController!,
        );

        return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
          builder: (context, state) {
            return Miniplayer(
              valueNotifier:
                  context.watch<MiniPlayerBloc>().playerExpandProgress,
              minHeight: state.playerMinHeight,
              maxHeight: state.playerMaxHeight,
              builder: (height, percentage) {
                final isMiniplayer =
                    percentage < miniplayerPercentageDeclaration;
                final width = MediaQuery.of(context).size.width;
                final maxPlayerSize = width * 0.4;

                if (!isMiniplayer) {
                  return ExpandedPlayerWidget(
                    height: height,
                    maxPlayerSize: maxPlayerSize,
                    controller: chewieController,
                  );
                }
                return MiniPlayerWidget(
                  height: height,
                  maxPlayerSize: maxPlayerSize,
                  controller: chewieController.copyWith(showControls: false),
                );
              },
            );
          },
        );
      },
    );
  }
}

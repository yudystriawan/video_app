import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';

import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';
import '../widgets/expanded_player_widget.dart';
import '../widgets/mini_player_widget.dart';

@RoutePage()
class VideoDetailPage extends StatelessWidget {
  const VideoDetailPage({
    super.key,
    required this.miniplayerController,
  });

  final MiniplayerController miniplayerController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
      buildWhen: (p, c) => p.currentVideo != c.currentVideo,
      builder: (context, state) {
        return Offstage(
          offstage: state.currentVideo == null,
          child: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
            builder: (context, state) {
              return Miniplayer(
                valueNotifier:
                    context.watch<MiniPlayerBloc>().playerExpandProgress,
                controller: miniplayerController,
                minHeight: state.playerMinHeight,
                maxHeight: state.playerMaxHeight,
                builder: (height, percentage) {
                  final isMiniplayer =
                      percentage < miniplayerPercentageDeclaration;
                  final width = MediaQuery.of(context).size.width;
                  final maxPlayerSize = width * 0.4;

                  if (!isMiniplayer) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        // leave empty
                        // if not, it will minimize the screen on tap
                      },
                      child: ExpandedPlayerWidget(
                        height: height,
                        maxPlayerSize: maxPlayerSize,
                        controller: context.watch<VideoPlayerBloc>().controller,
                      ),
                    );
                  }
                  return MiniPlayerWidget(
                    height: height,
                    maxPlayerSize: maxPlayerSize,
                    controller: context
                        .watch<VideoPlayerBloc>()
                        .controller
                        ?.copyWith(showControls: false),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

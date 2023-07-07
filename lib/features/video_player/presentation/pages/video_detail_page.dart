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
  const VideoDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoPlayerBloc, VideoPlayerState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.isLoading) {
          log('loading...');
        }
      },
      child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
        buildWhen: (p, c) => p.status != c.status,
        builder: (context, state) {
          // ChewieController? chewieController;

          // if (state.isLoading) {
          //   context
          //       .read<MiniPlayerBloc>()
          //       .add(const MiniPlayerEvent.expanded());
          // }

          // if (state.isPlaying) {
          //   chewieController = context.watch<VideoPlayerBloc>().oontroller!;
          // }

          return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  debugPrint('tapped');
                },
                child: Miniplayer(
                  valueNotifier:
                      context.watch<MiniPlayerBloc>().playerExpandProgress,
                  controller:
                      context.watch<MiniPlayerBloc>().miniplayerController,
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
                          controller:
                              context.watch<VideoPlayerBloc>().controller,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

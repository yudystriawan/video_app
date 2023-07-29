import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/util.dart';
import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';
import 'video_screen.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({
    Key? key,
    required this.height,
    required this.maxPlayerSize,
    this.controller,
  }) : super(key: key);

  final double height;
  final double maxPlayerSize;
  final ChewieController? controller;

  @override
  Widget build(BuildContext context) {
    final videoPlayerController =
        context.watch<VideoPlayerBloc>().controller?.videoPlayerController;

    return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      builder: (context, state) {
        final playerMinHeight = state.playerMinHeight;
        final playerMaxHeight = state.playerMaxHeight;

        final percentageMiniplayer = percentageFromValueInRange(
          min: playerMinHeight,
          max: playerMaxHeight * miniplayerPercentageDeclaration +
              playerMinHeight,
          value: height,
        );

        final elementOpacity = 1 - 1 * percentageMiniplayer;
        final progressIndicatorHeight = 4 - 4 * percentageMiniplayer;

        return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          buildWhen: (p, c) => p.currentVideo != c.currentVideo,
          builder: (context, state) {
            final currentVideo = state.currentVideo;

            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      VideoScreen(
                        width: maxPlayerSize,
                        height: maxPlayerSize + progressIndicatorHeight,
                        showControl: false,
                        controller: controller,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Opacity(
                            opacity: elementOpacity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(currentVideo?.title ?? '-'),
                                Text(currentVideo?.subtitle ?? '-'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context
                            .read<VideoPlayerBloc>()
                            .add(const VideoPlayerEvent.stopped()),
                      ),
                      if (videoPlayerController != null)
                        ValueListenableBuilder(
                          valueListenable: videoPlayerController,
                          builder: (context, value, child) {
                            final isPlaying = value.isPlaying;

                            return Padding(
                              padding: EdgeInsets.only(right: 3.w),
                              child: Opacity(
                                opacity: elementOpacity,
                                child: IconButton(
                                  icon: Icon(isPlaying
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_filled),
                                  onPressed: () {
                                    if (isPlaying) {
                                      context
                                          .read<VideoPlayerBloc>()
                                          .add(const VideoPlayerEvent.paused());
                                      return;
                                    }

                                    context
                                        .read<VideoPlayerBloc>()
                                        .add(const VideoPlayerEvent.resumed());
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: progressIndicatorHeight.w,
                  child: Opacity(
                    opacity: elementOpacity,
                    child: videoPlayerController != null
                        ? ValueListenableBuilder(
                            valueListenable: context
                                .watch<VideoPlayerBloc>()
                                .controller!
                                .videoPlayerController,
                            builder: (BuildContext context,
                                VideoPlayerValue value, Widget? child) {
                              final durationLinear = percentageFromDuration(
                                value.position,
                                Duration.zero,
                                value.duration,
                              );
                              return LinearProgressIndicator(
                                value: durationLinear,
                              );
                            },
                          )
                        : const LinearProgressIndicator(value: 0),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
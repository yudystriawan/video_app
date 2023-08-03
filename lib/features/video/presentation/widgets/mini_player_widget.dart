import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/util.dart';
import '../../../../shared/widgets/icon.dart';
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

    final size = MediaQuery.of(context).size;

    return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      builder: (context, state) {
        final playerMinHeight = state.playerMinHeight;
        final playerMaxHeight = state.playerMaxHeight;

        double percentageMiniplayer = percentageFromValueInRange(
          min: playerMinHeight,
          max: playerMaxHeight * miniplayerPercentageDeclaration +
              playerMinHeight,
          value: height,
        );
        percentageMiniplayer =
            percentageMiniplayer > 0.9 ? 1 : percentageMiniplayer;

        // get width
        double width =
            maxPlayerSize + (size.width - maxPlayerSize) * percentageMiniplayer;
        if (percentageMiniplayer > 0.9) {
          width = size.width;
        }

        // get height
        double playerHeight = height;

        final elementOpacity = 1 - 1 * percentageMiniplayer;
        final progressIndicatorHeight = 2.w - 2.w * percentageMiniplayer;

        return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          buildWhen: (p, c) => p.currentVideo != c.currentVideo,
          builder: (context, state) {
            final currentVideo = state.currentVideo;

            debugPrint('opacity: $elementOpacity');
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      VideoScreen(
                        width: width,
                        height: playerHeight,
                        showControl: false,
                        controller: controller,
                      ),
                      SizedBox(
                        width: _getWidth(
                          min: 0,
                          max: 10.w,
                          ratio: percentageMiniplayer,
                        ),
                      ),
                      Expanded(
                        child: Opacity(
                          opacity: elementOpacity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentVideo?.title ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                currentVideo?.subtitle ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _getWidth(
                          min: 0,
                          max: 16.w,
                          ratio: percentageMiniplayer,
                        ),
                      ),
                      Opacity(
                        opacity: elementOpacity,
                        child: AppIcon(
                          size: _getWidth(
                              min: 0, max: 24.w, ratio: percentageMiniplayer),
                          icon: const Icon(Icons.close),
                          onTap: () => context
                              .read<VideoPlayerBloc>()
                              .add(const VideoPlayerEvent.stopped()),
                        ),
                      ),
                      if (videoPlayerController != null) ...[
                        SizedBox(
                          width: _getWidth(
                              min: 0, max: 32.w, ratio: percentageMiniplayer),
                        ),
                        ValueListenableBuilder(
                          valueListenable: videoPlayerController,
                          builder: (context, value, child) {
                            final isPlaying = value.isPlaying;

                            return Opacity(
                              opacity: elementOpacity,
                              child: AppIcon(
                                size: _getWidth(
                                  min: 0,
                                  max: 24.w,
                                  ratio: percentageMiniplayer,
                                ),
                                icon: Icon(isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled),
                                onTap: () {
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
                            );
                          },
                        ),
                      ],
                      SizedBox(
                        width: _getWidth(
                          min: 0,
                          max: 16.w,
                          ratio: percentageMiniplayer,
                        ),
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

  _getWidth({
    required double min,
    required double max,
    required double ratio,
  }) {
    ratio = 1 - 1 * ratio;
    return min + (max - min) * ratio;
  }
}

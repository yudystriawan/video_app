import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:video_app/features/video_player/presentation/bloc/mini_player/mini_player_bloc.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_screen.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/util.dart';
import '../bloc/video_player/video_player_bloc.dart';

@RoutePage()
class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerBloc _videoPlayerBloc;

  @override
  void initState() {
    super.initState();
    _videoPlayerBloc = context.read<VideoPlayerBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      builder: (context, state) {
        return Miniplayer(
          minHeight: state.playerMinHeight,
          maxHeight: state.playerMaxHeight,
          builder: (height, percentage) {
            final isMiniplayer = percentage < miniplayerPercentageDeclaration;
            final width = MediaQuery.of(context).size.width;
            final maxPlayerSize = width * 0.4;

            if (!isMiniplayer) {
              return FullSizeDetailedPlayer(
                height: height,
                maxPlayerSize: maxPlayerSize,
              );
            }
            return MiniDetailedPlayer(
              height: height,
              maxPlayerSize: maxPlayerSize,
            );
          },
        );
      },
    );
  }
}

class FullSizeDetailedPlayer extends StatelessWidget {
  const FullSizeDetailedPlayer({
    Key? key,
    required this.height,
    required this.maxPlayerSize,
  }) : super(key: key);

  final double height;
  final double maxPlayerSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      builder: (context, state) {
        final width = MediaQuery.of(context).size.width;

        var percentageExpandedPlayer = percentageFromValueInRange(
          min: state.playerMaxHeight * miniplayerPercentageDeclaration +
              state.playerMinHeight,
          max: state.playerMaxHeight,
          value: height,
        );
        if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
        final paddingVertical = valueFromPercentageInRange(
            min: 0, max: 10, percentage: percentageExpandedPlayer);
        final double heightWithoutPadding = height - paddingVertical * 2;
        final double playerheight = heightWithoutPadding > maxPlayerSize
            ? maxPlayerSize
            : heightWithoutPadding;

        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: VideoScreen(
                width: width,
                height: playerheight,
              ),
            ),
            BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
              buildWhen: (p, c) => p.currentVideo != c.currentVideo,
              builder: (context, state) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33),
                    child: Opacity(
                      opacity: percentageExpandedPlayer,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(state.currentVideo?.title ?? '-'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class MiniDetailedPlayer extends StatelessWidget {
  const MiniDetailedPlayer({
    Key? key,
    required this.height,
    required this.maxPlayerSize,
  }) : super(key: key);

  final double height;
  final double maxPlayerSize;

  @override
  Widget build(BuildContext context) {
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
          builder: (context, state) {
            final currentVideo = state.currentVideo;
            final videoController = state.controller;

            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      VideoScreen(
                        width: maxPlayerSize,
                        height: maxPlayerSize + progressIndicatorHeight,
                        showControl: false,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
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
                      ValueListenableBuilder(
                        valueListenable: state.controller!,
                        builder: (context, value, child) {
                          final isPlaying = value.isPlaying;
                          
                          return Padding(
                            padding: const EdgeInsets.only(right: 3),
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
                  height: progressIndicatorHeight,
                  child: Opacity(
                    opacity: elementOpacity,
                    child: ValueListenableBuilder(
                      valueListenable: videoController!,
                      builder: (
                        BuildContext context,
                        VideoPlayerValue value,
                        Widget? child,
                      ) {
                        final durationLinear = percentageFromDuration(
                          videoController.value.position,
                          Duration.zero,
                          videoController.value.duration,
                        );
                        return LinearProgressIndicator(
                          value: durationLinear,
                        );
                      },
                    ),
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

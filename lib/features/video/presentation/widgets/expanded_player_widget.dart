import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/util.dart';
import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';
import 'video_screen.dart';

class ExpandedPlayerWidget extends StatelessWidget {
  const ExpandedPlayerWidget({
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

        return SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: VideoScreen(
                  width: width,
                  height: playerheight,
                  controller: controller,
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
          ),
        );
      },
    );
  }
}

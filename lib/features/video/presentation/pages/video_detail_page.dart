import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../../../injection.dart';
import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/recommended_video_loader/recommended_video_loader_bloc.dart';
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
    return BlocProvider(
      create: (context) => getIt<RecommendedVideoLoaderBloc>(),
      child: BlocListener<VideoPlayerBloc, VideoPlayerState>(
        listenWhen: (p, c) => p.videoQueue != c.videoQueue,
        listener: (context, state) {
          // get recommended videos
          final currentVideo = state.currentVideo;
          if (currentVideo != null) {
            context
                .read<RecommendedVideoLoaderBloc>()
                .add(const RecommendedVideoLoaderEvent.fetched('1'));
          }
        },
        child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          buildWhen: (p, c) => p.videoQueue != c.videoQueue,
          builder: (context, state) {
            return Offstage(
              offstage: state.videoQueue.isEmpty(),
              child: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                builder: (context, state) {
                  double maxPlayerHeight = 210.w;

                  if (state.isDismissed) {
                    return const SizedBox();
                  }

                  return Miniplayer(
                    valueNotifier:
                        context.watch<MiniPlayerBloc>().playerExpandProgress,
                    controller: miniplayerController,
                    minHeight: state.playerMinHeight,
                    maxHeight: state.playerMaxHeight,
                    builder: (height, percentage) {
                      final isMiniplayer = height < maxPlayerHeight;

                      final maxMiniPlayerWidth = 129.w;

                      if (!isMiniplayer) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // leave empty
                            // if not, it will minimize the screen on tap
                          },
                          child: ExpandedPlayerWidget(
                            height: height,
                            maxPlayerHeight: maxPlayerHeight,
                            controller:
                                context.watch<VideoPlayerBloc>().controller,
                          ),
                        );
                      }

                      return MiniPlayerWidget(
                        height: height,
                        maxPlayerWidth: maxMiniPlayerWidth,
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
        ),
      ),
    );
  }
}

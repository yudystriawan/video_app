import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/features/video/presentation/widgets/recommended_video_list_widget.dart';
import 'package:video_app/features/video/presentation/widgets/video_comment_widget.dart';
import 'package:video_app/features/video/presentation/widgets/video_functions_widget.dart';
import 'package:video_app/shared/widgets/category_button.dart';
import 'package:video_app/shared/widgets/circle_container.dart';

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
        final double playerheight =
            percentageExpandedPlayer > 0 ? 210.w : maxPlayerSize;

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
                  final currentVideo = state.currentVideo;

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Opacity(
                        opacity: percentageExpandedPlayer,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  EdgeInsets.all(12.w).copyWith(bottom: 8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentVideo?.title ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 8.w,
                                  ),
                                  const Text('999K Views 3d ago ')
                                ],
                              ),
                            ),
                            Container(
                              height: 48.w,
                              padding: EdgeInsets.symmetric(
                                vertical: 8.w,
                                horizontal: 12.w,
                              ),
                              child: Row(
                                children: [
                                  CircleContainer(size: 32.w),
                                  SizedBox(
                                    width: 12.w,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Channel name',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        const Text('7.05K'),
                                      ],
                                    ),
                                  ),
                                  CategoryButton(
                                    child: const Text('Subscribe'),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                            const VideoFunctionsWidget(),
                            const VideoCommentWidget(),
                            SizedBox(
                              height: 24.w,
                            ),
                            const RecommendedVideoListWidget(),
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

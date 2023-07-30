import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/features/video/presentation/widgets/video_suggestions_category_widget.dart';

import '../../../../core/utils/util.dart';
import '../../../../shared/widgets/circle_container.dart';
import '../../../../shared/widgets/elevated_button.dart';
import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';
import 'recommended_video_list_widget.dart';
import 'video_comment_widget.dart';
import 'video_functions_widget.dart';
import 'video_screen.dart';

class ExpandedPlayerWidget extends StatefulWidget {
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
  State<ExpandedPlayerWidget> createState() => _ExpandedPlayerWidgetState();
}

class _ExpandedPlayerWidgetState extends State<ExpandedPlayerWidget> {
  final _innerController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      builder: (context, state) {
        final width = MediaQuery.of(context).size.width;

        var percentageExpandedPlayer = percentageFromValueInRange(
          min: state.playerMaxHeight * miniplayerPercentageDeclaration +
              state.playerMinHeight,
          max: state.playerMaxHeight,
          value: widget.height,
        );
        if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;
        final double playerheight =
            percentageExpandedPlayer > 0 ? 210.w : widget.maxPlayerSize;

        return SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: VideoScreen(
                  width: width,
                  height: playerheight,
                  controller: widget.controller,
                ),
              ),
              BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                buildWhen: (p, c) => p.currentVideo != c.currentVideo,
                builder: (context, state) {
                  final currentVideo = state.currentVideo;

                  return Expanded(
                    child: Opacity(
                      opacity: percentageExpandedPlayer,
                      child: NestedScrollView(
                        controller: _innerController,
                        physics: const NeverScrollableScrollPhysics(),
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          debugPrint('isScrolled: $innerBoxIsScrolled');
                          return [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12.w)
                                        .copyWith(bottom: 8.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        AppElevatedButton(
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
                                ],
                              ),
                            ),
                            SliverVisibility(
                              visible: innerBoxIsScrolled,
                              sliver: SliverPersistentHeader(
                                delegate: MyDelegate(
                                    child:
                                        const VideoSuggestionsCategoryWidget()),
                                pinned: true,
                              ),
                            ),
                          ];
                        },
                        body: const RecommendedVideoListWidget(),
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

class MyDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  MyDelegate({
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48.w;

  @override
  double get minExtent => 48.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

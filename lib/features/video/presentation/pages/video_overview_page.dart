import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/app_bar.dart';

import '../../../../injection.dart';
import '../../../../routes/router.dart';
import '../../../../shared/widgets/icon.dart';
import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_loader/video_loader_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';
import '../widgets/video_list_widget.dart';
import 'video_detail_page.dart';

@RoutePage()
class VideoOverviewPage extends StatelessWidget implements AutoRouteWrapper {
  const VideoOverviewPage({
    Key? key,
    this.initialKeyword,
  }) : super(key: key);

  final String? initialKeyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VideoOverviewContent(
        initialKeyword: initialKeyword,
      ),
      // bottomNavigationBar: BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
      //   buildWhen: (p, c) => p.playerMinHeight != c.playerMinHeight,
      //   builder: (context, state) {
      //     if (state.playerMinHeight == 0) return const SizedBox();
      //     return ValueListenableBuilder<double>(
      //       valueListenable:
      //           context.watch<MiniPlayerBloc>().playerExpandProgress,
      //       builder: (BuildContext context, double height, Widget? child) {
      //         final value = percentageFromValueInRange(
      //           min: state.playerMinHeight,
      //           max: state.playerMaxHeight,
      //           value: height,
      //         );

      //         var opacity = 1 - value;
      //         if (opacity < 0) opacity = 0;
      //         if (opacity > 1) opacity = 1;

      //         return SizedBox(
      //           height: kBottomNavigationBarHeight -
      //               kBottomNavigationBarHeight * value,
      //           child: Transform.translate(
      //             offset: Offset(0.0, kBottomNavigationBarHeight * value * 0.5),
      //             child: Opacity(
      //               opacity: opacity,
      //               child: OverflowBox(
      //                 maxHeight: kBottomNavigationBarHeight,
      //                 child: BottomNavigationBar(
      //                   currentIndex: 0,
      //                   selectedItemColor: Colors.blue,
      //                   items: const <BottomNavigationBarItem>[
      //                     BottomNavigationBarItem(
      //                         icon: Icon(Icons.home), label: 'Feed'),
      //                     BottomNavigationBarItem(
      //                         icon: Icon(Icons.library_books),
      //                         label: 'Library'),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<VideoLoaderBloc>()
        ..add(VideoLoaderEvent.fetched(query: initialKeyword)),
      child: this,
    );
  }
}

class VideoOverviewContent extends StatelessWidget {
  const VideoOverviewContent({
    Key? key,
    this.initialKeyword,
  }) : super(key: key);

  final String? initialKeyword;

  @override
  Widget build(BuildContext context) {
    final hasInitialKeyword = initialKeyword?.isNotEmpty ?? false;

    return SafeArea(
      child: Stack(
        children: [
          BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
            buildWhen: (p, c) => p.currentVideo != c.currentVideo,
            builder: (context, state) {
              final currentVideo = state.currentVideo;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        MyAppBar(
                          title: initialKeyword?.isNotEmpty ?? false
                              ? GestureDetector(
                                  onTap: () => context.pushRoute(SearchRoute(
                                      inititalKeyword: initialKeyword)),
                                  child: Container(
                                    height: 24.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: Colors.grey.shade200,
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            initialKeyword ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        AppIcon(
                                          icon: const Icon(Icons.close),
                                          onTap: () =>
                                              context.pushRoute(SearchRoute()),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const Text('Video'),
                          trailing: Row(
                            children: [
                              AppIcon(
                                icon: const Icon(
                                    Icons.notifications_none_outlined),
                                onTap: () {},
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              AppIcon(
                                icon: const Icon(Icons.search),
                                onTap: () => context.pushRoute(SearchRoute()),
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Container(
                                width: 24.w,
                                height: 24.w,
                                decoration: const BoxDecoration(
                                    color: Colors.grey, shape: BoxShape.circle),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          indent: 12.w,
                          endIndent: 12.w,
                        ),
                        if (!hasInitialKeyword)
                          SizedBox(
                            height: 48.w,
                          )
                      ],
                    ),
                    const VideoListWidget(),
                    if (currentVideo != null)
                      BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                        builder: (context, state) {
                          return SizedBox(
                            height: state.playerMinHeight,
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
          VideoDetailPage(
            miniplayerController:
                context.watch<MiniPlayerBloc>().miniplayerController,
          ),
        ],
      ),
    );
  }
}

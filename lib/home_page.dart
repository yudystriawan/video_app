import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/shared/widgets/circle_container.dart';

import 'core/utils/util.dart';
import 'features/video/presentation/bloc/mini_player/mini_player_bloc.dart';
import 'features/video/presentation/bloc/video_player/video_player_bloc.dart';
import 'features/video/presentation/pages/video_detail_page.dart';
import 'main.dart';
import 'routes/router.dart';
import 'shared/widgets/bottom_navigation_bar.dart';

@RoutePage()
class HomePage extends HookWidget {
  const HomePage({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final showBottomNav = useState(false);
    appRouter.addListener(() {
      final currentRouteName = appRouter.current.name;
      showBottomNav.value = currentRouteName != SearchRoute.name;
    });

    return BlocListener<VideoPlayerBloc, VideoPlayerState>(
      listenWhen: (p, c) => p.isFullscreen != c.isFullscreen,
      listener: (context, state) {
        if (state.isFullscreen) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.landscapeLeft]);
          appRouter.push(const VideoFullScreenRoute());
        } else {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
      },
      child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
        buildWhen: (p, c) => p.isFullscreen != c.isFullscreen,
        builder: (context, state) {
          final isFullscreen = state.isFullscreen;

          return Scaffold(
            body: SafeArea(
              child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                buildWhen: (p, c) => p.videoQueue != c.videoQueue,
                builder: (context, state) {
                  return Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(child: child!),
                          if (state.videoQueue.isNotEmpty() && !isFullscreen)
                            BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                              builder: (context, state) {
                                return SizedBox(
                                  height: state.playerMinHeight,
                                );
                              },
                            ),
                        ],
                      ),
                      Offstage(
                        offstage: isFullscreen,
                        child: VideoDetailPage(
                          miniplayerController: context
                              .watch<MiniPlayerBloc>()
                              .miniplayerController,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            bottomNavigationBar: showBottomNav.value
                ? BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                    buildWhen: (p, c) => p.playerMinHeight != c.playerMinHeight,
                    builder: (context, state) {
                      if (state.playerMinHeight == 0) return const SizedBox();

                      if (isFullscreen) return const SizedBox();

                      return ValueListenableBuilder<double>(
                        valueListenable: context
                            .watch<MiniPlayerBloc>()
                            .playerExpandProgress,
                        builder: (BuildContext context, double height,
                            Widget? child) {
                          final value = percentageFromValueInRange(
                            min: state.playerMinHeight,
                            max: state.playerMaxHeight,
                            value: height,
                          );

                          var opacity = 1 - value;
                          if (opacity < 0) opacity = 0;
                          if (opacity > 1) opacity = 1;

                          final totalHeight =
                              getHeightBottomNavigationBar(context);

                          return Container(
                            color: Colors.white,
                            height: totalHeight - (totalHeight * value),
                            child: Transform.translate(
                              offset: Offset(0.0, totalHeight * value * 0.5.w),
                              child: Opacity(
                                opacity: opacity,
                                child: AppBottomNavigationBar(
                                  items: [
                                    const AppNavigationBarItem(
                                      icon: Icon(Icons.home_outlined),
                                      activeIcon: Icon(Icons.home),
                                      label: 'Home',
                                    ),
                                    const AppNavigationBarItem(
                                      icon: Icon(Icons.shop_two_outlined),
                                      activeIcon: Icon(Icons.shop_two),
                                      label: 'Short',
                                    ),
                                    AppNavigationBarItem(
                                      icon: CircleContainer(
                                        size: 36.w,
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: Colors.black, width: 1.w),
                                        child: Icon(
                                          Icons.add,
                                          size: 36.w,
                                        ),
                                      ),
                                    ),
                                    const AppNavigationBarItem(
                                      icon: Icon(Icons.subscriptions_outlined),
                                      activeIcon: Icon(Icons.subscriptions),
                                      label: 'Subscription',
                                    ),
                                    const AppNavigationBarItem(
                                      icon: Icon(Icons.video_library_outlined),
                                      activeIcon: Icon(Icons.video_library),
                                      label: 'Library',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : null,
          );
        },
      ),
    );
  }
}

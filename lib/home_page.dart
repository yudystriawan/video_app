import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import 'core/utils/util.dart';
import 'features/video/presentation/bloc/mini_player/mini_player_bloc.dart';
import 'features/video/presentation/bloc/video_player/video_player_bloc.dart';
import 'features/video/presentation/pages/video_detail_page.dart';
import 'main.dart';
import 'routes/router.dart';
import 'shared/widgets/bottom_navigation_bar.dart';
import 'shared/widgets/icon.dart';

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
                    if (state.videoQueue.isNotEmpty())
                      BlocBuilder<MiniPlayerBloc, MiniPlayerState>(
                        builder: (context, state) {
                          return SizedBox(
                            height: state.playerMinHeight,
                          );
                        },
                      ),
                  ],
                ),
                VideoDetailPage(
                  miniplayerController:
                      context.watch<MiniPlayerBloc>().miniplayerController,
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
                if (state.playerMinHeight == 0) {
                  return const SizedBox();
                }
                return ValueListenableBuilder<double>(
                  valueListenable:
                      context.watch<MiniPlayerBloc>().playerExpandProgress,
                  builder:
                      (BuildContext context, double height, Widget? child) {
                    final value = percentageFromValueInRange(
                      min: state.playerMinHeight,
                      max: state.playerMaxHeight,
                      value: height,
                    );

                    var opacity = 1 - value;
                    if (opacity < 0) opacity = 0;
                    if (opacity > 1) opacity = 1;

                    final totalHeight = getHeightBottomNavigationBar(context);

                    return Container(
                      color: Colors.white,
                      height: totalHeight - (totalHeight * value),
                      child: Transform.translate(
                        offset: Offset(0.0, totalHeight * value * 0.5.w),
                        child: Opacity(
                          opacity: opacity,
                          child: const AppBottomNavigationBar(
                            items: [
                              AppNavigationBarItem(
                                icon: AppIcon(icon: Icon(Icons.home)),
                                label: 'Home',
                              ),
                              AppNavigationBarItem(
                                icon: AppIcon(
                                    icon: Icon(Icons.video_library_outlined)),
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
  }
}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/app_bar.dart';

import '../../../../routes/router.dart';
import '../../../../shared/widgets/icon.dart';
import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';
import '../widgets/video_list_widget.dart';
import 'video_detail_page.dart';

@RoutePage()
class VideoOverviewPage extends StatelessWidget {
  const VideoOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                            title: const Text('Video'),
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
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            indent: 12.w,
                            endIndent: 12.w,
                          ),
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
      ),
    );
  }
}

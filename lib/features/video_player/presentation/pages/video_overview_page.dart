import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: Colors.grey,
      body: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
        buildWhen: (p, c) => p.currentVideo != c.currentVideo,
        builder: (context, state) {
          final currentVideo = state.currentVideo;
          return Stack(
            children: [
              Column(
                children: [
                  AppBar(title: const Text('Videos')),
                  const Expanded(child: VideoListWidget()),
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
              if (currentVideo != null) const VideoDetailPage(),
            ],
          );
        },
      ),
    );
  }
}

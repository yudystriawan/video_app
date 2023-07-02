import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/features/video_player/presentation/pages/video_detail_page.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_list_widget.dart';
import 'package:video_app/router/router.dart';

import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';

@RoutePage()
class VideoOverviewPage extends StatefulWidget {
  const VideoOverviewPage({super.key});

  @override
  State<VideoOverviewPage> createState() => _VideoOverviewPageState();
}

class _VideoOverviewPageState extends State<VideoOverviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(title: const Text('Videos')),
              Expanded(child: const VideoListWidget()),
            ],
          ),
          BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
            buildWhen: (p, c) => p.currentVideo != c.currentVideo,
            builder: (context, state) {
              if (state.currentVideo == null) return Container();
              return VideoDetailPage();
            },
          ),
        ],
      ),
    );
  }
}

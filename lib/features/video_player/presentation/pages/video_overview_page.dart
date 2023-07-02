import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_list_widget.dart';
import 'package:video_app/router/router.dart';

import '../bloc/video_player/video_player_bloc.dart';

@RoutePage()
class VideoOverviewPage extends StatelessWidget {
  const VideoOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoPlayerBloc, VideoPlayerState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if(state.isPlaying){
          context.router.push(VideoPlayerRoute());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Videos'),
        ),
        body: VideoListWidget(),
      ),
    );
  }
}

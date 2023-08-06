import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/features/video/presentation/bloc/mini_player/mini_player_bloc.dart';
import 'package:video_app/features/video/presentation/bloc/video_player/video_player_bloc.dart';

@RoutePage()
class ShortsOverviewPage extends StatefulWidget {
  const ShortsOverviewPage({super.key});

  @override
  State<ShortsOverviewPage> createState() => _ShortsOverviewPageState();
}

class _ShortsOverviewPageState extends State<ShortsOverviewPage> {
  @override
  void initState() {
    super.initState();
    //pause video
    context.read<VideoPlayerBloc>().add(const VideoPlayerEvent.paused());

    //dismissed mini player
    context.read<MiniPlayerBloc>().add(const MiniPlayerEvent.dismissed());
  }

  @override
  void deactivate() {
    // un-dismiss mini player
    context.read<MiniPlayerBloc>().add(const MiniPlayerEvent.collapsed());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Shorts'),
        ),
      ),
    );
  }
}

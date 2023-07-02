import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_screen.dart';

import '../bloc/video_player/video_player_bloc.dart';

@RoutePage()
class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerBloc _videoPlayerBloc;

  @override
  void initState() {
    super.initState();
    _videoPlayerBloc = context.read<VideoPlayerBloc>();
  }

  @override
  void dispose() {
    _videoPlayerBloc.add(const VideoPlayerEvent.stopped());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            VideoScreen(
              width: screenWidth,
              height: screenHeight * 0.3,
            ),
          ],
        ),
      ),
    );
  }
}

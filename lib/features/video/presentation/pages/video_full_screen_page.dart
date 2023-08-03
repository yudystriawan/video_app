import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/features/video/presentation/widgets/video_screen.dart';

import '../bloc/video_player/video_player_bloc.dart';

@RoutePage(name: 'VideoFullScreenRoute')
class VideoFullScreenPage extends StatefulWidget {
  const VideoFullScreenPage({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoFullScreenPage> createState() => _VideoFullScreenPageState();
}

class _VideoFullScreenPageState extends State<VideoFullScreenPage> {
  @override
  void initState() {
    super.initState();
    // Hide the status bar when this page is displayed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Show the status bar again when the user leaves this page
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<VideoPlayerBloc, VideoPlayerState>(
      listenWhen: (p, c) => p.isFullscreen != c.isFullscreen,
      listener: (context, state) {
        if (!state.isFullscreen) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          context.router.popForced();
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          context
              .read<VideoPlayerBloc>()
              .add(const VideoPlayerEvent.fullscreenToggled());
          return false;
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: VideoScreen(
            controller: context.watch<VideoPlayerBloc>().controller,
            width: size.width,
            height: size.height,
          ),
        ),
      ),
    );
  }
}

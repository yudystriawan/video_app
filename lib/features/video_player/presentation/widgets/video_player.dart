import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/utils/util.dart';

final ValueNotifier<double> playerExpandProgress =
    ValueNotifier(kBottomNavigationBarHeight);

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool _initializing = false;
  bool _isDimissed = false;
  double miniplayerPercentageDeclaration = 0.2;

  final MiniplayerController _miniplayerController = MiniplayerController();
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerInitialized();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _miniplayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const playerMinHeight = kBottomNavigationBarHeight;
    final playerMaxHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    if (_isDimissed) {
      return const SizedBox();
    }

    return Miniplayer(
      valueNotifier: playerExpandProgress,
      controller: _miniplayerController,
      minHeight: playerMinHeight,
      maxHeight: playerMaxHeight,
      elevation: 100,
      backgroundColor: Colors.transparent,
      builder: (height, percentage) {
        final isMiniPlayer = percentage < miniplayerPercentageDeclaration;
        final screenWidth = MediaQuery.of(context).size.width;
        final miniPlayerWidth = screenWidth * 0.4;

        var percentageExpandedPlayer = percentageFromValueInRange(
            min: playerMinHeight, max: playerMaxHeight, value: height);
        if (percentageExpandedPlayer < 0) percentageExpandedPlayer = 0;

        final percentageMiniplayer = percentageFromValueInRange(
            min: playerMinHeight,
            max: playerMaxHeight * miniplayerPercentageDeclaration +
                playerMinHeight,
            value: height);

        final elementOpacity = 1 - 1 * percentageMiniplayer;
        final progressIndicatorHeight = 4 - 4 * percentageMiniplayer;

        final playerWidth = valueFromPercentageInRange(
          min: miniPlayerWidth,
          max: screenWidth,
          percentage: percentageExpandedPlayer,
        );

        final playerHeight = valueFromPercentageInRange(
          min: kBottomNavigationBarHeight,
          max: miniPlayerWidth,
          percentage: percentageExpandedPlayer,
        );

        if (_chewieController != null) {
          if (isMiniPlayer || playerWidth < screenWidth) {
            _chewieController = ChewieController(
              videoPlayerController: _chewieController!.videoPlayerController,
              showControls: false,
            );
          } else {
            _chewieController = ChewieController(
              videoPlayerController: _chewieController!.videoPlayerController,
              showControls: true,
            );
          }
        }

        final playerWidget = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: playerWidth,
              height: playerHeight,
              color: Colors.green,
              child: _initializing || _chewieController == null
                  ? const Center(child: CircularProgressIndicator())
                  : Chewie(controller: _chewieController!),
            ),
            if (isMiniPlayer) ...[
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Opacity(
                  opacity: elementOpacity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Title'),
                      Text('Description'),
                    ],
                  ),
                ),
              ),
              if (_chewieController != null)
                ValueListenableBuilder(
                  valueListenable: _chewieController!.videoPlayerController,
                  builder: (context, value, child) {
                    final maxDuration = value.duration.inSeconds;
                    final currentDuration = value.position.inSeconds;

                    final isPlaying = value.isPlaying;
                    final isFinish = currentDuration == maxDuration;

                    return Opacity(
                      opacity: elementOpacity,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (isFinish) {
                                // videoPlayerInitialized();
                                return;
                              }

                              if (isPlaying) {
                                await _chewieController?.pause();
                              } else {
                                await _chewieController?.play();
                              }
                            },
                            icon: Icon(isFinish
                                ? Icons.loop
                                : isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              IconButton(
                onPressed: () async {
                  await _chewieController?.pause();
                  setState(() {
                    _isDimissed = true;
                  });
                },
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 8),
            ]
          ],
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMiniPlayer) ...[
              Expanded(child: playerWidget),
              if (_chewieController != null && _chewieController!.isPlaying)
                SizedBox(
                  height: progressIndicatorHeight,
                  child: ValueListenableBuilder(
                    valueListenable: _chewieController!.videoPlayerController,
                    builder: (context, value, child) {
                      final maxDuration = value.duration.inSeconds;
                      final currentDuration = value.position.inSeconds;

                      final currentPosition = currentDuration / maxDuration;

                      return SizedBox(
                        height: progressIndicatorHeight,
                        child: Opacity(
                          opacity: elementOpacity,
                          child: LinearProgressIndicator(
                            value: currentPosition,
                          ),
                        ),
                      );
                    },
                  ),
                )
            ] else ...[
              playerWidget,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Title'),
                    Text('Description'),
                  ],
                ),
              ),
            ]
          ],
        );
      },
    );
  }

  Future<void> videoPlayerInitialized() async {
    _videoPlayerController;
    _videoPlayerController = VideoPlayerController.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    );

    setState(() {
      _initializing = true;
      _isDimissed = false;
    });
    await _videoPlayerController.initialize();
    createChewieController();
    _initializing = false;
    setState(() {});
  }

  void createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      showControls: false,
      autoPlay: true,
    );
    if (_isDimissed) {
      _miniplayerController.animateToHeight(state: PanelState.MAX);
    }
  }
}

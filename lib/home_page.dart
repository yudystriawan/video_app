import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _initializing = false;

  @override
  void initState() {
    super.initState();
    // videoPlayerInitialized();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.amber,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: kBottomNavigationBarHeight,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.black,
                          width: 160,
                          height: double.maxFinite,
                          child: _initializing || _chewieController == null
                              ? const Center(child: CircularProgressIndicator())
                              : Chewie(controller: _chewieController!),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text('Title'),
                                Text('Description')
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_chewieController != null)
                          ValueListenableBuilder(
                            valueListenable:
                                _chewieController!.videoPlayerController,
                            builder: (context, value, child) {
                              final maxDuration = value.duration.inSeconds;
                              final currentDuration = value.position.inSeconds;

                              final isPlaying = value.isPlaying;
                              final isFinish = currentDuration == maxDuration;

                              return IconButton(
                                onPressed: () async {
                                  if (isFinish) {
                                    videoPlayerInitialized();
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
                              );
                            },
                          ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.close),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  if (_chewieController != null)
                    ValueListenableBuilder(
                      valueListenable: _chewieController!.videoPlayerController,
                      builder: (context, value, child) {
                        final maxDuration = value.duration.inSeconds;
                        final currentDuration = value.position.inSeconds;

                        final currentPosition = currentDuration / maxDuration;

                        return LinearProgressIndicator(
                          value: currentPosition,
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> videoPlayerInitialized() async {
    _videoPlayerController = VideoPlayerController.network(
      'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    );
    setState(() {
      _initializing = true;
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
    _chewieController!.addListener(() {});
  }
}

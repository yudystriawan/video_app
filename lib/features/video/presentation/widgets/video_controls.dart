import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/round_container.dart';
import '../bloc/video_player/video_player_bloc.dart';
import 'video_duration_widget.dart';
import 'video_progress_slider.dart';
import 'video_seek_controll_widget.dart';

class VideoControls extends StatefulWidget {
  const VideoControls({super.key});

  @override
  State<VideoControls> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  ChewieController? _controller;
  bool _isVisible = false;
  Timer? _visibleTimer;
  int _counter = 0;
  final double _iconSize = 24;

  @override
  void initState() {
    super.initState();
    _controller = context.read<VideoPlayerBloc>().controller;
    _initialized();
  }

  @override
  void dispose() {
    _visibleTimer?.cancel();
    super.dispose();
  }

  void _initialized() {
    _visibleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter++;
        if (_counter == 3) {
          _isVisible = false;
        }
      });
    });
  }

  void _toggleVisibility() {
    setState(() {
      if (_isVisible) return;

      _isVisible = !_isVisible;
      if (_isVisible) _resetTimer();
    });
  }

  void _resetTimer() {
    if (_visibleTimer != null) {
      setState(() {
        _visibleTimer!.cancel();
        _visibleTimer = null;
        _counter = 0;
      });
    }
    _initialized();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        VideoSeekControllWidget(
          onTapCallback: () => _toggleVisibility(),
        ),
        Visibility(
          visible: _isVisible,
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: _controller != null
                      ? ValueListenableBuilder(
                          valueListenable: _controller!.videoPlayerController,
                          builder: (context, value, child) {
                            final isPlaying = value.isPlaying;
                            final isFinished = value.isFinished;

                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: BlocBuilder<VideoPlayerBloc,
                                  VideoPlayerState>(
                                buildWhen: (p, c) =>
                                    p.currentIndex != c.currentIndex,
                                builder: (context, state) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RoundContainer(
                                        onTap: state.hasPreviousQueue
                                            ? () => context
                                                .read<VideoPlayerBloc>()
                                                .add(const VideoPlayerEvent
                                                    .previousQueue())
                                            : null,
                                        child: Icon(
                                          Icons.skip_previous_sharp,
                                          size: _iconSize,
                                          color: state.hasPreviousQueue
                                              ? null
                                              : Colors.black54,
                                        ),
                                      ),
                                      RoundContainer(
                                        child: Icon(
                                          isFinished
                                              ? Icons.replay
                                              : isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                          size: _iconSize + (_iconSize * .3),
                                        ),
                                        onTap: () {
                                          if (isPlaying) {
                                            context.read<VideoPlayerBloc>().add(
                                                const VideoPlayerEvent
                                                    .paused());
                                            return;
                                          }

                                          context.read<VideoPlayerBloc>().add(
                                              const VideoPlayerEvent.resumed());
                                        },
                                      ),
                                      RoundContainer(
                                        onTap: () => context
                                            .read<VideoPlayerBloc>()
                                            .add(const VideoPlayerEvent
                                                .nextQueue()),
                                        child: Icon(
                                          Icons.skip_next_sharp,
                                          size: _iconSize,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const VideoDurationWidget(),
                    GestureDetector(
                      onTap: () => context
                          .read<VideoPlayerBloc>()
                          .add(const VideoPlayerEvent.fullscreenToggled()),
                      child: const Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: VideoProgressSlider(
            showControll: _isVisible,
          ),
        ),
      ],
    );
  }
}

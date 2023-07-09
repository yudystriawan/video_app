import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_app/core/widgets/round_container.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_duration_widget.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_progress_slider.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_seek_controll_widget.dart';

import '../bloc/video_player/video_player_bloc.dart';

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
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _toggleVisibility();
          },
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Visibility(
                  visible: _isVisible,
                  child: Center(
                    child: _controller != null
                        ? ValueListenableBuilder(
                            valueListenable: _controller!.videoPlayerController,
                            builder: (context, value, child) {
                              final isPlaying = value.isPlaying;
                              final isFinished = value.isFinished;

                              return SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RoundContainer(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.skip_previous_sharp,
                                        size: _iconSize,
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
                                              const VideoPlayerEvent.paused());
                                          return;
                                        }

                                        context.read<VideoPlayerBloc>().add(
                                            const VideoPlayerEvent.resumed());
                                      },
                                    ),
                                    RoundContainer(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.skip_next_sharp,
                                        size: _iconSize,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
              Visibility(
                visible: _isVisible,
                child: Positioned(
                  bottom: 10,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const VideoDurationWidget(),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        VideoSeekControllWidget(
          onTapCallback: () => _toggleVisibility(),
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

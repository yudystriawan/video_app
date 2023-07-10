import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoSeekControllWidget extends StatefulWidget {
  const VideoSeekControllWidget({
    super.key,
    required this.onTapCallback,
  });

  final VoidCallback onTapCallback;

  @override
  State<VideoSeekControllWidget> createState() =>
      _VideoSeekControllWidgetState();
}

class _VideoSeekControllWidgetState extends State<VideoSeekControllWidget> {
  bool isForwarding = false;
  bool isRewinding = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // start timer when user skipping
  void startTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 1), () {
      setState(() {
        isRewinding = false;
        isForwarding = false;
      });
    });
  }

  void resetTimer(bool status) {
    timer?.cancel();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: () {
              if (isRewinding) return;

              setState(() {
                isRewinding = true;
                isForwarding = false;
              });

              context
                  .read<VideoPlayerBloc>()
                  .add(const VideoPlayerEvent.skippedBackward());

              startTimer();
            },
            onTap: () {
              if (isRewinding) {
                context
                    .read<VideoPlayerBloc>()
                    .add(const VideoPlayerEvent.skippedBackward());
                resetTimer(isRewinding);
                return;
              }

              widget.onTapCallback.call();
            },
            child: Opacity(
              opacity: isRewinding ? 1 : 0,
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                  color: Colors.white38,
                ),
                child: const Icon(
                  Icons.fast_rewind,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: () {
              if (isForwarding) return;

              setState(() {
                isForwarding = true;
                isRewinding = false;
              });

              context
                  .read<VideoPlayerBloc>()
                  .add(const VideoPlayerEvent.skippedForward());

              startTimer();
            },
            onTap: () {
              if (isForwarding) {
                context
                    .read<VideoPlayerBloc>()
                    .add(const VideoPlayerEvent.skippedForward());
                resetTimer(isForwarding);
                return;
              }

              widget.onTapCallback.call();
            },
            child: Opacity(
              opacity: isForwarding ? 1 : 0,
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                  ),
                  color: Colors.white38,
                ),
                child: const Icon(
                  Icons.fast_forward,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

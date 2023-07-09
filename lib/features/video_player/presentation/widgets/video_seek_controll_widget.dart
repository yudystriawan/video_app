import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoSeekControllWidget extends HookWidget {
  const VideoSeekControllWidget({
    super.key,
    required this.onTapCallback,
  });

  final VoidCallback onTapCallback;

  @override
  Widget build(BuildContext context) {
    final showForwardEffect = useState(false);
    final showRewindEffect = useState(false);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: () {
              showRewindEffect.value = true;

              context
                  .read<VideoPlayerBloc>()
                  .add(const VideoPlayerEvent.skippedBackward());

              Timer(const Duration(seconds: 1), () {
                showRewindEffect.value = false;
              });
            },
            onTap: onTapCallback,
            child: Opacity(
              opacity: showRewindEffect.value ? 1 : 0,
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
              showForwardEffect.value = true;

              context
                  .read<VideoPlayerBloc>()
                  .add(const VideoPlayerEvent.skippedForward());

              Timer(const Duration(seconds: 1), () {
                showForwardEffect.value = false;
              });
            },
            onTap: onTapCallback,
            child: Opacity(
              opacity: showForwardEffect.value ? 1 : 0,
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

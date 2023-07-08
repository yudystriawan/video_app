import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoProgressSlider extends HookWidget {
  const VideoProgressSlider({
    Key? key,
    this.showControll = true,
  }) : super(key: key);

  final bool showControll;

  @override
  Widget build(BuildContext context) {
    final isChanging = useState(false);
    final tempCurrentPosition = useState(0.0);
    final showThumbControll = useState(showControll);

    return ValueListenableBuilder(
      valueListenable:
          context.watch<VideoPlayerBloc>().controller!.videoPlayerController,
      builder: (context, value, child) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: CustomTrackShape(),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10.0),
            thumbShape: CustomThumbShape(
              thumbRadius: showThumbControll.value || showControll ? 8 : 0,
              thumbHeight: 0,
              color: Theme.of(context).primaryColor,
            ),
            inactiveTrackColor: Colors.grey,
          ),
          child: Slider(
            value: isChanging.value
                ? tempCurrentPosition.value
                : value.position.inSeconds.toDouble(),
            min: 0,
            max: value.duration.inSeconds.toDouble(),
            onChanged: (value) {
              tempCurrentPosition.value = value;
            },
            onChangeStart: (value) {
              isChanging.value = true;
              showThumbControll.value = true;
            },
            onChangeEnd: (value) {
              // if isChanging is true
              // assign tempValue to new video player
              if (isChanging.value) {
                final position =
                    Duration(seconds: tempCurrentPosition.value.toInt());

                context
                    .read<VideoPlayerBloc>()
                    .add(VideoPlayerEvent.sought(position));

                isChanging.value = false;
                tempCurrentPosition.value = 0;

                // add delay 3 second to remove thumb controll
                Timer(const Duration(seconds: 3), () {
                  showThumbControll.value = false;
                });
              }
            },
          ),
        );
      },
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop = parentBox.size.height - trackHeight;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CustomThumbShape extends SliderComponentShape {
  final double thumbRadius;
  final double thumbHeight;
  final Color color;

  CustomThumbShape({
    required this.thumbRadius,
    required this.thumbHeight,
    required this.color,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: thumbRadius * 2,
        height: thumbRadius * 2,
      ),
      Radius.circular(thumbRadius),
    );

    final paint = Paint()..color = color;
    canvas.drawRRect(rRect, paint);
  }
}

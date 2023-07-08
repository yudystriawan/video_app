import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/video_player/video_player_bloc.dart';

class VideoProgressSlider extends StatelessWidget {
  const VideoProgressSlider({
    Key? key,
    this.showControll = true,
  }) : super(key: key);

  final bool showControll;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          context.watch<VideoPlayerBloc>().controller!.videoPlayerController,
      builder: (context, value, child) {
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackShape: CustomTrackShape(),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10.0),
            thumbShape: CustomThumbShape(
              thumbRadius: showControll ? 8 : 0,
              thumbHeight: 0,
              color: Theme.of(context).primaryColor,
            ),
            inactiveTrackColor: Colors.grey,
          ),
          child: Slider(
            value: value.position.inSeconds.toDouble(),
            min: 0,
            max: value.duration.inSeconds.toDouble(),
            onChanged: (value) {
              debugPrint('progressChanged: $value');
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

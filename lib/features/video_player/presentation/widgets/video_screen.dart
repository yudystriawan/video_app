import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    Key? key,
    required this.width,
    required this.height,
    this.showControl = true,
    this.controller,
  }) : super(key: key);

  final double width;
  final double height;
  final bool showControl;
  final ChewieController? controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          color: Colors.green,
          child: controller == null
              ? const Center(child: CircularProgressIndicator())
              : ValueListenableBuilder(
                  valueListenable: controller!.videoPlayerController,
                  builder: (context, value, child) {
                    // end duration
                    if (value.position==value.duration) {
                      
                    }
                    return Stack(
                      children: [
                        Chewie(controller: controller!),
                        if (value.isBuffering)
                          const Center(child: CircularProgressIndicator())
                      ],
                    );
                  },
                ),
        )
      ],
    );
  }
}

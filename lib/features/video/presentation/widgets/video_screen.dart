import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    Key? key,
    this.width,
    this.height,
    this.showControl = true,
    this.controller,
  }) : super(key: key);

  final double? width;
  final double? height;
  final bool showControl;
  final ChewieController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.black,
      child: controller == null
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: controller!.videoPlayerController,
              builder: (context, value, child) {
                return Stack(
                  children: [
                    Chewie(controller: controller!),
                    if (value.isBuffering)
                      const Center(child: CircularProgressIndicator())
                  ],
                );
              },
            ),
    );
  }
}

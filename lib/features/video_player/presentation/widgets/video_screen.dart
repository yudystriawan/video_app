import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({
    Key? key,
    required this.width,
    required this.height,
    this.controller,
  }) : super(key: key);

  final double width;
  final double height;
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
              : Chewie(controller: controller!),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class VideoPlayerPage extends StatelessWidget {
  const VideoPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Videos'),
      ),
      body: Container(
        color: Colors.white,
        height: kBottomNavigationBarHeight,
      ),
    );
  }
}

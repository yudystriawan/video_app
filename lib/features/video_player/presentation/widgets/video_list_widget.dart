import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/model/video.dart';
import 'video_item_widget.dart';

class VideoListWidget extends StatelessWidget {
  const VideoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: _getVideos(),
      initialData: const <Video>[],
      builder: (BuildContext context, AsyncSnapshot<List<Video>> snapshot) {
        if (snapshot.hasData) {
          final videos = snapshot.data;
          if (videos == null) return const Text('Kosong');
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: videos.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 32,
                thickness: 3,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final video = videos[index];
              return VideoItemWidget(video: video);
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Terjadi kesalahan');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<List<Video>> _getVideos() async {
    final response = await rootBundle.loadString('assets/media.json');
    final data = await jsonDecode(response);

    final categories = (data['categories'] as List);
    final videosJson = categories.first['videos'] as List;
    final videos = videosJson.map((json) => Video.fromJson(json)).toList();
    return videos;
  }
}

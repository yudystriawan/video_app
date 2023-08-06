import 'package:flutter/material.dart';

import '../../data/model/video.dart';
import 'video_item_widget.dart';

class VideoListWidget extends StatelessWidget {
  const VideoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: getVideos(),
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
}

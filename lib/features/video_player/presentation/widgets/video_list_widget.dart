import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/video_loader/video_loader_bloc.dart';
import 'video_item_widget.dart';

class VideoListWidget extends StatelessWidget {
  const VideoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoLoaderBloc, VideoLoaderState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox(),
          loadInProgress: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          loadFailure: (_) => const SizedBox(),
          loadSuccess: (value) {
            final videos = value.videos;

            if (videos.isEmpty()) return const Text('Kosong');

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: videos.size,
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
          },
        );
      },
    );
  }
}

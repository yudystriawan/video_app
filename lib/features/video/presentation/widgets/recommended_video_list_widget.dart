import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/recommended_video_loader/recommended_video_loader_bloc.dart';
import 'video_item_widget.dart';

class RecommendedVideoListWidget extends StatelessWidget {
  const RecommendedVideoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendedVideoLoaderBloc, RecommendedVideoLoaderState>(
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

            return ListView.builder(
              itemCount: videos.size,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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

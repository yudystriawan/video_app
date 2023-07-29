import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/icon.dart';

import '../../domain/enitities/video.dart';
import '../bloc/mini_player/mini_player_bloc.dart';
import '../bloc/video_player/video_player_bloc.dart';

class VideoItemWidget extends StatelessWidget {
  const VideoItemWidget({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MiniPlayerBloc>().add(const MiniPlayerEvent.expanded());

        context
            .read<VideoPlayerBloc>()
            .add(VideoPlayerEvent.played(video: video));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 360.w,
            height: 215.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(video.thumb),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SizedBox(
            height: 14.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 8.w,
                      ),
                      const Text('Channel Name • 999K views • 1 year ago'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                AppIcon(
                  icon: const Icon(Icons.more_vert),
                  onTap: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
        ],
      ),
    );
  }
}

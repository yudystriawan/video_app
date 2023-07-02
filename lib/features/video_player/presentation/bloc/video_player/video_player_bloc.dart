import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_app/features/video_player/data/model/video.dart';
import 'package:video_player/video_player.dart';

part 'video_player_bloc.freezed.dart';
part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  VideoPlayerBloc() : super(VideoPlayerState.initial()) {
    on<_Played>(_onPlayed);
  }

  void _onPlayed(
    _Played event,
    Emitter<VideoPlayerState> emit,
  ) async {
    // check if selected video different from current video
    final selectedVideo = event.video;
    final currentVideo = state.currentVideo;
    if (selectedVideo != null) {
      
      if (selectedVideo == currentVideo) {
        emit(state.copyWith(
          currentVideo: currentVideo,
          status: VideoPlayerStatus.resume,
        ));
        return;
      }

      await videoPlayerController?.pause();
      await videoPlayerController?.dispose();

      emit(state.copyWith(
        status: VideoPlayerStatus.loading,
        currentVideo: null,
      ));

      try {
        videoPlayerController =
            VideoPlayerController.network(selectedVideo.sources.first);
        await videoPlayerController?.initialize();
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
        );

        emit(state.copyWith(
          status: VideoPlayerStatus.play,
          currentVideo: currentVideo,
        ));
      } catch (e) {
        log('error occured', error: e);
      }
    }
  }

  @override
  Future<void> close() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    return super.close();
  }
}

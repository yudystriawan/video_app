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
  Duration pauseTime = Duration.zero;

  VideoPlayerBloc() : super(VideoPlayerState.initial()) {
    on<_Played>(_onPlayed);
    on<_Stopped>(_onStopped);
    on<_Paused>(_onPaused);
  }

  void _onPlayed(
    _Played event,
    Emitter<VideoPlayerState> emit,
  ) async {
    // check if selected video different from current video
    final selectedVideo = event.video!;
    final currentVideo = state.currentVideo;

    // play new video
    if (videoPlayerController == null || (selectedVideo != currentVideo)) {
      emit(state.copyWith(
        status: VideoPlayerStatus.loading,
        currentVideo: null,
      ));

      try {
        videoPlayerController =
            VideoPlayerController.network(selectedVideo.sources.first);
        await videoPlayerController?.initialize();

        emit(state.copyWith(
          status: VideoPlayerStatus.play,
          currentVideo: currentVideo,
        ));
      } catch (e) {
        log('error occured', error: e);
      }
      return;
    }

    // resume video
    await videoPlayerController!.seekTo(pauseTime);
    await videoPlayerController!.play();
    emit(state.copyWith(
      currentVideo: currentVideo,
      status: VideoPlayerStatus.resume,
    ));
  }

  void _onStopped(
    _Stopped event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (videoPlayerController != null) {
      await videoPlayerController?.pause();
      await videoPlayerController?.dispose();

      _resetValue();

      emit(state.copyWith(
        status: VideoPlayerStatus.stop,
        currentVideo: null,
      ));
    }
  }

  void _resetValue() {
    videoPlayerController = null;
    pauseTime = Duration.zero;
  }

  void _onPaused(
    _Paused event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (videoPlayerController != null) {
      await videoPlayerController!.pause();
      pauseTime = videoPlayerController!.value.duration;

      emit(state.copyWith(
        status: VideoPlayerStatus.pause,
      ));
    }
  }

  @override
  Future<void> close() {
    videoPlayerController?.dispose();
    _resetValue();
    return super.close();
  }
}

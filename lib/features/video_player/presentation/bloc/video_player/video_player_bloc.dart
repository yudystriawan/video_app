// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';
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
    on<_Resumed>(_onResumed);
  }

  void _onPlayed(
    _Played event,
    Emitter<VideoPlayerState> emit,
  ) async {
    // check if selected video different from current video
    final selectedVideo = event.video!;
    final currentVideo = state.currentVideo;
    final isPlaying = state.isPlaying || state.isResume;

    // play new video
    if (videoPlayerController == null || (selectedVideo != currentVideo)) {
      if (isPlaying) await _resetValue();

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
          currentVideo: selectedVideo,
        ));
      } catch (e) {
        log('error occured', error: e);
      }
      return;
    }

    // resume video
    if (state.isPause) {
      await _resumeVideo();
      emit(state.copyWith(
        currentVideo: selectedVideo,
        status: VideoPlayerStatus.resume,
      ));
    }
  }

  void _onStopped(
    _Stopped event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (videoPlayerController != null) {
      await _resetValue();

      emit(state.copyWith(
        status: VideoPlayerStatus.stop,
        currentVideo: null,
      ));
    }
  }

  Future<void> _resetValue() async {
    await videoPlayerController?.pause();
    await videoPlayerController?.dispose();

    videoPlayerController = null;
    pauseTime = Duration.zero;
  }

  void _onPaused(
    _Paused event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (videoPlayerController != null) {
      await videoPlayerController!.pause();
      pauseTime = videoPlayerController!.value.position;

      emit(state.copyWith(
        status: VideoPlayerStatus.pause,
      ));
    }
  }

  void _onResumed(
    _Resumed event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _resumeVideo();
    emit(state.copyWith(
      status: VideoPlayerStatus.resume,
    ));
  }

  Future<void> _resumeVideo() async {
    await videoPlayerController!.seekTo(pauseTime);
    await videoPlayerController!.play();
  }

  @override
  Future<void> close() {
    videoPlayerController?.dispose();
    _resetValue();
    return super.close();
  }
}

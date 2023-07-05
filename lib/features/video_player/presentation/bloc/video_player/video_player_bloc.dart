// ignore_for_file: depend_on_referenced_packages, invalid_use_of_protected_member

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
  bool _isPLaying = false;

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
    final isPlaying = videoPlayerController?.value.isPlaying ?? false;

    // play new video
    if (videoPlayerController == null || (selectedVideo != currentVideo)) {
      emit(state.copyWith(
        currentVideo: null,
        status: VideoStatus.loading,
      ));

      if (isPlaying) await _resetValue();

      try {
        emit(state.copyWith(currentVideo: selectedVideo));

        videoPlayerController =
            VideoPlayerController.network(selectedVideo.sources.first);
        await videoPlayerController!.initialize();
        await videoPlayerController!.play();

        emit(state.copyWith(status: VideoStatus.play));

        // add listener
        if (videoPlayerController!.hasListeners) {
          videoPlayerController!.removeListener(setupListener);
        }

        videoPlayerController!.addListener(setupListener);
      } catch (e) {
        emit(state.copyWith(currentVideo: null));
        log('error occured', error: e);
      }
      return;
    }

    // resume video
    if (!isPlaying) {
      await _resumeVideo();
      emit(state.copyWith(
        currentVideo: selectedVideo,
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
      if (!videoPlayerController!.value.isPlaying) return;
      await videoPlayerController!.pause();
      pauseTime = videoPlayerController!.value.position;
    }
  }

  void _onResumed(
    _Resumed event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _resumeVideo();
  }

  Future<void> _resumeVideo() async {
    await videoPlayerController!.seekTo(pauseTime);
    pauseTime = Duration.zero;
    await videoPlayerController!.play();
  }

  @override
  Future<void> close() {
    videoPlayerController?.removeListener(setupListener);
    videoPlayerController?.dispose();
    _resetValue();
    return super.close();
  }

  void setupListener() {
    var isPlaying = videoPlayerController?.value.isPlaying ?? false;
    if (_isPLaying != isPlaying) {
      _isPLaying = isPlaying;

      // when stop or pause capture current player position
      if (!_isPLaying) {
        pauseTime = videoPlayerController?.value.position ?? Duration.zero;
      }
    }
  }
}

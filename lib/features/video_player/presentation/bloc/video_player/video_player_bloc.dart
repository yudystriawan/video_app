// ignore_for_file: depend_on_referenced_packages, invalid_use_of_protected_member

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_app/features/video_player/data/model/video.dart';
import 'package:video_app/features/video_player/presentation/widgets/video_controls.dart';
import 'package:video_player/video_player.dart';

part 'video_player_bloc.freezed.dart';
part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? controller;

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
    final isPlaying = controller?.isPlaying ?? false;

    // play new video
    if (controller == null || (selectedVideo != currentVideo)) {
      emit(state.copyWith(status: VideoStatus.loading));

      if (isPlaying) await _resetValue();

      try {
        emit(state.copyWith(currentVideo: selectedVideo));

        _videoPlayerController =
            VideoPlayerController.network(selectedVideo.sources.first);
        await _videoPlayerController!.initialize();
        await _videoPlayerController!.play();
        controller = ChewieController(
          videoPlayerController: _videoPlayerController!,
          customControls: const VideoControls(),
        );

        emit(state.copyWith(status: VideoStatus.play));

        // add listener
        if (controller!.hasListeners) {
          controller!.removeListener(setupListener);
        }

        controller!.addListener(setupListener);
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
    if (controller != null) {
      await _resetValue();

      emit(state.copyWith(
        currentVideo: null,
      ));
    }
  }

  Future<void> _resetValue() async {
    await controller?.pause();
    await _videoPlayerController?.dispose();
    controller?.dispose();

    controller = null;
    pauseTime = Duration.zero;
  }

  void _onPaused(
    _Paused event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (controller != null) {
      if (!controller!.isPlaying) return;
      await controller?.pause();
      pauseTime = controller!.videoPlayerController.value.position;
    }
  }

  void _onResumed(
    _Resumed event,
    Emitter<VideoPlayerState> emit,
  ) async {
    await _resumeVideo();
  }

  Future<void> _resumeVideo() async {
    if (controller != null) {
      await controller!.seekTo(pauseTime);
      pauseTime = Duration.zero;
      await controller!.play();
    }
  }

  @override
  Future<void> close() async {
    controller?.removeListener(setupListener);

    _resetValue();
    return super.close();
  }

  void setupListener() {
    log('isPlaying...');
    if (controller != null) {
      var isPlaying = controller!.isPlaying;
      if (_isPLaying != isPlaying) {
        _isPLaying = isPlaying;

        // when stop or pause capture current player position
        if (!_isPLaying) {
          pauseTime = controller!.videoPlayerController.value.position;
        }
      }
    }
  }
}

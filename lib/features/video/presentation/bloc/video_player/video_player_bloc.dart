// ignore_for_file: depend_on_referenced_packages, invalid_use_of_protected_member

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/features/video/domain/usecases/get_recommended_videos.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/enitities/video.dart';
import '../../widgets/video_controls.dart';

part 'video_player_bloc.freezed.dart';
part 'video_player_event.dart';
part 'video_player_state.dart';

@injectable
class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  final List<VideoPlayerController> _videoPlayerControllers = [];
  ChewieController? controller;

  Duration pauseTime = Duration.zero;
  bool _isPLaying = false;

  final GetRecommendedVideos _getRecommendedVideos;

  VideoPlayerBloc(this._getRecommendedVideos)
      : super(VideoPlayerState.initial()) {
    on<_Played>(_onPlayed);
    on<_Stopped>(_onStopped);
    on<_Paused>(_onPaused);
    on<_Resumed>(_onResumed);
    on<_Replayed>(_onReplayed);
    on<_Sought>(_onSought);
    on<_SkippedForward>(_onSkippedForward);
    on<_SkippedBackward>(_onSkippedBackward);
    on<_NextQueue>(_onNextQueue);
    on<_PreviousQueue>(_onPreviousQueue);
  }

  @override
  Future<void> close() async {
    debugPrint('closed');
    controller?.removeListener(setupListener);

    await _resetValue();
    return super.close();
  }

  Future<void> _resetValue() async {
    await controller?.pause();

    for (var controller in _videoPlayerControllers) {
      await controller.pause();
      await controller.dispose();
    }

    _videoPlayerControllers.clear();
    controller?.dispose();

    controller = null;
    pauseTime = Duration.zero;
  }

  Future<void> _resumeVideo() async {
    if (controller != null) {
      await controller!.seekTo(pauseTime);
      pauseTime = Duration.zero;
      await controller!.play();
    }
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

  void _onPlayed(
    _Played event,
    Emitter<VideoPlayerState> emit,
  ) async {
    final selectedVideo = event.video!;
    final currentVideo = state.currentVideo;
    final isPlaying = controller?.isPlaying ?? false;

    // play new video
    if (controller == null || (selectedVideo != currentVideo)) {
      emit(state.copyWith(status: VideoStatus.loading));

      // reset queue
      if (isPlaying) await _resetValue();

      try {
        emit(state.copyWith(
          videoQueue: KtList.from([selectedVideo]),
          currentIndex: 0,
        ));

        // initialize video
        final videoPlayerController =
            VideoPlayerController.network(selectedVideo.sources.first);
        await videoPlayerController.initialize();
        await videoPlayerController.play();

        controller = ChewieController(
          videoPlayerController: videoPlayerController,
          customControls: const VideoControls(),
        );

        // add current play video controller
        _videoPlayerControllers.add(videoPlayerController);

        emit(state.copyWith(
          status: VideoStatus.play,
        ));

        // add listener
        if (controller!.hasListeners) {
          controller!.removeListener(setupListener);
        }

        controller!.addListener(setupListener);
      } catch (e, s) {
        // emit(state.copyWith(currentVideo: null));
        log('_onPlayed', error: e, stackTrace: s);
      }
      return;
    }

    // resume video
    if (!isPlaying) {
      await _resumeVideo();
    }
  }

  void _onReplayed(
    _Replayed event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (controller != null) {
      pauseTime = Duration.zero;
      controller!.seekTo(pauseTime);
      await controller!.play();
    }
  }

  void _onStopped(
    _Stopped event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (controller != null) {
      await _resetValue();
      emit(state.copyWith(
        videoQueue: const KtList.empty(),
      ));
    }
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

  void _onSought(
    _Sought event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (controller != null) {
      final newPosition = event.position;
      controller!.seekTo(newPosition);
    }
  }

  void _onSkippedForward(
    _SkippedForward event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (controller != null) {
      const skipValue = 5;
      final currentPosition =
          controller!.videoPlayerController.value.position.inSeconds;
      controller!.seekTo(Duration(seconds: currentPosition + skipValue));
    }
  }

  void _onSkippedBackward(
    _SkippedBackward event,
    Emitter<VideoPlayerState> emit,
  ) async {
    if (controller != null) {
      const skipValue = 5;
      final currentPosition =
          controller!.videoPlayerController.value.position.inSeconds;
      controller!.seekTo(Duration(seconds: currentPosition - skipValue));
    }
  }

  void _onNextQueue(
    _NextQueue event,
    Emitter<VideoPlayerState> emit,
  ) async {
    int currentIndex = state.currentIndex;
    final queue = state.videoQueue.toMutableList();
    final currentVideo = queue[currentIndex];

    // check if has queue
    if (currentIndex < queue.lastIndex) {
      currentIndex++;

      final nextVideo = queue[currentIndex];

      // initialized new video controller
      controller?.pause();
      final videoPlayerController =
          VideoPlayerController.network(nextVideo.sources.first);
      await videoPlayerController.initialize();
      await videoPlayerController.play();

      controller = ChewieController(
        videoPlayerController: videoPlayerController,
        customControls: const VideoControls(),
        autoPlay: true,
      );

      emit(state.copyWith(currentIndex: currentIndex));
    } else {
      // get more queue video
      final faiureOrVideos =
          await _getRecommendedVideos(const GetRecommendedVideosParams('1'));

      emit(faiureOrVideos.fold(
        (f) => state,
        (videos) {
          queue.addAll(videos);
          return state.copyWith(
            videoQueue: queue,
          );
        },
      ));

      add(const VideoPlayerEvent.nextQueue());
    }
  }

  void _onPreviousQueue(
    _PreviousQueue event,
    Emitter<VideoPlayerState> emit,
  ) async {
    int currentIndex = state.currentIndex;
    final queue = state.videoQueue;

    // check if has queue
    if (currentIndex > 0) {
      currentIndex--;

      final previousVideo = queue[currentIndex];

      // initialized new video controller
      controller?.pause();
      final videoPlayerController =
          VideoPlayerController.network(previousVideo.sources.first);
      await videoPlayerController.initialize();
      await videoPlayerController.play();

      controller = ChewieController(
        videoPlayerController: videoPlayerController,
        customControls: const VideoControls(),
        autoPlay: true,
      );

      emit(state.copyWith(currentIndex: currentIndex));
    }
  }
}

extension VideoPlayerValueX on VideoPlayerValue {
  bool get isFinished => position.inSeconds == duration.inSeconds;
}

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:video_app/features/video_player/data/model/video.dart';

part 'video_player_bloc.freezed.dart';
part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc() : super(VideoPlayerState.initial()) {
    on<VideoPlayerEvent>(_onVideoPlayerEvent);
  }

  Future<void> _onVideoPlayerEvent(
    VideoPlayerEvent event,
    Emitter<VideoPlayerState> emit,
  ) {
    return event.map(
      videoStarted: (e) async {
        if (state.video == e.video) return;
        emit(state.copyWith(
          video: e.video,
          isPlaying: true,
          isPaused: false,
          isResumed: false,
        ));
      },
      videoPaused: (e) async {
        emit(state.copyWith(
          isPlaying: false,
          isPaused: true,
          isResumed: false,
        ));
      },
      videoResumed: (e) async {
        emit(state.copyWith(
          isPlaying: true,
          isPaused: false,
          isResumed: true,
        ));
      },
      videoClosed: (e) async {
        emit(VideoPlayerState.initial());
      },
    );
  }
}

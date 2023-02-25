part of 'video_player_bloc.dart';

@freezed
class VideoPlayerState with _$VideoPlayerState {
  const factory VideoPlayerState({
    required Video video,
  }) = _VideoPlayerState;

  factory VideoPlayerState.initial() => VideoPlayerState(video: Video.empty());
}

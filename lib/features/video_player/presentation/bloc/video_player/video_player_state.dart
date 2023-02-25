part of 'video_player_bloc.dart';

@freezed
class VideoPlayerState with _$VideoPlayerState {
  const factory VideoPlayerState({
    Video? videoSelected,
  }) = _VideoPlayerState;

  factory VideoPlayerState.initial() => const VideoPlayerState();
}

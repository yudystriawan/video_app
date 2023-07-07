part of 'video_player_bloc.dart';

@freezed
class VideoPlayerState with _$VideoPlayerState {
  const VideoPlayerState._();
  const factory VideoPlayerState({
    Video? currentVideo,
    @Default(VideoStatus.initial) VideoStatus status,
  }) = _VideoPlayerState;

  bool get isLoading => status == VideoStatus.loading;
  bool get isPlaying => status == VideoStatus.play;

  factory VideoPlayerState.initial() => const VideoPlayerState();
}

enum VideoStatus {
  initial,
  loading,
  play,
}

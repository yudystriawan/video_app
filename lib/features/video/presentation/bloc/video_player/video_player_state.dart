part of 'video_player_bloc.dart';

@freezed
class VideoPlayerState with _$VideoPlayerState {
  const VideoPlayerState._();
  const factory VideoPlayerState({
    @Default(0) currentIndex,
    required KtList<Video> videoQueue,
    @Default(VideoStatus.initial) VideoStatus status,
  }) = _VideoPlayerState;

  bool get isLoading => status == VideoStatus.loading;
  bool get isPlaying => status == VideoStatus.play;

  bool get hasNextQueue => currentIndex < videoQueue.lastIndex;
  bool get hasPreviousQueue => currentIndex > 0;

  Video? get currentVideo {
    if (videoQueue.isEmpty()) return null;
    return videoQueue[currentIndex];
  }

  factory VideoPlayerState.initial() =>
      const VideoPlayerState(videoQueue: KtList.empty());
}

enum VideoStatus {
  initial,
  loading,
  play,
}

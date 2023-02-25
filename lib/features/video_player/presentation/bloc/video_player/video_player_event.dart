part of 'video_player_bloc.dart';

@freezed
class VideoPlayerEvent with _$VideoPlayerEvent {
  const factory VideoPlayerEvent.videoStarted(Video video) = _VideoStarted;
  const factory VideoPlayerEvent.videoPaused() = _VideoPaused;
  const factory VideoPlayerEvent.videoResumed() = _VideoResumed;
  const factory VideoPlayerEvent.videoClosed() = _VideoClosed;
}

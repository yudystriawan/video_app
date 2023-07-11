part of 'video_player_bloc.dart';

@freezed
class VideoPlayerEvent with _$VideoPlayerEvent {
  const factory VideoPlayerEvent.played({Video? video}) = _Played;
  const factory VideoPlayerEvent.stopped() = _Stopped;
  const factory VideoPlayerEvent.paused() = _Paused;
  const factory VideoPlayerEvent.resumed() = _Resumed;
  const factory VideoPlayerEvent.replayed() = _Replayed;
  const factory VideoPlayerEvent.sought(Duration position) = _Sought;
  const factory VideoPlayerEvent.skippedForward() = _SkippedForward;
  const factory VideoPlayerEvent.skippedBackward() = _SkippedBackward;
}

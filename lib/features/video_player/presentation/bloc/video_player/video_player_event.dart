part of 'video_player_bloc.dart';

@freezed
class VideoPlayerEvent with _$VideoPlayerEvent {
  const factory VideoPlayerEvent.played({Video? video}) = _Played;
  const factory VideoPlayerEvent.stopped() = _Stopped;
  const factory VideoPlayerEvent.paused() = _Paused;
  const factory VideoPlayerEvent.resumed() = _Resumed;
}

part of 'mini_player_bloc.dart';

@freezed
class MiniPlayerEvent with _$MiniPlayerEvent {
  const factory MiniPlayerEvent.initialized({
    required double min,
    required double max,
  }) = _Initialized;
  const factory MiniPlayerEvent.expanded() = _Expanded;
}

part of 'mini_player_bloc.dart';

@freezed
class MiniPlayerState with _$MiniPlayerState {
  const factory MiniPlayerState({
    required double playerExpandProgress,
    required double playerMinHeight,
    required double playerMaxHeight,
  }) = _MiniPlayerState;

  factory MiniPlayerState.initial() {
    return const MiniPlayerState(
      playerExpandProgress: 0,
      playerMinHeight: 0,
      playerMaxHeight: 0,
    );
  }
}

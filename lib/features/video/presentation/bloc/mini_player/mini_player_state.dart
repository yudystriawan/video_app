part of 'mini_player_bloc.dart';

@freezed
class MiniPlayerState with _$MiniPlayerState {
  const factory MiniPlayerState({
    required double playerMinHeight,
    required double playerMaxHeight,
    @Default(false) bool isDismissed,
  }) = _MiniPlayerState;

  factory MiniPlayerState.initial() {
    return const MiniPlayerState(
      playerMinHeight: 0,
      playerMaxHeight: 0,
    );
  }
}

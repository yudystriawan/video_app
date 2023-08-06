import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miniplayer/miniplayer.dart';

part 'mini_player_bloc.freezed.dart';
part 'mini_player_event.dart';
part 'mini_player_state.dart';

double miniplayerPercentageDeclaration = 0.2;

class MiniPlayerBloc extends Bloc<MiniPlayerEvent, MiniPlayerState> {
  MiniplayerController miniplayerController = MiniplayerController();

  MiniPlayerBloc() : super(MiniPlayerState.initial()) {
    on<_Initialized>(_onInitialized);
  }

  void _onInitialized(
    _Initialized event,
    Emitter<MiniPlayerState> emit,
  ) async {
    emit(state.copyWith(
      playerMinHeight: event.min,
      playerMaxHeight: event.max,
      playerExpandProgress: event.min,
    ));
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miniplayer/miniplayer.dart';

part 'mini_player_bloc.freezed.dart';
part 'mini_player_event.dart';
part 'mini_player_state.dart';

double miniplayerPercentageDeclaration = 0.2;

class MiniPlayerBloc extends Bloc<MiniPlayerEvent, MiniPlayerState> {
  MiniplayerController miniplayerController = MiniplayerController();
  ValueNotifier<double> playerExpandProgress = ValueNotifier(0.0);

  MiniPlayerBloc() : super(MiniPlayerState.initial()) {
    on<_Initialized>(_onInitialized);
    on<_Expanded>(_onExpanded);
    on<_Collapsed>(_onCollapsed);
    on<_Dismissed>(_onDismissed);
  }

  @override
  Future<void> close() {
    miniplayerController.dispose();
    return super.close();
  }

  void _onInitialized(
    _Initialized event,
    Emitter<MiniPlayerState> emit,
  ) async {
    if (state == MiniPlayerState.initial()) {
      playerExpandProgress.value = event.min;

      emit(state.copyWith(
        playerMinHeight: event.min,
        playerMaxHeight: event.max,
        isDismissed: false,
      ));
    }
  }

  void _onExpanded(
    _Expanded event,
    Emitter<MiniPlayerState> emit,
  ) async {
    miniplayerController.animateToHeight(state: PanelState.MAX);
    emit(state.copyWith(isDismissed: false));
  }

  void _onCollapsed(
    _Collapsed event,
    Emitter<MiniPlayerState> emit,
  ) async {
    miniplayerController.animateToHeight(state: PanelState.MIN);
    emit(state.copyWith(isDismissed: false));
  }

  void _onDismissed(
    _Dismissed event,
    Emitter<MiniPlayerState> emit,
  ) async {
    emit(state.copyWith(isDismissed: true));
  }
}

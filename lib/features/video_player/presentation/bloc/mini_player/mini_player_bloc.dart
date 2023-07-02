import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mini_player_event.dart';
part 'mini_player_state.dart';
part 'mini_player_bloc.freezed.dart';

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

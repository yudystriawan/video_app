// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/core/usecases/usecase.dart';
import 'package:video_app/features/video_player/domain/usecases/get_videos.dart';

import '../../../domain/enitities/video.dart';

part 'video_loader_bloc.freezed.dart';
part 'video_loader_event.dart';
part 'video_loader_state.dart';

@injectable
class VideoLoaderBloc extends Bloc<VideoLoaderEvent, VideoLoaderState> {
  final GetVideos _getVideos;

  VideoLoaderBloc(
    this._getVideos,
  ) : super(const VideoLoaderState.initial()) {
    on<_Fetched>(_onFetched);
  }

  void _onFetched(
    _Fetched event,
    Emitter<VideoLoaderState> emit,
  ) async {
    emit(const VideoLoaderState.loadInProgress());

    final failureOrVideos = await _getVideos(const NoParams());

    emit(failureOrVideos.fold(
      (f) => VideoLoaderState.loadFailure(f),
      (videos) => VideoLoaderState.loadSuccess(videos),
    ));
  }
}

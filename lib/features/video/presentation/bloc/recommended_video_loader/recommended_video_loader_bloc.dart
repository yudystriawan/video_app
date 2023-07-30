// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/features/video/domain/usecases/get_recommended_videos.dart';

import '../../../domain/enitities/video.dart';

part 'recommended_video_loader_bloc.freezed.dart';
part 'recommended_video_loader_event.dart';
part 'recommended_video_loader_state.dart';

@injectable
class RecommendedVideoLoaderBloc
    extends Bloc<RecommendedVideoLoaderEvent, RecommendedVideoLoaderState> {
  final GetRecommendedVideos _getRecommendedVideos;

  RecommendedVideoLoaderBloc(
    this._getRecommendedVideos,
  ) : super(const RecommendedVideoLoaderState.initial()) {
    on<_Fetched>(_onFetched);
  }

  void _onFetched(
    _Fetched event,
    Emitter<RecommendedVideoLoaderState> emit,
  ) async {
    emit(const RecommendedVideoLoaderState.loadInProgress());

    final failureOrVideos =
        await _getRecommendedVideos(GetRecommendedVideosParams(event.videoId));

    emit(failureOrVideos.fold(
      (f) => RecommendedVideoLoaderState.loadFailure(f),
      (videos) => RecommendedVideoLoaderState.loadSuccess(videos),
    ));
  }
}

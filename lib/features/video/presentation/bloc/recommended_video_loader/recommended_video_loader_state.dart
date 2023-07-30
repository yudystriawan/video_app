part of 'recommended_video_loader_bloc.dart';

@freezed
class RecommendedVideoLoaderState with _$RecommendedVideoLoaderState {
  const factory RecommendedVideoLoaderState.initial() = _Initial;
  const factory RecommendedVideoLoaderState.loadInProgress() = _LoadInProgress;
  const factory RecommendedVideoLoaderState.loadFailure(Failure failure) =
      _LoadFailure;
  const factory RecommendedVideoLoaderState.loadSuccess(KtList<Video> videos) =
      _LoadSuccess;
}

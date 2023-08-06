part of 'video_loader_bloc.dart';

@freezed
class VideoLoaderState with _$VideoLoaderState {
  const factory VideoLoaderState.initial() = _Initial;
  const factory VideoLoaderState.loadInProgress() = _LoadInProgress;
  const factory VideoLoaderState.loadFailure(Failure failure) = _LoadFailure;
  const factory VideoLoaderState.loadSuccess(KtList<Video> videos) =
      _LoadSuccess;
}

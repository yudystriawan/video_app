part of 'recommended_video_loader_bloc.dart';

@freezed
class RecommendedVideoLoaderEvent with _$RecommendedVideoLoaderEvent {
  const factory RecommendedVideoLoaderEvent.fetched(String videoId) = _Fetched;
}

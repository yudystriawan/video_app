part of 'video_loader_bloc.dart';

@freezed
class VideoLoaderEvent with _$VideoLoaderEvent {
  const factory VideoLoaderEvent.fetched() = _Fetched;
}

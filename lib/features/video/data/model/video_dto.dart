import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enitities/video.dart';

part 'video_dto.freezed.dart';
part 'video_dto.g.dart';

@freezed
class VideoDto with _$VideoDto {
  const VideoDto._();
  const factory VideoDto({
    String? description,
    List<String>? sources,
    String? subtitle,
    String? thumb,
    String? title,
  }) = _VideoDto;

  Video toDomain() {
    final emptyVideo = Video.empty();
    return Video(
      description: description ?? emptyVideo.description,
      sources: sources ?? emptyVideo.sources,
      subtitle: subtitle ?? emptyVideo.subtitle,
      thumb: thumb ?? emptyVideo.thumb,
      title: title ?? emptyVideo.title,
    );
  }

  factory VideoDto.fromJson(Map<String, dynamic> json) =>
      _$VideoDtoFromJson(json);
}

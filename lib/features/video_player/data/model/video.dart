import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';
part 'video.g.dart';

@freezed
class Video with _$Video {
  const factory Video({
    required String description,
    required List<String> sources,
    required String subtitle,
    required String thumb,
    required String title,
  }) = _Video;

  factory Video.empty() => const Video(
        description: '',
        sources: [],
        subtitle: '',
        thumb: '',
        title: '',
      );

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
}

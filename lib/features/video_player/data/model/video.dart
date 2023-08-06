import 'dart:convert';

import 'package:flutter/services.dart';
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

Future<List<Video>> getVideos() async {
  final response = await rootBundle.loadString('assets/media.json');
  final data = await jsonDecode(response);

  final categories = (data['categories'] as List);
  final videosJson = categories.first['videos'] as List;
  final videos = videosJson.map((json) => Video.fromJson(json)).toList();
  return videos;
}

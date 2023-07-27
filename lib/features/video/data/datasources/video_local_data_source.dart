import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../model/video_dto.dart';

abstract class VideoLocalDataSource {
  Future<List<VideoDto>?> getVideos({String? query});
}

@Injectable(as: VideoLocalDataSource)
class VideoLocalDataSourceImpl implements VideoLocalDataSource {
  @override
  Future<List<VideoDto>?> getVideos({String? query}) async {
    try {
      final response = await rootBundle.loadString('assets/media.json');
      final data = await jsonDecode(response);

      final categories = (data['categories'] as List);
      final videosJson = categories.first['videos'] as List;
      final videos = videosJson.map((json) => VideoDto.fromJson(json)).toList();

      // get video that contains [query]
      if (query != null && query.isNotEmpty) {
        return videos
            .where((video) =>
                video.title?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      }

      return videos;
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }
}

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:video_app/core/errors/failures.dart';

import '../model/video_dto.dart';

abstract class VideoLocalDataSource {
  Future<List<VideoDto>?> getVideos();
}

class VideoLocalDataSourceImpl implements VideoLocalDataSource {
  @override
  Future<List<VideoDto>?> getVideos() async {
    try {
      final response = await rootBundle.loadString('assets/media.json');
      final data = await jsonDecode(response);

      final categories = (data['categories'] as List);
      final videosJson = categories.first['videos'] as List;
      final videos = videosJson.map((json) => VideoDto.fromJson(json)).toList();
      return videos;
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }
}

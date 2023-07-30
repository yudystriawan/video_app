import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/enitities/video.dart';
import '../../domain/repositories/video_repository.dart';
import '../datasources/video_local_data_source.dart';

@Injectable(as: VideoRepository)
class VideoRepositoryImpl implements VideoRepository {
  final VideoLocalDataSource _dataSource;

  VideoRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, KtList<Video>>> getVideos({String? query}) async {
    try {
      final result = await _dataSource.getVideos(query: query);

      final videos = result?.map((e) => e.toDomain()).toImmutableList();

      return right(videos ?? const KtList.empty());
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, KtList<Video>>> getRecommendedVideos(
      String videoId) async {
    try {
      final result = await _dataSource.getRecommendedVideos(videoId);

      final videos = result?.map((e) => e.toDomain()).toImmutableList();

      return right(videos ?? const KtList.empty());
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}

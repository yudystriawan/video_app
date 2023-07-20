import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/features/video_player/data/datasources/video_local_data_source.dart';
import 'package:video_app/features/video_player/domain/enitities/video.dart';
import 'package:video_app/features/video_player/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoLocalDataSource _dataSource;

  VideoRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, KtList<Video>>> getVideos() async {
    try {
      final result = await _dataSource.getVideos();

      final videos = result?.map((e) => e.toDomain()).toImmutableList();

      return right(videos ?? const KtList.empty());
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}

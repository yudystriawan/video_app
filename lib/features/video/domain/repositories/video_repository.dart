import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

import '../../../../core/errors/failures.dart';
import '../enitities/video.dart';

abstract class VideoRepository {
  Future<Either<Failure, KtList<Video>>> getVideos({String? query});
  Future<Either<Failure, KtList<Video>>> getRecommendedVideos(String videoId);
}

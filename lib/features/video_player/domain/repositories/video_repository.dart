import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/features/video_player/domain/enitities/video.dart';

import '../../../../core/errors/failures.dart';

abstract class VideoRepository {
  Future<Either<Failure, KtList<Video>>> getVideos({String? query});
}

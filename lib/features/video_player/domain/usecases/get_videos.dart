import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/core/usecases/usecase.dart';
import 'package:video_app/features/video_player/domain/repositories/video_repository.dart';

import '../enitities/video.dart';

class GetVideos implements Usecase<KtList<Video>, NoParams> {
  final VideoRepository _repository;

  GetVideos(this._repository);

  @override
  Future<Either<Failure, KtList<Video>>> call(NoParams params) async {
    return await _repository.getVideos();
  }
}

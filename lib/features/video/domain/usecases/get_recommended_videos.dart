import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../enitities/video.dart';
import '../repositories/video_repository.dart';

@injectable
class GetRecommendedVideos
    implements Usecase<KtList<Video>, GetRecommendedVideosParams> {
  final VideoRepository _repository;

  GetRecommendedVideos(this._repository);

  @override
  Future<Either<Failure, KtList<Video>>> call(
      GetRecommendedVideosParams params) async {
    return await _repository.getRecommendedVideos(params.id);
  }
}

class GetRecommendedVideosParams extends Equatable {
  final String id;

  const GetRecommendedVideosParams(this.id);

  @override
  List<Object?> get props => [id];
}

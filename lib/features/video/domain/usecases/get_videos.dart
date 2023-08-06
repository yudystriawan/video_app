import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../enitities/video.dart';
import '../repositories/video_repository.dart';

@injectable
class GetVideos implements Usecase<KtList<Video>, GetVideosParams> {
  final VideoRepository _repository;

  GetVideos(this._repository);

  @override
  Future<Either<Failure, KtList<Video>>> call(GetVideosParams params) async {
    return await _repository.getVideos(query: params.query);
  }
}

class GetVideosParams extends Equatable {
  final String? query;

  const GetVideosParams(this.query);

  @override
  List<Object?> get props => [query];
}

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/core/usecases/usecase.dart';
import 'package:video_app/features/video_player/domain/repositories/video_repository.dart';

import '../enitities/video.dart';

@injectable
class GetVideos implements Usecase<KtList<Video>, Params> {
  final VideoRepository _repository;

  GetVideos(this._repository);

  @override
  Future<Either<Failure, KtList<Video>>> call(Params params) async {
    return await _repository.getVideos(query: params.query);
  }
}

class Params extends Equatable {
  final String? query;

  const Params(this.query);

  @override
  List<Object?> get props => [query];
}

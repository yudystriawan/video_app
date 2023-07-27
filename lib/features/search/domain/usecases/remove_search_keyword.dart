import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/core/usecases/usecase.dart';
import 'package:video_app/features/search/domain/repositories/search_repository.dart';

class RemoveSearchParams extends Equatable {
  final String keyword;

  const RemoveSearchParams(this.keyword);

  @override
  List<Object> get props => [keyword];
}

@injectable
class RemoveSearchKeyword implements Usecase<Unit, RemoveSearchParams> {
  final SearchRepository _repository;

  RemoveSearchKeyword(this._repository);

  @override
  Future<Either<Failure, Unit>> call(RemoveSearchParams params) async {
    return await _repository.removeKeyword(params.keyword);
  }
}

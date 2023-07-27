import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/core/usecases/usecase.dart';
import 'package:video_app/features/search/domain/repositories/search_repository.dart';

class SaveSearchKeywordParams extends Equatable {
  final String keyword;

  const SaveSearchKeywordParams(this.keyword);

  @override
  List<Object> get props => [keyword];
}

@injectable
class SaveSearchKeyword implements Usecase<Unit, SaveSearchKeywordParams> {
  final SearchRepository _repository;

  SaveSearchKeyword(this._repository);

  @override
  Future<Either<Failure, Unit>> call(SaveSearchKeywordParams params) async {
    return await _repository.saveKeyword(params.keyword);
  }
}

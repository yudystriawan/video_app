import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/query.dart';
import '../repositories/search_repository.dart';

class GetSearchParams extends Equatable {
  final String? keyword;

  const GetSearchParams(this.keyword);

  @override
  List<Object?> get props => [keyword];
}

@injectable
class GetSearchHistory implements Usecase<KtList<String>, GetSearchParams> {
  final SearchRepository _repository;

  GetSearchHistory(this._repository);

  @override
  Future<Either<Failure, KtList<String>>> call(GetSearchParams params) async {
    return await _repository.getSearchHistory(Query(keyword: params.keyword));
  }
}

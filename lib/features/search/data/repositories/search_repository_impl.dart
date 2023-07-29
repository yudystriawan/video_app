import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:video_app/core/errors/failures.dart';
import 'package:video_app/features/search/data/datasources/search_local_data_source.dart';
import 'package:video_app/features/search/domain/entities/query.dart';

import '../../domain/repositories/search_repository.dart';

@Injectable(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource _localDataSource;

  SearchRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, KtList<String>>> getSearchHistory(Query query) async {
    try {
      final result =
          await _localDataSource.getHistories(keyword: query.keyword);
      return right(result.toImmutableList());
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeKeyword(String keyword) async {
    try {
      await _localDataSource.deleteKeyword(keyword);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveKeyword(String keyword) async {
    try {
      await _localDataSource.storeKeyword(keyword);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}

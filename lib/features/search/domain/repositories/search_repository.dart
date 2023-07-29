import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

import '../../../../core/errors/failures.dart';
import '../entities/query.dart';

abstract class SearchRepository {
  Future<Either<Failure, KtList<String>>> getSearchHistory(Query query);
  Future<Either<Failure, Unit>> saveKeyword(String keyword);
  Future<Either<Failure, Unit>> removeKeyword(String keyword);
}

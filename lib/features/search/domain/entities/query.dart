import 'package:freezed_annotation/freezed_annotation.dart';

part 'query.freezed.dart';

@freezed
class Query with _$Query {
  const Query._();
  const factory Query({
    String? keyword,
  }) = _Query;
}
